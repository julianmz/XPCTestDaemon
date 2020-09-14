#import <Foundation/Foundation.h>

#import <XPCTestDaemon/IRequestProcessor.h>

#import <XPCTestClient/Private/Exception.h>

#define NAME_XPCTESTDAEMON_MACH_SERVICE @"com.jmz.xpctestdaemon"

static dispatch_semaphore_t replySemaphore;

static void ProcessReply(int replyId, NSString* string);
static void WaitRPCCompletion(void);

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        
        NSXPCConnection* xpcConnection = [[NSXPCConnection alloc] initWithMachServiceName:NAME_XPCTESTDAEMON_MACH_SERVICE
                                                                                  options:NSXPCConnectionPrivileged];
        if(!xpcConnection)
            XPCTC_THROW_EXCEPTION(@"XPC connection could not be created");
        
        NSLog(@"XPC connection created");
        
        xpcConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(XPCTD_IRequestProcessor)];
        if(!xpcConnection.remoteObjectInterface)
            XPCTC_THROW_EXCEPTION(@"XPC interface could not be created");
        
        NSLog(@"XPC interface created");
        
        xpcConnection.invalidationHandler = ^{ NSLog(@"XPC connection invalidated"); };
        xpcConnection.interruptionHandler = ^{ NSLog(@"XPC connection interrupted"); };
        
        [xpcConnection resume];
        
        NSLog(@"XPC connection resumed");
        
        // RPCs happen in an async fashion; utilizie semaphore to achieve sync behavior
        replySemaphore = dispatch_semaphore_create(0);
        
        // RPC into daemon
        [xpcConnection.remoteObjectProxy ProcessRequest:0
                                                 string:@"This is the first request"
                                             replyBlock:^(int replyId, NSString* string){ ProcessReply(replyId, string); }];
        
        WaitRPCCompletion();
        
        [xpcConnection.remoteObjectProxy ProcessRequest:1
                                                 string:@"This is the second request"
                                             replyBlock:^(int replyId, NSString* string){ ProcessReply(replyId, string); }];
        
        WaitRPCCompletion();
        
        [xpcConnection.remoteObjectProxy ProcessRequest:2
                                                 string:@"This is the third request"
                                             replyBlock:^(int replyId, NSString* string){ ProcessReply(replyId, string); }];
        
        WaitRPCCompletion();
        
        [xpcConnection.remoteObjectProxy ProcessRequest:3
                                                 string:@"This is the fourth request"
                                             replyBlock:^(int replyId, NSString* string){ ProcessReply(replyId, string); }];
        
        WaitRPCCompletion();
    }
    
    return 0;
}

static void ProcessReply(int replyId, NSString* string) {
    
    NSLog(@"Reply with id %i and string: \"%@\" received", replyId, string);
    
    // Signal main thread that RPC has completed
    dispatch_semaphore_signal(replySemaphore);
}

static void WaitRPCCompletion() {
    
    while(dispatch_semaphore_wait(replySemaphore, DISPATCH_TIME_NOW)) {
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.025]];
    }
    
    NSLog(@"RPC completed");
}
