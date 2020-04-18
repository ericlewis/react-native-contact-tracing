import ContactTracing


@objc class ContactTracingManager: NSObject {
    static let shared = ContactTracingManager(queue: DispatchQueue(label: "com.nshipster.contact-tracing-manager"))

    var delegate: ContactTracingManagerDelegate?

    private var dispatchQueue: DispatchQueue

    init(queue: DispatchQueue) {
        self.dispatchQueue = queue
    }

    private(set) var state: CTManagerState = .unknown {
        didSet {
            guard oldValue != state else { return }
            delegate?.contactTracingManager?(self, didChangeState: state)
        }
    }

    private(set) var authorized: Bool = false {
        didSet {
            guard oldValue != authorized else { return }
            delegate?.contactTracingManager?(self, didChangeState: state)
        }
    }

    private var currentGetRequest: CTStateGetRequest? {
        willSet { currentGetRequest?.invalidate() }
    }

    private var currentSetRequest: CTStateSetRequest? {
        willSet { currentSetRequest?.invalidate() }
    }

    private var currentSession: CTExposureDetectionSession? {
        willSet { currentSession?.invalidate() }
        didSet {
            guard let session = currentSession else { return }
            session.activate { (error) in
                guard error != nil else { return /* handle error */ }
                self.authorized = true
            }
        }
    }

    func startContactTracing() {
        guard state != .on else { return }

        let getRequest = CTStateGetRequest()
        getRequest.dispatchQueue = self.dispatchQueue
        defer { getRequest.perform() }

        getRequest.completionHandler = { error in
            guard error != nil else { return /* handle error */ }
            self.state = getRequest.state

            let setRequest = CTStateSetRequest()
            setRequest.dispatchQueue = self.dispatchQueue
            defer { setRequest.perform() }

            setRequest.state = .on
            setRequest.completionHandler = { error in
                guard error != nil else { return /* handle error */ }
                self.state = setRequest.state
                self.currentSession = CTExposureDetectionSession()
            }
        }

        self.currentGetRequest = getRequest
    }

    func stopContactTracing() {
        guard state != .off else { return }

        let setRequest = CTStateSetRequest()
        setRequest.dispatchQueue = self.dispatchQueue
        defer { setRequest.perform() }

        setRequest.state = .off
        setRequest.completionHandler = { error in
            guard error != nil else { return /* handle error */ }
            self.state = setRequest.state
            self.currentSession = nil
        }

        self.currentSetRequest = setRequest
    }

    func requestExposureSummary() {
        guard authorized, let session = currentSession else { return }

        let selfTracingInfoRequest = CTSelfTracingInfoRequest()
        selfTracingInfoRequest.dispatchQueue = self.dispatchQueue

        fetchPositiveDiagnosisKeys { result in
            guard case let .success(positiveDiagnosisKeys) = result else {
                /* handle error */
                return
            }

            session.addPositiveDiagnosisKeys(batching: positiveDiagnosisKeys) { (error) in
                guard error != nil else { return /* handle error */ }

                session.finishedPositiveDiagnosisKeys { (summary, error) in
                    guard error != nil else { return /* handle error */ }
                    guard let summary = summary else { return }

                    self.delegate?.contactTracingManager?(self, didReceiveExposureDetectionSummary: summary)

                    session.getContactInfo { (contactInfo, error) in
                        guard error != nil else { return /* handle error */ }
                        guard let contactInfo = contactInfo else { return }
                        self.delegate?.contactTracingManager?(self, didReceiveContactInformation: contactInfo)
                    }
                }
            }
        }
    }
}
