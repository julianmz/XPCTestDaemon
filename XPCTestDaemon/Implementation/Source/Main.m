#import <Foundation/Foundation.h>

#import <XPCTestDaemon/Private/ConnectionValidator.h>
#import <XPCTestDaemon/Private/Exception.h>

#define NAME_MACH_SERVICE @"com.jmz.xpctestdaemon"

static void SignalHandler(int signalId);
static void ResetSignalHandlerAndRaise(int signalId);

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        
        NSLog(@"XPCTestDaemon launched; version info: %s %s", __DATE__, __TIME__);
        
        if(signal(SIGTERM, SignalHandler))
            XPCTD_THROW_EXCEPTION(@"SignalHandler could not be subscribed to SIGTERM could not be set");
        
        XPCTD_ConnectionValidator* xpcConnectionValidator = [[XPCTD_ConnectionValidator alloc] init];
        if(!xpcConnectionValidator)
            XPCTD_THROW_EXCEPTION(@"XPC connection validator could not be created");
        
        NSXPCListener* xpcListener = [[NSXPCListener alloc] initWithMachServiceName:NAME_MACH_SERVICE];
        if(!xpcListener)
            XPCTD_THROW_EXCEPTION(@"XPC listener could not be created");
        
        xpcListener.delegate = xpcConnectionValidator;
        
        [xpcListener resume];
        
        NSLog(@"XPC listener is active");
        
        [[NSRunLoop currentRunLoop] run];
    }
    
    return 0;
}

static void SignalHandler(int signalId) {
    
    if(signalId == SIGTERM) {
        
        NSLog(@"SIGTERM received, XPCTestDaemon terminating");
    
        ResetSignalHandlerAndRaise(SIGTERM);
    }
}

static void ResetSignalHandlerAndRaise(int signalId) {
    
    signal(signalId, SIG_DFL);
    raise(signalId);
}
