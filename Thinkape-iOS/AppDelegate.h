//
//  AppDelegate.h
//  Thinkape-iOS
//
//  Created by tixa on 15/4/7.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)NSMutableDictionary *dict;
@property(nonatomic,strong)NSMutableArray *uptateimage;
@property(nonatomic,strong)NSMutableArray *imagedate;
//wo 退回意见界面传值
@property(strong,nonatomic)NSString * tuiHuiYiJianStr;
//wo  传值
@property(strong,nonatomic)NSString * zhuanStr;
//wo  单据是否完成
@property(strong,nonatomic)NSString * danJu;
//wo  单据是否完成
@property(strong,nonatomic)NSString * editorState;
//wo  单据是否完成
@property(strong,nonatomic)NSString * flowstatus;


@property(strong,nonatomic)NSString * password;
@end

