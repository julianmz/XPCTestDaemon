#import <XPCTestDaemon/Private/RequestProcessor.h>

@implementation XPCTD_RequestProcessor

- (void)ProcessRequest:(int)requestId string:(NSString*)string replyBlock:(void (^)(int, NSString*))replyBlock {
    
    NSLog(@"Processing request with id %i and string: \"%@\"...", requestId, string);
    
    int responseInt = 0;
    NSString* responseString = nil;
    
    switch(requestId) {
            
        case 0:
            
            responseInt = 1;
            responseString = @"ABC ABC ABC ABC";
            break;
            
        case 1:
            
            responseInt = 2;
            responseString = @"DEF DEF DEF DEF DEF DEF";
            
            [NSThread sleepForTimeInterval:1.0];
            break;
            
        case 2:
        
            responseInt = 3;
            responseString = @"GHI GHI";
            
            [NSThread sleepForTimeInterval:2.0];
            break;
            
        default:
            
            responseInt = 4;
            responseString = @"JKL";
            
            [NSThread sleepForTimeInterval:3.0];
    }
    
    replyBlock(responseInt, responseString);
    
    NSLog(@"Request processed");
}

@end
