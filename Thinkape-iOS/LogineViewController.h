//
//  LogineViewController.h
//  Thinkape-iOS
//
//  Created by tixa on 15/5/26.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"
#import "AccountModel.h"

#import "Disembark.h"
@interface LogineViewController : ParentsViewController <UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) void (^logSuccess)(AccountModel *model);
@property (nonatomic,strong) void (^diseSucces)(Disembark *deng);
@end
