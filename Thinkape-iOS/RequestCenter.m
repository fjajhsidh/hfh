//
//  RequestCenter.m
//  Thinkape-iOS
//
//  Created by tixa on 15/4/8.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "RequestCenter.h"
#import "MacroDefinition.h"
#import "BFKit.h"
#import "DataManager.h"
static RequestCenter *defaultCenter;
@implementation RequestCenter
{
    long long expectedContentLength;
    void(^successCallBack)(NSString *fileName);
    void(^fauilerCallBack)(NSError *error);
}
+ (AFHTTPRequestOperation *)GetRequest:(NSString *)URLString
                     parameters:(NSString *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation,  NSDictionary *responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    return  [RequestCenter GetRequest:URLString
                              parameters:parameters
                                 success:success
                                 failure:failure
                       showLoadingStatus:YES];

}

+ (AFHTTPRequestOperation *)GetRequest:(NSString *)URLString
                            parameters:(NSString *)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary * responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                     showLoadingStatus:(BOOL)show{
    

    if (show) {
        
        [SVProgressHUD showWithStatus:@"加载中..." maskType:1];
        
    }
    
    
    
    
    
    
    
    
    
    
//    NSString *sig = [NSString stringWithFormat:@"%d%@%@%d2bdbe037abdf28a091e473ff5c86860c",2,IOS_VERSION,APP_VERSION,[DataManager shareManager].appID];
//    // 公共请求参数
//    NSString *publicParameters = [NSString stringWithFormat:@"s=%@&device=%d&os=%@&version=%@&app_id=%d&sig=%@&",URLString,2,IOS_VERSION,APP_VERSION,[DataManager shareManager].appID,[sig MD5]];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    //超时：
    manager.requestSerializer.timeoutInterval = 10;
    
    
//    //wo解决JSON解析数据中的<null>问题
//    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
//    
    
    
    URLString = [NSString stringWithFormat:@"%@?%@",Web_Domain,URLString];
    NSLog(@"url : %@",URLString);
    
    
    
    AFHTTPRequestOperation *operation = [manager GET:URLString
                                                                          parameters:nil
                                                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                                                                                 if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                                                     NSDictionary *infoDic = (NSDictionary *)responseObject;
                                                                                     if([[infoDic objectForKey:@"error"] integerValue] == 0)
                                                                                         success(operation,infoDic);
                                                                                     else
                                                                                     {
                                                                                         
                                                       [SVProgressHUD showErrorWithStatus:[infoDic objectForKey:@"msg"]];
                                                                                         failure(operation,nil);}
                                              
                                                                                 }
                                                                                
                                                                                 
                                                                                 // [SVProgressHUD showSuccessWithStatus:@"加载完成!"];
                                                                                 
                                                                             }
                                                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                 failure(operation,error);
                                                                                 NSLog(@"error :%@",error);
                                                                                 [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
                                                                             }];
    
    return operation;
    
}

+ (id)defaultCenter{
    if (!defaultCenter) {
        defaultCenter = [[RequestCenter alloc] init];
    }
    return defaultCenter;
}

- (NSString *)filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/cache/",NSHomeDirectory()] withIntermediateDirectories:NO attributes:nil error:nil];
    return [NSString stringWithFormat:@"%@/Documents/cache/%@",NSHomeDirectory(),self.currentFileName];
    
}

- (NSString *)fileName:(NSString *)str{
    NSArray *strArr = [str componentsSeparatedByString:@"/"];
    NSString *title = [strArr lastObject];
    NSArray *arr = [title componentsSeparatedByString:@"?"];
    return [arr firstObject];
}

- (NSString *)currentFileName{
    
    return [self fileName:self.url];
}

- (void)downloadOfficeFile:(NSString *)urlStr success:(void(^)(NSString *filename))success fauiler:(void(^)(NSError *error))fauiler{
    if (!self.fileData) {
        self.fileData = [[NSMutableData alloc] init];
    }
    self.url = urlStr;
    successCallBack = success;
    fauilerCallBack = fauiler;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {
        successCallBack(self.currentFileName);
    }
    else
    {
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.fileData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"data %@",data);
    [SVProgressHUD showProgress:(data.length /1024.0f /1024.0f) / (expectedContentLength/1024.0f/1024.0f) maskType:2];
    [self.fileData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error ");
    [SVProgressHUD dismiss];
    if (fauilerCallBack) {
        fauilerCallBack(error);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"finish");
    [SVProgressHUD dismiss];

    BOOL isWrite = [self.fileData writeToFile:[self filePath] atomically:YES];
    if (isWrite) {
        if (successCallBack) {
            successCallBack(self.currentFileName);
        }
    }
    else
    {
        if (fauilerCallBack) {
            fauilerCallBack(nil);
        }
    }

}
@end
