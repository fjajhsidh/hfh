   //
//  DataManager.m
//  Thinkape-iOS
//
//  Created by tixa on 15/5/26.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "DataManager.h"
#import "MJExtension.h"
#import "CoreDataManager.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"

static DataManager *manager = nil;
static AccountModel *accountModel = nil;
@implementation DataManager

+(DataManager *)shareManager{
    if (manager == nil) {
        manager = [[DataManager alloc] init];
    }
    return manager;
}

- (NSString *)webDomain{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *webdomain = [defaults objectForKey:@"webDomain"];

    return webdomain;
}

- (void)setWebDomain:(NSString *)webDomain{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:webDomain forKey:@"webDomain"];
    [defaults synchronize];
}

- (NSString *)webDomainUrl{
    NSString *returnUrl;
    if (self.webDomain.length != 0) {
        returnUrl = [NSString stringWithFormat:@"%@/ashx/mobileNew.ashx",self.webDomain];
    }
    return returnUrl;
}

- (void)saveAccount:(NSDictionary *)accountDic{
    [accountDic writeToFile:[self filePath] atomically:YES];
}
-(void)saveAcont:(NSDictionary *)accuontDic
{
    [accuontDic writeToFile:[self fileP] atomically:YES];
}
-(NSDictionary *)objectoftect:(NSDictionary *)disemark
{
    disemark = [NSDictionary dictionaryWithContentsOfFile:[self filePath]];
    return disemark;
}
- (AccountModel *)account{
    
    if (accountModel == nil) {
        
        NSDictionary *accountDic = [NSDictionary dictionaryWithContentsOfFile:[self filePath]];
        if (accountDic != nil) {
            accountModel = [AccountModel objectWithKeyValues:accountDic];
             return accountModel;
        }
        else
            return nil;
    }
    else
        return accountModel;
}

- (void)cleanCache{
    accountModel = nil;
    self.account = nil;
}

- (NSString *)filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/Account/",NSHomeDirectory()] withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/Account/account",NSHomeDirectory()];
    return filePath;
}
-(NSString *)fileP
{
    NSFileManager *manager = [NSFileManager defaultManager];
     [manager createDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/Account/",NSHomeDirectory()] withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/Account/disebark",NSHomeDirectory()];
    return filePath;
}
- (BOOL)removeAccount{
    NSFileManager *mananger = [NSFileManager defaultManager];
    BOOL logout = [mananger removeItemAtPath:[self filePath] error:nil];
    if (logout) {
        [self cleanCache];
    }
    return logout;
}
- (NSString *)ukey{
    return self.account.ukey;
}
- (NSString *)uid{
    return self.account.uid;
}

- (void)cleanLocalCache{
    [SVProgressHUD show];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("**test.rongfzh.yc", DISPATCH_QUEUE_CONCURRENT);
    dispatch_barrier_async(queue, ^{
        [[CoreDataManager shareManager] deleateDataForTabel:@"KindsLayout" sql:nil];
        
        
    });
    dispatch_barrier_async(queue, ^{
        [[CoreDataManager shareManager] deleateDataForTabel:@"KindItem" sql:nil];
        
    });
    dispatch_barrier_async(queue, ^{
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            //[SVProgressHUD dismiss];
            //[tableView reloadData];
        }];
        
    });
    dispatch_barrier_async(queue, ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/cache",NSHomeDirectory()] error:nil];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });

}

@end
