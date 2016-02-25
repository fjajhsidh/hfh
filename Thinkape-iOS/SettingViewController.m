//
//  SettingViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/6/18.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "LogineViewController.h"
#import "AboutViewController.h"
#import "ChangePasswordViewController.h"
#import "FanKuiSViewController.h"
@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dataArray addObject:@"关于思凯普"];
    [self.dataArray addObject:@"清除缓存"];
    [self.dataArray addObject:@"修改密码"];
    [self.dataArray addObject:@"建议反馈"];
   
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BtnAction

- (IBAction)logout:(UIButton *)sender {
   BOOL logout = [[DataManager shareManager] removeAccount];
  [[DataManager shareManager] cleanLocalCache];
    if (logout) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(13, 10, SCREEN_WIDTH - 26, 45)];
    bgView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:bgView];
        
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(bgView.frame) - 20, 25)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor hex:@"333333"];
    label.tag = 10;
    [bgView addSubview:label];
    
    label.text = [self.dataArray safeObjectAtIndex:indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AboutViewController *about = [[AboutViewController alloc] init];
        about.title = @"关于思凯普";
        [self.navigationController pushViewController:about animated:YES];
        return;
    }
    if (indexPath.row == 1) {
        [[DataManager shareManager] cleanLocalCache];
        return;
    }
    else if (indexPath.row == 2){
        ChangePasswordViewController *changePassword = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:changePassword animated:YES];
    }
    if (indexPath.row==3) {
        FanKuiSViewController *fan = [FanKuiSViewController new];
        [self.navigationController pushViewController:fan animated:YES];
    }
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
