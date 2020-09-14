#ifndef XPCTD_EXCEPTIONIG
#define XPCTD_EXCEPTIONIG

#import <Foundation/Foundation.h>

#define XPCTD_THROW_EXCEPTION(reasonNSStr, ...) @throw [NSException exceptionWithName:@"XPCTD_Exception" \
reason:[NSString stringWithFormat:reasonNSStr, ##__VA_ARGS__] userInfo:nil]

#endif
