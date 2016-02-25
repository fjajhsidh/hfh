//
//  DataManager.h
//  Thinkape-iOS
//
//  Created by tixa on 15/5/26.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountModel.h"


@interface DataManager : NSObject

@property (nonatomic,strong) AccountModel *account;
@property (nonatomic,strong) NSString *ukey;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *webDomain;
+ (DataManager *)shareManager;
- (BOOL )removeAccount;
- (NSString *)webDomainUrl;
- (void)saveAccount:(NSDictionary *)accountDic;
-(NSDictionary *)objectoftect:(NSDictionary *)disemark;
-(void)saveAcont:(NSDictionary *)accuontDic;
- (void)cleanLocalCache;

@end
