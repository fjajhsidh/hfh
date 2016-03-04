//
//  BillsListViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/4/25.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "BillsListViewController.h"
#import "BillsModel.h"
#import "BillsListViewCell.h"
#import "BillsDetailViewController.h"
#import "AppDelegate.h"

@interface BillsListViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeightConstraints;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftConstraint;

@end

@implementation BillsListViewController
{
    int p; //页数
    BillsDetailViewController *vc;
    NSString *ac; //GetMyReqList 申请 GetMyAfrList 报销 GetMyBorList 借款
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ac = @"GetMyAfrList";
    
    self.titleLabel.text = self.titleStr;
    
    self.navHeightConstraints.constant = 64.0f;
    
    UIButton *firstBtn = (UIButton *)[self.topView viewWithTag:10];
    firstBtn.selected = YES;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshListData];
    }];

    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    [self.tableView.header beginRefreshing];
}


- (void)refreshListData{
    
    p = 0;
    
    NSString *url;
    if (self.undo.boolValue) {
        //已完成
        url = [NSString stringWithFormat:@"ac=%@&u=%@&ukey=%@&pi=%d&ps=20&q=%@",ac,self.uid,self.ukey,p,[_searchText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else
        //未完成
        url = [NSString stringWithFormat:@"ac=%@&u=%@&ukey=%@&pi=%d&ps=20&billtype=ontheway&q=%@",ac,self.uid,self.ukey,p,[_searchText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    [RequestCenter GetRequest:url
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          [self.dataArray removeAllObjects];
                          NSDictionary *dataDic = [responseObject objectForKey:@"msg"];
                          [self.dataArray addObjectsFromArray:[BillsModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"data"]]];
                          
                          [self.tableView reloadData];
                          [self.tableView.header endRefreshing];
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"错误%@",error);
                          [self.tableView.header endRefreshing];
                      }
            showLoadingStatus:NO];
}

- (void)loadMoreData{
    p += 1;
    
    NSString *url;
    if (self.undo.boolValue) {
        //已完成
        url = [NSString stringWithFormat:@"ac=%@&u=%@&ukey=%@&pi=%d&ps=20&q=%@",ac,self.uid,self.ukey,p,[_searchText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else
        //未完成
        url = [NSString stringWithFormat:@"ac=%@&u=%@&ukey=%@&pi=%d&ps=20&billtype=ontheway&q=%@",ac,self.uid,self.ukey,p,[_searchText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    [RequestCenter GetRequest:url
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          NSDictionary *dataDic = [responseObject objectForKey:@"msg"];
                          [self.dataArray addObjectsFromArray:[BillsModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"data"]]];
                          
                          [self.tableView reloadData];
                          [self.tableView.footer endRefreshing];
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [self.tableView.footer endRefreshing];
                      }
            showLoadingStatus:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Btn Action

- (IBAction)backVC:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)searchBill:(id)sender {
    
    if (self.navHeightConstraints.constant == 64.0f) {
      self.navHeightConstraints.constant += 40.0f;
    }
    else
    {
       self.navHeightConstraints.constant -= 40.0f;
    }
}
- (IBAction)doSearchBills:(id)sender {
    
    [self.tableView.header beginRefreshing];
    [_searchText resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tableView.header beginRefreshing];
    [_searchText resignFirstResponder];
    return YES;
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellid = @"cell";
    BillsListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    BillsModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    cell.billNum.text = model.billno;
    cell.billPrice.text = [NSString stringWithFormat:@"￥%@",model.billmoney];
    cell.billName.text = model.pagename;
    
    cell.billTime.text = model.opdate;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@  %@",model.uid,model.deptid];
    cell.billProcess.text = model.flowstatus.length > 0 ? model.flowstatus : @"";
    
    if ([ac isEqualToString:@"GetMyBorList"]) {
        cell.billTypeImage.image = [UIImage imageNamed:@"money"];
    }
    else if ([ac isEqualToString:@"GetMyReqList"]) {
        cell.billTypeImage.image = [UIImage imageNamed:@"apply"];
    }
    else if ([ac isEqualToString:@"GetMyAfrList"]){
        cell.billTypeImage.image = [UIImage imageNamed:@"borrow"];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BillsDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BillsDetail"];
    BillsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    detailVC.billid     = model.billid;
    detailVC.programeId = model.programid;
    detailVC.flowid     = model.flowid;
    detailVC.bills      = model;
    detailVC.reloadData = ^(){
        [self.tableView.header beginRefreshing];
    };
    
    //wo 未完成列表的审核状态
    
    AppDelegate * app=[UIApplication sharedApplication].delegate;
    app.flowstatus=model.flowstatus;
    
    
    
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (IBAction)stateChanege:(UIButton *)sender {
    
    for (UIView *subView in self.topView.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            if (subBtn.tag == sender.tag) {
                subBtn.selected = YES;
                
                CGRect frame = self.lineView.frame;
                [UIView animateWithDuration:0.3 animations:^{
//                    self.lineView.frame = CGRectMake(frame.size.width * (subBtn.tag - 10), frame.origin.y, frame.size.width, frame.size.height);
                    self.lineLeftConstraint.constant =frame.size.width * (subBtn.tag - 10);
                }];
                
                //wo
                AppDelegate *app=[UIApplication sharedApplication].delegate;
                app.zhuanStr=[NSString stringWithFormat:@"%ld",sender.tag];
                
                
                switch (sender.tag) {
                    case 10:
                        ac = @"GetMyAfrList";
                        break;
                    case 11:
                        ac = @"GetMyReqList";
                        break;
                    case 12:
                        ac = @"GetMyBorList";
                        break;
                    default:
                        break;
                }
                [self.tableView.header beginRefreshing];
                
            }
            else
                subBtn.selected = NO;
        }
        
    }
    
    
    
}


#pragma mark - Navigation



@end
