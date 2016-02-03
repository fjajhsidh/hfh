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

@property(strong,nonatomic)NSString * danJu;

@property(strong,nonatomic)NSString * editorState;

@property(strong,nonatomic)NSString * flowstatus;

@property(strong,nonatomic)NSString * password;

@property(nonatomic,strong)NSMutableArray *costDataArr;
@property(nonatomic,strong)NSMutableArray *costLayoutArray;


@property(nonatomic,strong)NSMutableDictionary * acceptAddDict;//新增明细接收的字典
@property(nonatomic,strong)NSMutableDictionary * acceptEditorDict;//编辑明细接受的字典


@end

