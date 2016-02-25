//
//  SubmitApproveViewController.h
//  Thinkape-iOS
//
//  Created by tixa on 15/6/4.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"
#import "CGModel.h"

@interface SubmitApproveViewController : ParentsViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate>

@property (nonatomic,assign) NSInteger type; // 页面属性。0：新建随手记 1：草稿编辑页面。Default：0
@property (nonatomic,strong) CGModel *editModel;
@property (nonatomic , strong) NSString *sspid;
@property (nonatomic , strong) UIView * calculatorView;
@property (nonatomic , copy) void (^callback)();

@end

