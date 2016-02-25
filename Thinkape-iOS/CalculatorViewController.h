//
//  CalculatorViewController.h
//  Calculator
//
//  Created by iceAndFire on 15/9/1.
//  Copyright © 2015年 By.Li. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  CalculatorResultDelegate<NSObject>
-(void)sender:(NSString *)str;

@end
@interface CalculatorViewController : UIViewController

@property(nonatomic,assign) id<CalculatorResultDelegate>delegate;


@end
