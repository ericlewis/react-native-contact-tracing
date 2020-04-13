#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(ContactTracing, RCTEventEmitter)

RCT_EXTERN_METHOD(startContactTracing)
RCT_EXTERN_METHOD(stopContactTracing)
RCT_EXTERN_METHOD(requestExposureSummary)

@end
