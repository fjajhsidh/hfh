//
//  DatePickerView.h
//  Thinkape-iOS
//
//  Created by tixa on 15/9/7.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerView : UIView
{
    UIDatePicker *picker;
}

- (IBAction)closeView:(id)sender;


@property (nonatomic,strong) NSString *date;

@property (nonatomic,strong) void (^selectDateCallBack)(NSString *date);
@property(nonatomic,strong)void(^selectDateBack)(NSString *date);

@end
