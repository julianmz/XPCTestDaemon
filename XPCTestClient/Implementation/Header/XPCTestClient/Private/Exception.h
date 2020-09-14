#ifndef XPCTC_EXCEPTIONIG
#define XPCTC_EXCEPTIONIG

#import <Foundation/Foundation.h>

#define XPCTC_THROW_EXCEPTION(reasonNSStr, ...) @throw [NSException exceptionWithName:@"XPCTC_Exception" \
reason:[NSString stringWithFormat:reasonNSStr, ##__VA_ARGS__] userInfo:nil]

#endif
