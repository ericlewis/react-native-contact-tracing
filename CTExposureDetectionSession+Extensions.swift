import ContactTracing

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