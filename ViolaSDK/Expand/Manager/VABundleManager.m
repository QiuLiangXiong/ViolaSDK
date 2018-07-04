//
//  VABundleManager.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/4.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VABundleManager.h"
#import "QLXHttpRequestTool.h"

#if DEBUG
//#define va_baseUrl @"http://0.0."     //正式服务器地址
#define va_baseUrl @"http://172.20.10.8/viola/"     //本地服务器地址
#else
 #define va_baseUrl @""//正式服务器地址
#endif



@interface VABundleManager()

@property (nullable, nonatomic, strong) NSMutableDictionary * scriptCacheDic;

@end

@implementation VABundleManager

-  (NSString *)_fullWithUrl:(NSString *)url{
    if (![url hasPrefix:@"http"]) {
        return [va_baseUrl stringByAppendingString:url];
    }
    return url;
}

+ (VABundleManager *)shareManager{
    static VABundleManager * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [VABundleManager new];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //本地代理
        if (!va_baseUrl.length) {
            _scriptCacheDic = [NSMutableDictionary new];
        }
    }
    return self;
}

- (NSString * _Nullable)getLocalScriptWithUrl:(NSString *)url{
    url = [self _fullWithUrl:url];
    NSString * realativePath = [self _convertToRrealativePathWithUrl:url];
    if (realativePath.length) {
        if (_scriptCacheDic[realativePath]) {
            return _scriptCacheDic[realativePath];
        }
        NSString * localPath = [self _getDocumentPathWithRealativePath:[@"viola/" stringByAppendingString:realativePath]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
             NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:localPath];
            if (fileData) {
                NSString * script = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];;
                if (script) {
                     [_scriptCacheDic setObject:script forKey:realativePath];
                }
                return script;
            }
        }else {
            
            NSString * fileName = [self _convertToFileNameWithRrealativePath:realativePath];
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
            if (filePath.length) {
                NSString * script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                return script;
            }
        }
    }
    return nil;
}

- (void)downloadJSFileWithUrl:(NSString *)url completedBlocK:(VABundleReponse)completed{
    url = [self _fullWithUrl:url];
    if (!completed) {
        return ;
    }
    NSString * filePath = [self _getDownloadPath];
    
    [QLXHttpRequestTool downloadWithUrl:url filePath:[self _getDownloadPath]  params:nil progress:nil completion:^(id  _Nullable data, NSError * _Nullable error) {
        if (!error && data) {
            NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:filePath];
            NSString * script = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];;
            if (script.length) {
                completed(script , error);
            }else {
                completed(nil,[NSError new]);
            }
        }else {
            completed(nil,error);
        }
    }];
}


- (NSString *)_convertToRrealativePathWithUrl:(NSString *)url{
    NSString * realativeUrl = @"";
    if ([url isKindOfClass:[NSString class]]) {
        NSRange range = [url rangeOfString:@"viola/[A-Za-z0-9/-_]*.js" options:(NSRegularExpressionSearch)];
        if (range.length) {
            range = NSMakeRange(range.location + 6, range.length - 6);
            realativeUrl = [url substringWithRange:range];
        }
    }
    return realativeUrl;
}

- (NSString *)_convertToFileNameWithRrealativePath:(NSString *)path{
    NSString * fileName = [path componentsSeparatedByString:@"/"].lastObject;
    fileName = [fileName componentsSeparatedByString:@"."].firstObject;
    return fileName;
}

-(NSString *) _getDocumentPathWithRealativePath:(NSString *)path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (path == nil) {
        path = @"";
    }
    return  [[paths objectAtIndex:0] stringByAppendingPathComponent:path];
}

-(NSString *) _getDownloadPath{
    NSString * tempPath = NSTemporaryDirectory();
    return [tempPath stringByAppendingString:[NSString stringWithFormat:@"viola_%lld.js",(long long)CFAbsoluteTimeGetCurrent()]];
}


@end

