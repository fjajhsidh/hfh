//
//  FanKuiSViewController.h
//  Thinkape-iOS
//
//  Created by admin on 16/2/14.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"
#import "CGModel.h"
@interface FanKuiSViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *yijian;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UITextField *textMessage;
@property (weak, nonatomic) IBOutlet UIButton *Tijiao;
@property (nonatomic,copy) void (^updateData)();
@property (nonatomic , copy) void (^callsback)();
@end
