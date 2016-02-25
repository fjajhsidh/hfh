//
//  Calculator.h
//  Calculator
//
//  Created by iceAndFire on 15/9/1.
//  Copyright © 2015年 By.Li. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScreenView;
@interface Calculator : UIView
@property (nonatomic, strong) ScreenView *screenText;
@property (nonatomic, strong) UIButton * allClean;
@property (nonatomic, strong) UIButton * addSub;
@property (nonatomic, strong) UIButton * percent;
@property (nonatomic, strong) UIButton * devide;
@property (nonatomic, strong) UIButton * multiplication;
@property (nonatomic, strong) UIButton * subtraction;
@property (nonatomic, strong) UIButton * add;
@property (nonatomic, strong) UIButton * results;
@property (nonatomic, strong) UIButton * seven;
@property (nonatomic, strong) UIButton * eight;
@property (nonatomic, strong) UIButton * nine;
@property (nonatomic, strong) UIButton * four;
@property (nonatomic, strong) UIButton * five;
@property (nonatomic, strong) UIButton * six;
@property (nonatomic, strong) UIButton * one;
@property (nonatomic, strong) UIButton * two;
@property (nonatomic, strong) UIButton * three;
@property (nonatomic, strong) UIButton * confirm;
@property (nonatomic, strong) UIButton * zero;
@property (nonatomic, strong) UIButton * point;
@end
