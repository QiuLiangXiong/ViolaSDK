//
//  VALog.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VALog.h"
#import <UIKit/UIKit.h>
#if DEBUG
@implementation VALog

+ (void)devLog:(VALogFlag)flag file:(const char *)fileName line:(NSUInteger)line format:(NSString *)format, ...{
    if ([format isKindOfClass:[NSString class]]) {
    
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    
        [self log:flag file:fileName line:line message:message];
    }
}

+ (void)log:(VALogFlag)flag file:(const char *)fileName line:(NSUInteger)line message:(NSString *)message
{
    NSString *flagString;
    NSString *flagColor;
    switch (flag) {
        case VALogFlagError: {
            flagString = @"error";
            flagColor = @"fg255,0,0;";
        }
            break;
        case VALogFlagWarning:
            flagString = @"warn";
            flagColor = @"fg255,165,0;";
            break;
        case VALogFlagDebug:
            flagString = @"debug";
            flagColor = @"fg0,128,0;";
            break;
        case VALogFlagLog:
            flagString = @"log";
            flagColor = @"fg128,128,128;";
            break;
        default:
            flagString = @"info";
            flagColor = @"fg100,149,237;";
            break;
    }
    
    NSString *logMessage = [NSString stringWithFormat:@"<Viola>[%@]%s:%ld, %@ %s", flagString, fileName, (unsigned long)line, message, ";"];
    NSLog(@"%@", logMessage);
}

@end
#endif
