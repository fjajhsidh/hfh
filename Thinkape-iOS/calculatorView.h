//
//  calculatorView.h
//  Thinkape-iOS
//
//  Created by admin on 16/2/18.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calculator.h"
#import "ScreenView.h"

@interface calculatorView : UIView<UITextFieldDelegate>
@property (nonatomic, strong) Calculator *calculator;
@property (nonatomic) NSMutableString *tempString;
@property (nonatomic) NSMutableString *firstString;
@property (nonatomic) BOOL flag;
//@property (nonatomic) NSMutableString *lastString;
//用来保留当前运算符号
@property (nonatomic) NSMutableString *operator;
@end
