//
//  AboutViewController.m
//  Thinkape-iOS
//
//  Created by 刚刚买的电脑 on 15/11/26.
//  Copyright © 2015年 TIXA. All rights reserved.
//

#import "AboutViewController.h"
#import "MacroDefinition.h"

@interface AboutViewController ()


{
    
    UIScrollView *_myScrollView;
    UIImageView *_thinkApeImage;
    
    UILabel *_thinkApeLabel;
    UILabel *_openLabel;
    UILabel *_urlLabel;
    UILabel *_weixinLabel;
    UIImageView *_erweimaImage;
    UILabel *_thinkLabel;
    
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}


- (void) createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    //
    _thinkApeImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 50, 100, 100)];
    _thinkApeImage.image = [UIImage imageNamed:@"logo_thinkape_show"];
    
    //
    _thinkApeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, SCREEN_WIDTH-20, 60)];
    _thinkApeLabel.text = @"思凯普";
    _thinkApeLabel.font = [UIFont systemFontOfSize:20];
    _thinkApeLabel.textAlignment = NSTextAlignmentCenter;
    
    //
    _openLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 300, SCREEN_WIDTH-20, 50)];
    _openLabel.text = @"开启专业、高效、共享、整合的新一代全面预算与费用管控平台";
    _openLabel.textAlignment = NSTextAlignmentCenter;
    _openLabel.numberOfLines = 0;
    
    //
    _urlLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 350, SCREEN_WIDTH-20, 50)];
    _urlLabel.text = @"思凯普官网：www.thinkape.com.cn";
    _urlLabel.textAlignment = NSTextAlignmentCenter;
    
    //
    _weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 400, SCREEN_WIDTH-20, 50)];
    _weixinLabel.text = @"思凯普微信公众号：Thinkape思凯普";
    _weixinLabel.textAlignment = NSTextAlignmentCenter;
    
    //
    _erweimaImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 500, 200, 200)];
    _erweimaImage.image = [UIImage imageNamed:@"Thinkapeimage"];
    
    //
    _thinkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 760, SCREEN_WIDTH-20, 50)];
    _thinkLabel.text = @"Thinkape 1998-2016 思凯普中国 版权所有";
    _thinkLabel.font = [UIFont systemFontOfSize:14];
    _thinkLabel.numberOfLines = 0;
    _thinkLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [_myScrollView addSubview:_thinkApeImage];
    [_myScrollView addSubview:_thinkApeLabel];
    [_myScrollView addSubview:_openLabel];
    [_myScrollView addSubview:_urlLabel];
    [_myScrollView addSubview:_weixinLabel];
    [_myScrollView addSubview:_erweimaImage];
    [_myScrollView addSubview:_thinkLabel];
    
    
    _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 900);
    
    [self.view addSubview:_myScrollView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
