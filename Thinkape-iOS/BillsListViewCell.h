//
//  BillsListViewCell.h
//  Thinkape-iOS
//
//  Created by tixa on 15/4/25.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillsListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *billName;
@property (weak, nonatomic) IBOutlet UILabel *billTime;
@property (weak, nonatomic) IBOutlet UIImageView *billTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *billProcess;
@property (weak, nonatomic) IBOutlet UILabel *billNum;
@property (weak, nonatomic) IBOutlet UILabel *billPrice;



//
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;




@end
