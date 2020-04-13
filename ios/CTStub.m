#import "CTStub.h"

@implementation CTContactInfo

@end

@implementation CTDailyTracingKey

@end

@implementation CTExposureDetectionSession

- (void)activateWithCompletion:(nullable CTErrorHandler)inCompletion
{
    inCompletion(NULL);
}

- (void)addPositiveDiagnosisKeys:(NSArray <CTDailyTracingKey *> *)inKeys
                      completion:(nullable CTErrorHandler)inCompletion
{
    inCompletion(NULL);
}

- (void)finishedPositiveDiagnosisKeysWithCompletion:(nullable CTExposureDetectionFinishHandler)inFinishHandler
{
    inFinishHandler(NULL, NULL);
}

- (void)getContactInfoWithHandler:(nullable CTExposureDetectionContactHandler)inHandler
{
    inHandler(NULL, NULL);
}

- (void)invalidate
{
    // NOOP
}

@end

@implementation CTSelfTracingInfoRequest

- (void)perform
{
    // NOOP
}

- (void)invalidate
{
    // NOOP
}

@end

@implementation CTStateGetRequest

- (void)perform
{
    // NOOP
}

- (void)invalidate
{
    // NOOP
}

@end

@implementation CTStateSetRequest

- (void)perform
{
    // NOOP
}

- (void)invalidate
{
    // NOOP
}

@end
