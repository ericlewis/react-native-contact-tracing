import Foundation

@objc(ContactTracing)
public class ContactTracing: RCTEventEmitter {
    
    /// Events
    static let exposureDetectionSummaryReceived = "exposureDetectionSummaryReceived"
    static let contactInformationReceived = "contactInformationReceived"
    static let stateDidChange = "stateDidChange"
    static let authorizationDidChange = "authorizationDidChange"
    static let onError = "onError"
    static let onExposure = "onExposure"
    
    static let errorKey = "CT_ERROR"

    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "com.ericlewis.react-native-contact-tracing")
    
    public override func supportedEvents() -> [String]! {
        [
            Self.exposureDetectionSummaryReceived,
            Self.contactInformationReceived,
            Self.stateDidChange,
            Self.authorizationDidChange,
            Self.onError,
            Self.onExposure
        ]
    }
    
    public override func constantsToExport() -> [AnyHashable : Any]! {
        ["supported": true] // this is basically always true, the limit is based on iOS version.
    }
    
    @objc
    public override static func requiresMainQueueSetup() -> Bool {
        true
    }
    
    private(set) var state: CTManagerState = .unknown {
        didSet {
            guard oldValue != state else { return }
            self.sendEvent(withName: Self.stateDidChange,
                           body: state.rawValue)
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
                guard error != nil else {
                    self.sendEvent(withName: Self.onError, body: error?.localizedDescription)
                    return
                }
                self.authorized = true
            }
        }
    }
    
    @objc
    func start(_ resolve: @escaping RCTPromiseResolveBlock,
               reject: @escaping RCTPromiseRejectBlock) {
        guard state != .on else { return }
        
        let getRequest = CTStateGetRequest()
        getRequest.dispatchQueue = self.dispatchQueue
        defer { getRequest.perform() }
        
        getRequest.completionHandler = { error in
            guard error != nil else { return reject(Self.errorKey, "getRequest", error) }
            self.state = getRequest.state
            
            let setRequest = CTStateSetRequest()
            setRequest.dispatchQueue = self.dispatchQueue
            defer { setRequest.perform() }
            
            setRequest.state = .on
            setRequest.completionHandler = { error in
                guard error != nil else { return reject(Self.errorKey, "setRequest", error) }
                self.state = setRequest.state
                self.currentSession = CTExposureDetectionSession()
                resolve(nil)
            }
        }
        
        self.currentGetRequest = getRequest
    }
    
    @objc
    func stop(_ resolve: @escaping RCTPromiseResolveBlock,
              reject: @escaping RCTPromiseRejectBlock) {
        guard state != .off else { return }
        
        let setRequest = CTStateSetRequest()
        setRequest.dispatchQueue = self.dispatchQueue
        defer { setRequest.perform() }
        
        setRequest.state = .off
        setRequest.completionHandler = { error in
            guard error != nil else { return reject(Self.errorKey, "setRequest", error) }
            self.state = setRequest.state
            self.currentSession = nil
            resolve(nil)
        }
        
        self.currentSetRequest = setRequest
    }
    
    @objc
    func requestExposureSummary(_ resolve: @escaping RCTPromiseResolveBlock,
                                reject: @escaping RCTPromiseRejectBlock) {
        guard authorized, let session = currentSession else { return }
        
        let selfTracingInfoRequest = CTSelfTracingInfoRequest()
        selfTracingInfoRequest.dispatchQueue = self.dispatchQueue
        
        selfTracingInfoRequest.completionHandler = { (tracingInfo, error) in
            guard error != nil else { return reject(Self.errorKey, "selfTracingInfoRequest", error) }
            guard let dailyTracingKeys = tracingInfo?.dailyTracingKeys else { return }
            
            session.addPositiveDiagnosisKeys(batching: dailyTracingKeys) { (error) in
                guard error != nil else { return reject(Self.errorKey, "addPositiveDiagnosisKeys", error) }

                session.finishedPositiveDiagnosisKeys { (summary, error) in
                    guard error != nil else { return reject(Self.errorKey, "finishedPositiveDiagnosisKeys", error) }
                    guard let summary = summary else { return }
                    
                    self.sendEvent(withName: Self.exposureDetectionSummaryReceived,
                                   body: summary.matchedKeyCount)
                    
                    if summary.matchedKeyCount > 0 {
                        self.sendEvent(withName: Self.onExposure,
                                       body: nil)
                    }
                    
                    session.getContactInfo { (contactInfo, error) in
                        guard error != nil else { return reject(Self.errorKey, "getContactInfo", error) }
                        guard let contactInfo = contactInfo?.map({ ["duration": $0.duration, "timestamp": $0.timestamp] })
                        else { return }
                        
                        self.sendEvent(withName: Self.contactInformationReceived,
                                       body: contactInfo)
                        
                        resolve(["matchedKeyCount": summary.matchedKeyCount, "contactInformation": contactInfo])
                    }
                }
            }
        }
    }
    
    @objc
    func currentStatus(_ resolve: @escaping RCTPromiseResolveBlock,
                       reject: @escaping RCTPromiseRejectBlock) {
        resolve(state.rawValue)
    }
}
