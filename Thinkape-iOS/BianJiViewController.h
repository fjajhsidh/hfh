//
//  BianJiViewController.h
//  Thinkape-iOS
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UnApprovalModel.h"
#import "BillsModel.h"
#import "ParentsViewController.h"
#import "CGModel.h"
@interface BianJiViewController : ParentsViewController<UINavigationBarDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate>
@property (nonatomic,copy) NSString *billid;
@property (nonatomic,copy) NSString *programeId;
@property (nonatomic,copy) NSString *flowid;
@property (nonatomic,strong) BillsModel *bills;
@property (nonatomic,strong) CGModel *editModel;

@property (nonatomic , strong) NSString *sspid;
@property (nonatomic,strong) UnApprovalModel *unModel;
@property (nonatomic,copy) void (^reloadData)();
@property (nonatomic , copy) void (^callback)();
@property(nonatomic,assign)int selectedion;//记录单据界面



@end
