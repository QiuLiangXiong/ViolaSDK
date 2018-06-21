//
//  VALog.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, VALogFlag) {
    VALogFlagError      = 1 << 0,
    VALogFlagWarning    = 1 << 1,
    VALogFlagInfo       = 1 << 2,
    VALogFlagLog        = 1 << 3,
    VALogFlagDebug      = 1 << 4
};
#if DEBUG
@interface VALog : NSObject

+ (void)devLog:(VALogFlag)flag file:(const char *)fileName line:(NSUInteger)line format:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

@end

#define VA_FILENAME (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)

#define VA_LOG(flag, fmt, ...)          \
do {                                    \
[VALog devLog:flag                     \
file:VA_FILENAME              \
line:__LINE__                 \
format:(fmt), ## __VA_ARGS__];  \
} while(0)

#define VALog(format,...)               VA_LOG(VALogFlagLog, format, ##__VA_ARGS__)
#define VALogDebug(format, ...)         VA_LOG(VALogFlagDebug, format, ##__VA_ARGS__)
#define VALogInfo(format, ...)          VA_LOG(VALogFlagInfo, format, ##__VA_ARGS__)
#define VALogWarning(format, ...)       VA_LOG(VALogFlagWarning, format ,##__VA_ARGS__)
#define VALogError(format, ...)         VA_LOG(VALogFlagError, format, ##__VA_ARGS__)

#else

#define VALog(format,...)
#define VALogDebug(format, ...)
#define VALogInfo(format, ...)
#define VALogWarning(format, ...)
#define VALogError(format, ...)

#endif
