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
@property (weak, nonatomic) IBOutlet UILabel *Thinkape;
@property (weak, nonatomic) IBOutlet UIImageView *imageThink;
@property (weak, nonatomic) IBOutlet UILabel *openthink;
@property (weak, nonatomic) IBOutlet UILabel *weixin;
@property (weak, nonatomic) IBOutlet UIImageView *erweima;
@property (weak, nonatomic) IBOutlet UILabel *guanwang;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *soue = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 660, self.view.frame.size.width, self.view.frame.size.height)];
    self.imageThink.frame=CGRectMake(self.view.frame.origin.x-30, self.view.frame.origin.y-50, 90, 80);
    self.Thinkape.frame=CGRectMake(self.view.frame.origin.x-70, self.view.frame.origin.y-130, 200, 30);
    self.openthink.frame =CGRectMake(self.view.frame.origin.x-5, self.view.frame.origin.y-170, self.view.frame.size.width-20, 70);
    self.guanwang.frame = CGRectMake(self.view.frame.origin.x-80, self.view.frame.origin.y-230, self.view.frame.size.width-18, 32);
    self.weixin.frame =CGRectMake(self.view.frame.origin.x-70, self.view.frame.origin.y-265, 200, 32);
    self.erweima.frame = CGRectMake(self.view.frame.origin.x-70, self.view.frame.origin.y-320, 150, 110);
    soue.bounces=YES;
    [soue addSubview:self.imageThink];
    [soue addSubview:self.Thinkape];
    [soue addSubview:self.openthink];
    [soue addSubview:self.guanwang];
    [soue addSubview:self.weixin];
    [soue addSubview:self.erweima];
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
