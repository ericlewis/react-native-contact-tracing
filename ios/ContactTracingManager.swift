import Foundation
import ContactTracing

@objc(ContactTracingManager)
public class ContactTracingManager: RCTEventEmitter {
    static let receivedExposureDetectionSummary = "receivedExposureDetectionSummary"
    static let receivedContactInformation = "receivedContactInformation"
    static let stateDidChange = "stateDidChange"
    static let authorizationDidChange = "authorizationDidChange"

    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "com.ericlewis.react-native-contact-tracing")
    
    public override func supportedEvents() -> [String]! {
        [
            Self.receivedExposureDetectionSummary,
            Self.receivedContactInformation,
            Self.stateDidChange,
            Self.authorizationDidChange
        ]
    }
    
    public override func constantsToExport() -> [AnyHashable : Any]! {
        [:]
    }
    
    @objc
    public override static func requiresMainQueueSetup() -> Bool {
        true
    }
    
    private(set) var state: CTManagerState = .unknown {
        didSet {
            guard oldValue != state else { return }
            self.sendEvent(withName: Self.stateDidChange,
                           body: state)
        }
    }
    
    private(set) var authorized: Bool = false {
        didSet {
            guard oldValue != authorized else { return }
            self.sendEvent(withName: Self.authorizationDidChange,
                           body: authorized)
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
    
    @objc
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
    
    @objc
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
    
    @objc
    func requestExposureSummary() {
        guard authorized, let session = currentSession else { return }
        
        let selfTracingInfoRequest = CTSelfTracingInfoRequest()
        selfTracingInfoRequest.dispatchQueue = self.dispatchQueue
        
        selfTracingInfoRequest.completionHandler = { (tracingInfo, error) in
            guard error != nil else { return /* handle error */ }
            guard let dailyTracingKeys = tracingInfo?.dailyTracingKeys else { return }
            
            session.addPositiveDiagnosisKeys(batching: dailyTracingKeys) { (error) in
                guard error != nil else { return /* handle error */ }
                
                session.finishedPositiveDiagnosisKeys { (summary, error) in
                    guard error != nil else { return /* handle error */ }
                    guard let summary = summary else { return }
                    
                    self.sendEvent(withName: Self.receivedExposureDetectionSummary,
                                   body: summary)
                    
                    session.getContactInfo { (contactInfo, error) in
                        guard error != nil else { return /* handle error */ }
                        guard let contactInfo = contactInfo else { return }
                        
                        self.sendEvent(withName: Self.receivedContactInformation,
                                       body: contactInfo)
                    }
                }
            }
        }
    }
}

extension CTExposureDetectionSession {
    func addPositiveDiagnosisKeys(batching keys: [CTDailyTracingKey], completion: CTErrorHandler) {
        if keys.isEmpty {
            completion(nil)
        } else {
            let cursor = keys.index(keys.startIndex, offsetBy: maxKeyCount, limitedBy: keys.endIndex) ?? keys.endIndex
            let batch = Array(keys.prefix(upTo: cursor))
            let remaining = Array(keys.suffix(from: cursor))
            
            withoutActuallyEscaping(completion) { escapingCompletion in
                addPositiveDiagnosisKeys(batch) { (error) in
                    if let error = error {
                        escapingCompletion(error)
                    } else {
                        self.addPositiveDiagnosisKeys(batching: remaining, completion: escapingCompletion)
                    }
                }
            }
        }
    }
}
