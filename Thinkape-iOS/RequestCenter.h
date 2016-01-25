//
//  RequestCenter.h
//  Thinkape-iOS
//
//  Created by tixa on 15/4/8.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MacroDefinition.h"

@interface RequestCenter : NSObject <NSURLConnectionDataDelegate>
@property (nonatomic,strong) NSMutableData *fileData;
@property (nonatomic,strong,readonly) NSString *currentFileName; // 当前文件名称.
@property (nonatomic,strong) NSString *url;
- (NSString *)filePath;
+ (id)defaultCenter;
- (void)downloadOfficeFile:(NSString *)urlStr success:(void(^)(NSString *filename))success fauiler:(void(^)(NSError *error))fauiler;

+ (AFHTTPRequestOperation *)GetRequest:(NSString *)URLString
                            parameters:(NSString *)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary * responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (AFHTTPRequestOperation *)GetRequest:(NSString *)URLString
                            parameters:(NSString *)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary * responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                     showLoadingStatus:(BOOL)show;
+ (AFHTTPRequestOperation *)getRequest:(NSString *)URLString
                            parameters:(NSString *)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, NSMutableDictionary * responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                     showLoadingStatus:(BOOL)show;
@end
