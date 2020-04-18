import ContactTracing

@objc protocol ContactTracingManagerDelegate: class {
    @objc optional func contactTracingManager(_ manager: ContactTracingManager,
                                             didChangeState state: CTManagerState)
    @objc optional func contactTracingManager(_ manager: ContactTracingManager,
                                             didChangeAuthorization authorized: Bool)
    @objc optional func contactTracingManager(_ manager: ContactTracingManager,
                                             didFailWithError error: Error)
    @objc optional func contactTracingManager(_ manager: ContactTracingManager,
                                             didReceiveExposureDetectionSummary summary: CTExposureDetectionSummary)
    @objc optional func contactTracingManager(_ manager: ContactTracingManager,
                                             didReceiveContactInformation contactInfo: [CTContactInfo])
}