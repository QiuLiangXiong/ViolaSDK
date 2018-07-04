//
//  QLXHttpRequestTool.m
//  FunPoint
//
//  Created by QLX on 15/12/20.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXHttpRequestTool.h"
#import "AFNetworking/AFNetworking.h"



@implementation QLXHttpRequestTool

+(AFURLSessionManager *) defaultSessionManager{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    return  [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
}

+ (QLXHttpRequest *)requestForGetWithUrl:(NSString *)url params:(NSDictionary *)params response:(QLXHTTPResponse)complete {
   
    AFURLSessionManager *manager = [self defaultSessionManager];
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (complete) {
            complete(responseObject , error);
        }
    }];
    [dataTask resume];
    


    return [[QLXHttpRequest alloc] initWithTask:dataTask];
}

+ (QLXHttpRequest *)requestForPostWithUrl:(NSString *)url params:(NSDictionary *)params response:(QLXHTTPResponse)complete {
    AFURLSessionManager *manager = [self defaultSessionManager];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (complete) {
            if (error) {
               NSLog(@"requestError:%@",error.localizedDescription);
            }
            complete(responseObject , error);
        }
    }];
    [dataTask resume];
    
    return [[QLXHttpRequest alloc] initWithTask:dataTask];
}

+ (QLXHttpRequest *)uploadWithUrl:(NSString *)url filePath:(NSString *)path params:(NSDictionary *)params progress:(QLXHTTPProgress)progress completion:(QLXHTTPResponse)completion {
    //    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" error:nil];
    //    } error:nil];
    //
    //    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //
    //    NSURLSessionUploadTask *uploadTask;
    //    uploadTask = [manager
    //                  uploadTaskWithStreamedRequest:request
    //                  progress:^(NSProgress * _Nonnull uploadProgress) {
    //                      // This is not called back on the main queue.
    //                      // You are responsible for dispatching to the main queue for UI updates
    //                      dispatch_async(dispatch_get_main_queue(), ^{
    //                          //Update the progress view
    //                          if (progress) {
    //                              progress(uploadProgress.fractionCompleted);
    //                          }
    //                         // [progressView setProgress:uploadProgress.fractionCompleted];
    //                      });
    //                  }
    //                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    //                      if (error) {
    //                          if (completion) {
    //                              completion(nil , error);
    //                          }
    //                      } else {
    //                          if (completion) {
    //                              completion(responseObject , nil);
    //                          }
    //                      }
    //                  }];
    //    [uploadTask resume];
    //    return [[QLXHttpRequest alloc] initWithTask:uploadTask];
    return nil;
}

+ (QLXHttpRequest *)downloadWithUrl:(NSString *)url filePath:(NSString *)path params:(NSDictionary *)params progress:(QLXHTTPProgress)progress completion:(QLXHTTPResponse)completion {
  
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        if ([path isKindOfClass:[NSString class]] && path.length) {
            return [NSURL fileURLWithPath:path];
        }
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (completion) {
            completion(filePath,error);
        }
    }];
    [downloadTask resume];
    
    return nil;
}



/**
 *  @author Jakey
 *
 *  @brief  下载文件
 *
 *  @param parameters   附加post参数
 *  @param requestURL 请求地址
 *  @param savedPath  保存 在磁盘的位置
 *  @param success    下载成功回调
 *  @param failure    下载失败回调
 *  @param progress   实时下载进度回调
 */
+ (void)downloadFileWithOption:(NSDictionary *)parameters
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestSerializer *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestSerializer *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress

{
    
    
  
    
    
//    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:parameters error:nil];
//    
//
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        float p = (float)totalBytesRead / totalBytesExpectedToRead;
//        progress(p);
//        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
//        
//    }];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(operation,responseObject);
//        NSLog(@"下载成功");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        success(operation,error);
//        
//        NSLog(@"下载失败");
//        
//    }];
//    
//    [operation start];
    
}

//
///**
// *  @author Jakey
// *
// *  @brief  下载文件
// *
// *  @param parameters   附加post参数
// *  @param requestURL 请求地址
// *  @param savedPath  保存 在磁盘的位置
// *  @param success    下载成功回调
// *  @param failure    下载失败回调
// *  @param progress   实时下载进度回调
// */
//+ (void)downloadFileWithOption:(NSDictionary *)parameters
//                 withInferface:(NSString*)requestURL
//                     savedPath:(NSString*)savedPath
//               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//                      progress:(void (^)(float progress))progress
//
//{
//    
//    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:parameters error:nil];
//    
//    //以下是手动创建request方法 AFQueryStringFromParametersWithEncoding有时候会保存
//    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
//    //   NSMutableURLRequest *request =[[[AFHTTPRequestOperationManager manager]requestSerializer]requestWithMethod:@"POST" URLString:requestURL parameters:paramaterDic error:nil];
//    //
//    //    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    //
//    //    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
//    //    [request setHTTPMethod:@"POST"];
//    //
//    //    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(paramaterDic, NSASCIIStringEncoding) dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        float p = (float)totalBytesRead / totalBytesExpectedToRead;
//        progress(p);
//        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
//        
//    }];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(operation,responseObject);
//        NSLog(@"下载成功");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        success(operation,error);
//        
//        NSLog(@"下载失败");
//        
//    }];
//    
//    [operation start];
//    
//}


@end
