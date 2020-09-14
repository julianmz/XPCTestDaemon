#ifndef XPCTD_IREQUESTPROCESSORIG
#define XPCTD_IREQUESTPROCESSORIG

#import <Foundation/Foundation.h>

@protocol XPCTD_IRequestProcessor

- (void)ProcessRequest:(int)requestId string:(NSString*)string replyBlock:(void (^)(int, NSString*))replyBlock;

@end

#endif
