//
//  StayApprovalViewCell.h
//  Thinkape-iOS
//
//  Created by tixa on 15/4/27.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StayApprovalViewCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeight;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *decs;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UIImageView *markImage;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *flowStatue;
@property (nonatomic , assign) BOOL close;

@property (nonatomic,assign,getter=isEdit) BOOL edit;

@property (nonatomic,strong) void (^selectItem)();
@property (nonatomic,strong) void (^backApply)(StayApprovalViewCell *cell);
@property (nonatomic,strong) void (^agreeApply)(StayApprovalViewCell *cell);

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)endEditing;

@end
