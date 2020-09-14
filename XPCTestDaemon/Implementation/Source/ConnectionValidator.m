#import <XPCTestDaemon/Private/ConnectionValidator.h>
#import <XPCTestDaemon/Private/RequestProcessor.h>
#import <XPCTestDaemon/Private/Exception.h>

@implementation XPCTD_ConnectionValidator

- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    
    NSLog(@"New XPC connection from process with id %i...", newConnection.processIdentifier);
    
    newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(XPCTD_IRequestProcessor)];
    if(!newConnection.exportedInterface)
        XPCTD_THROW_EXCEPTION(@"Could not create XPC interface");
    
    newConnection.exportedObject = [[XPCTD_RequestProcessor alloc] init];
    if(!newConnection.exportedObject)
        XPCTD_THROW_EXCEPTION(@"Could not create request processor");
    
    [newConnection resume];
    
    NSLog(@"Connection configured");
    
    return YES;
}

@end
