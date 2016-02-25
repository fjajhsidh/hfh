//
//  Calculator.m
//  Calculator
//
//  Created by iceAndFire on 15/9/1.
//  Copyright © 2015年 By.Li. All rights reserved.
//

#import "Calculator.h"
#import "ScreenView.h"
@implementation Calculator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self allView];
        [self drawBorders];
    }
    return self;
}

- (void)drawBorders {
    
    [self drawBorderWithButton:self.allClean];
    [self drawBorderWithButton:self.addSub];
    [self drawBorderWithButton:self.percent];
    [self drawBorderWithButton:self.devide];
    [self drawBorderWithButton:self.multiplication];
    [self drawBorderWithButton:self.subtraction];
    [self drawBorderWithButton:self.add];
    [self drawBorderWithButton:self.results];
    [self drawBorderWithButton:self.confirm];
    [self drawBorderWithButton:self.zero];
    [self drawBorderWithButton:self.one];
    [self drawBorderWithButton:self.two];
    [self drawBorderWithButton:self.three];
    [self drawBorderWithButton:self.four];
    [self drawBorderWithButton:self.five];
    [self drawBorderWithButton:self.six];
    [self drawBorderWithButton:self.seven];
    [self drawBorderWithButton:self.eight];
    [self drawBorderWithButton:self.nine];
    [self drawBorderWithButton:self.point];
    
}
//为Button加上边框
- (void)drawBorderWithButton:(UIButton *)button {
    CALayer * downButtonLayer = [button layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setBorderWidth:1.0];
    [downButtonLayer setBorderColor:[[UIColor grayColor] CGColor]];
}

- (void) allView
{

//        把屏幕尺寸取出来
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight =250;
    
#pragma mark -- 创建一个TextField 改 Lable
    //    上方留一些格子显示头信息
    ScreenView *terminal = [[ScreenView alloc] initWithFrame:CGRectMake(0, screenHeight*1/13, screenWidth, screenHeight*2.5/13)];
    [self addSubview:terminal];
    self.screenText = terminal;
    //    设置编辑
    terminal.enabled = YES;
    //    设置初始显示
    terminal.text = @"0";
    //    背景颜色黑色
    terminal.backgroundColor = [UIColor blackColor];
    //    透明度
//    terminal.alpha = 0.5; 
    //    字体颜色白色
    terminal.textColor = [UIColor whiteColor];
    //    右对其
    terminal.textAlignment = NSTextAlignmentRight;
    //    设置字体和大小
    terminal.font = [UIFont fontWithName:@"Helvetica Neue" size:30];
    //    设置自适应
    terminal.adjustsFontSizeToFitWidth = YES;
//    设置可触摸
    terminal.userInteractionEnabled = YES;
    //    设置最小字体
//    terminal.minimumFontSize = 1;
    terminal.minimumScaleFactor = 0.1;
//  自动换行
//    terminal.numberOfLines = 0;
    
#pragma mark -- 19个button
    //    获取button尺寸
    CGFloat buttonHeight = screenHeight*2/13;
    CGFloat buttonWidth = screenWidth/4;
#pragma mark allclean键
    UIButton *allClean = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:allClean];
    self.allClean = allClean;
    allClean.frame = CGRectMake(0, screenHeight*3/13, buttonWidth, buttonHeight);
    allClean.backgroundColor = [UIColor colorWithRed:188/255. green:188/255. blue:188/255. alpha:1];
    //    设置button显示的字
    [allClean setTitle:@"AC" forState:UIControlStateNormal];
    //    设置title的颜色
    [allClean setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    allClean.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:30];
    //    设置button上字体的颜色
    allClean.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    allClean.layer.borderWidth = 0;
    //    设置按键发光
    allClean.showsTouchWhenHighlighted = YES;
#pragma mark addSub键
    UIButton *addSub = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:addSub];
    self.addSub = addSub;
    addSub.frame = CGRectMake(buttonWidth, screenHeight*3/13, buttonWidth, buttonHeight);
    addSub.backgroundColor = [UIColor colorWithRed:188/255. green:188/255. blue:188/255. alpha:1];
    //    设置button显示的字
    [addSub setTitle:@"+/-" forState:UIControlStateNormal];
    //    设置title的颜色
    [addSub setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    addSub.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:30];
    //    设置button上字体的颜色
    addSub.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    addSub.layer.borderWidth = 0;
    //    设置按键发光
    addSub.showsTouchWhenHighlighted = YES;
#pragma mark percent键
    UIButton *percent = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:percent];
    self.percent = percent;
    percent.frame = CGRectMake(buttonWidth*2, screenHeight*3/13, buttonWidth, buttonHeight);
    percent.backgroundColor = [UIColor colorWithRed:188/255. green:188/255. blue:188/255. alpha:1];
    //    设置button显示的字
    [percent setTitle:@"%" forState:UIControlStateNormal];
    //    设置title的颜色
    [percent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    percent.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:30];
    //    设置button上字体的颜色
    percent.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    percent.layer.borderWidth = 0;
    //    设置按键发光
    percent.showsTouchWhenHighlighted = YES;
#pragma mark devide键
    UIButton *devide = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:devide];
    self.devide = devide;
    devide.frame = CGRectMake(buttonWidth*3, screenHeight*3/13, buttonWidth, buttonHeight);
    devide.backgroundColor = [UIColor colorWithRed:244/255. green:128/255. blue:22/255. alpha:1];
    //    设置button显示的字
    [devide setTitle:@"÷" forState:UIControlStateNormal];
    //    设置title的颜色
    [devide setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    devide.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    devide.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    devide.layer.borderWidth = 0;
    //    设置按键发光
    devide.showsTouchWhenHighlighted = YES;
#pragma mark multiplication键
    UIButton *multiplication = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:multiplication];
    self.multiplication = multiplication;
    multiplication.frame = CGRectMake(buttonWidth*3, screenHeight*5/13, buttonWidth, buttonHeight);
    multiplication.backgroundColor = [UIColor colorWithRed:244/255. green:128/255. blue:22/255. alpha:1];
    //    设置button显示的字
    [multiplication setTitle:@"×" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [multiplication setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    multiplication.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    multiplication.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    multiplication.layer.borderWidth = 0;
    //    设置按键发光
    multiplication.showsTouchWhenHighlighted = YES;
#pragma mark subtraction键
    UIButton *subtraction = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:subtraction];
    self.subtraction = subtraction;
    subtraction.frame = CGRectMake(buttonWidth*3, screenHeight*7/13, buttonWidth, buttonHeight);
    subtraction.backgroundColor = [UIColor colorWithRed:244/255. green:128/255. blue:22/255. alpha:1];
    //    设置button显示的字
    [subtraction setTitle:@"－" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [subtraction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    subtraction.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    subtraction.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    subtraction.layer.borderWidth = 0;
    //    设置按键发光
    subtraction.showsTouchWhenHighlighted = YES;
#pragma mark add键
    UIButton *add = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:add];
    self.add = add;
    add.frame = CGRectMake(buttonWidth*3, screenHeight*9/13, buttonWidth, buttonHeight);
    add.backgroundColor = [UIColor colorWithRed:244/255. green:128/255. blue:22/255. alpha:1];
    //    设置button显示的字
    [add setTitle:@"＋" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    add.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    add.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    add.layer.borderWidth = 0;
    //    设置按键发光
    add.showsTouchWhenHighlighted = YES;
    
    //    results
#pragma mark results键
    UIButton *results = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:results];
    self.results = results;
    results.frame = CGRectMake(buttonWidth*3, screenHeight*11/13, buttonWidth, buttonHeight);
    results.backgroundColor = [UIColor colorWithRed:244/255. green:128/255. blue:22/255. alpha:1];
    //    设置button显示的字
    [results setTitle:@"＝" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [results setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    results.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    results.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    results.layer.borderWidth = 0;
    //    设置按键发光
    results.showsTouchWhenHighlighted = YES;
#pragma mark seven键
    UIButton *seven = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:seven];
    self.seven = seven;
    seven.frame = CGRectMake(0, screenHeight*5/13, buttonWidth, buttonHeight);
    seven.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [seven setTitle:@"7" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [seven setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    seven.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    seven.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    seven.layer.borderWidth = 0;
    //    设置按键发光
    seven.showsTouchWhenHighlighted = YES;
#pragma mark eight键
    UIButton *eight = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:eight];
    self.eight = eight;
    eight.frame = CGRectMake(buttonWidth, screenHeight*5/13, buttonWidth, buttonHeight);
    eight.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [eight setTitle:@"8" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [eight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    eight.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    eight.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    eight.layer.borderWidth = 0;
    //    设置按键发光
    eight.showsTouchWhenHighlighted = YES;
    //nine
#pragma mark nine键
    UIButton *nine = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:nine];
    self.nine = nine;
    nine.frame = CGRectMake(buttonWidth*2, screenHeight*5/13, buttonWidth, buttonHeight);
    nine.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [nine setTitle:@"9" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [nine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    nine.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    nine.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    nine.layer.borderWidth = 0;
    //    设置按键发光
    nine.showsTouchWhenHighlighted = YES;
    
    
    
    
#pragma mark four键
    UIButton *four = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:four];
    self.four = four;
    four.frame = CGRectMake(0, screenHeight*7/13, buttonWidth, buttonHeight);
    four.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [four setTitle:@"4" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [four setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    four.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    four.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    four.layer.borderWidth = 0;
    //    设置按键发光
    four.showsTouchWhenHighlighted = YES;
    
#pragma mark five键
    UIButton *five = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:five];
    self.five = five;
    five.frame = CGRectMake(buttonWidth, screenHeight*7/13, buttonWidth, buttonHeight);
    five.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [five setTitle:@"5" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [five setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    five.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    five.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    five.layer.borderWidth = 0;
    //    设置按键发光
    five.showsTouchWhenHighlighted = YES;
    //nine
#pragma mark six键
    UIButton *six = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:six];
    self.six = six;
    six.frame = CGRectMake(buttonWidth*2, screenHeight*7/13, buttonWidth, buttonHeight);
    six.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [six setTitle:@"6" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [six setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    six.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    six.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    six.layer.borderWidth = 0;
    //    设置按键发光
    six.showsTouchWhenHighlighted = YES;
    
    
    
    
    
    
#pragma mark one键
    UIButton *one = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:one];
    self.one = one;
    one.frame = CGRectMake(0, screenHeight*9/13, buttonWidth, buttonHeight);
    one.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [one setTitle:@"1" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [one setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    one.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    one.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    one.layer.borderWidth = 0;
    //    设置按键发光
    one.showsTouchWhenHighlighted = YES;
    
#pragma mark two键
    UIButton *two = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:two];
    self.two = two;
    two.frame = CGRectMake(buttonWidth, screenHeight*9/13, buttonWidth, buttonHeight);
    two.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [two setTitle:@"2" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [two setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    two.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    two.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    two.layer.borderWidth = 0;
    //    设置按键发光
    two.showsTouchWhenHighlighted = YES;
    //nine
#pragma mark three键
    UIButton *three = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:three];
    self.three = three;
    three.frame = CGRectMake(buttonWidth*2, screenHeight*9/13, buttonWidth, buttonHeight);
    three.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [three setTitle:@"3" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [three setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    three.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    three.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    three.layer.borderWidth = 0;
    //    设置按键发光
    three.showsTouchWhenHighlighted = YES;
    
#pragma mark-确认键

    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:confirm];
    self.confirm = confirm;
    confirm.frame = CGRectMake(0, screenHeight*11/13, buttonWidth, buttonHeight);
    confirm.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [confirm setTitle:@"确认" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [confirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    confirm.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:30];
    //    设置button上字体的颜色
    confirm.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    confirm.layer.borderWidth = 0;
    //    设置按键发光
    confirm.showsTouchWhenHighlighted = YES;

    
    
    //    zero
#pragma mark zero键
    UIButton *zero = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:zero];
    self.zero = zero;
    zero.frame = CGRectMake(buttonWidth, screenHeight*11/13, buttonWidth, buttonHeight);
    zero.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [zero setTitle:@"0" forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [zero setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    zero.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    zero.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    zero.layer.borderWidth = 0;
    //    设置按键发光
    zero.showsTouchWhenHighlighted = YES;
    //    point
#pragma mark point键
    UIButton *point = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:point];
    self.point = point;
    point.frame = CGRectMake(buttonWidth*2, screenHeight*11/13, buttonWidth, buttonHeight);
    point.backgroundColor = [UIColor colorWithRed:203/255. green:203/255. blue:207/255. alpha:1];
    //    设置button显示的字
    [point setTitle:@"." forState:UIControlStateNormal];
    //multiplication设置title的颜色
    [point setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    设置button 上 的字体及大小
    point.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    //    设置button上字体的颜色
    point.titleLabel.textColor = [UIColor whiteColor];
    //    设置边框
    point.layer.borderWidth = 0;
    //    设置按键发光
    point.showsTouchWhenHighlighted = YES;
}

@end
