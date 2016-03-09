//
//  StayApprovalViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/4/27.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "StayApprovalViewController.h"
#import "StayApprovalModel.h"
#import "StayApprovalViewCell.h"
#import "StayApprovalDetailViewController.h"
#import "UnApprovalModel.h"
#import "BillsDetailViewController.h"

@interface StayApprovalViewController ()
{
    BOOL isEdit;
    NSMutableArray * _selectArr;
    int p;
    NSString *ac; //GetMyWaiteApprove 待审批 GetMyApproved 已审批
    NSInteger tag;
    UIBarButtonItem *selectItem;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftConstraint;

@end

@implementation StayApprovalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    

    _selectArr = [[NSMutableArray alloc] init];
    _bottomView.transform = CGAffineTransformMakeTranslation(0, 150);
    
    p = 0;
    isEdit = NO;
    ac = @"GetMyWaiteApprove";
    tag = 10;
    UIButton *firstBtn = (UIButton *)[self.topView viewWithTag:tag];
    firstBtn.selected = YES;
    
    UIButton *backBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBt setImage:[UIImage imageNamed:@"editItem"] forState:UIControlStateNormal];
    [backBt setFrame:CGRectMake(80, 10, 44, 44)];
   // [backBt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [backBt addTarget:self action:@selector(editItem) forControlEvents:UIControlEventTouchUpInside];
    selectItem = [[UIBarButtonItem alloc] initWithCustomView:backBt];
    self.navigationItem.rightBarButtonItem = selectItem;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [self refreshUnApplyData];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         [self loadUnApplyMoreData];
    }];
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HttpRequest

// 加载未完成审批单据
- (void)refreshUnApplyData{
    p = 0;
    [self resetStatues];
    [self.dataArray removeAllObjects];
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=%@&u=%@&ukey=%@&pi=%d&ps=20",ac,self.uid,self.ukey,p]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          NSDictionary *dataDic = [responseObject objectForKey:@"msg"];
                          [self.dataArray addObjectsFromArray:[UnApprovalModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"data"]]];
                          [self.tableView.header endRefreshing];
                          [self.tableView reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          NSLog(@"%@",error);
                          
                          [self.tableView.header endRefreshing];
                      }
            showLoadingStatus:NO];
}

- (void)loadUnApplyMoreData{
    p += 1;
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=%@&u=%@&ukey=%@&pi=%d&ps=20",ac,self.uid,self.ukey,p]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          NSDictionary *dataDic = [responseObject objectForKey:@"msg"];
                          [self.dataArray addObjectsFromArray:[UnApprovalModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"data"]]];
                          [self.tableView.footer endRefreshing];
                          [self.tableView reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [self.tableView.footer endRefreshing];
                      }
            showLoadingStatus:NO];
}

// 加载已完成审批数据
- (void)refreshApplyData{
    //http://27.115.23.126:3032/ashx/mobile.ashx?ac=GetMyWaiteApprove&u=1&ukey=abc&pi=0&ps=2
    p = 0;
    [self.dataArray removeAllObjects];
    NSString *str = [NSString stringWithFormat:@"ac=%@&u=%@&ukey=%@&pi=%d&ps=20",ac,self.uid,self.ukey,p];
    str =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [RequestCenter GetRequest:str
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          
                          NSDictionary *dataDic = [responseObject objectForKey:@"msg"];
                          [self.dataArray addObjectsFromArray:[StayApprovalModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"data"]]];
                          [self.tableView.header endRefreshing];
                          [self.tableView reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [self.tableView.header endRefreshing];
                      }
            showLoadingStatus:NO];
    
}

- (void)loadMoreData{
    p += 1;
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=%@&u=%@&ukey=%@&pi=%d&ps=20",ac,self.uid,self.ukey,p]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          NSDictionary *dataDic = [responseObject objectForKey:@"msg"];
                          [self.dataArray addObjectsFromArray:[StayApprovalModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"data"]]];
                          [self.tableView.footer endRefreshing];
                          [self.tableView reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [self.tableView.footer endRefreshing];
                      }
            showLoadingStatus:NO];
}

// 单条审批
- (void)singleApprove:(UnApprovalModel *)model type:(NSString *)type desc:(NSString *)desc{
    //http://27.115.23.126:3032/ashx/mobile.ashx?ac=Approve&u=1&ukey=abc&ProgramID=130102&Billid=3&BillNo=NO130102_9&disc=fuck&stepid=617&returnrule=&dynamicid=6976&returntodynid=0&resultType=pass
    NSString *returntodynid = @"0";
//    if (![model.returnrule isEqualToString:@"ChoiceReturnStep"]) {
//        returntodynid = @"0";
//    }
//    else
//    {
//        
//    }
    [SVProgressHUD showWithMaskType:2];
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=Approve&u=%@&ukey=%@&ProgramID=%@&Billid=%@&BillNo=%@&disc=%@&stepid=%@&returnrule=%@&dynamicid=%@&returntodynid=%@&resultType=%@",self.uid,self.ukey,model.programid,model.billid,model.billno,desc,model.stepid,model.returnrule,model.dynamicid,returntodynid,type]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if([[responseObject objectForKey:@"msg"] isKindOfClass:[NSDictionary class]]){
                              NSString *msg = [[responseObject objectForKey:@"msg"] objectForKey:@"Msg"];
                              if ([msg isEqualToString:@"ok"] && [type isEqualToString:@"pass"]) {
                                  [SVProgressHUD showSuccessWithStatus:@"审批成功"];
                                  [self.tableView.header beginRefreshing];
                              }
                              else if ([msg isEqualToString:@"ok"] && [type isEqualToString:@"fail"]){
                                  [SVProgressHUD showSuccessWithStatus:@"退回成功"];
                                  [self.tableView.header beginRefreshing];
                              }
                              else
                              {
                                  [SVProgressHUD showSuccessWithStatus:msg];
                              }
                          }
                          else
                          {
                              [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
                          }
                          
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:NO];
    
}

// 多条审批
- (void)moreApprove:(NSString *)parameters type:(NSString *)type{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=BatchApprove&u=1&
    
    [SVProgressHUD showSuccessWithStatus:@"正在提交审批" maskType:2];
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=BatchApprove&u=%@&AppMsg=%@",self.uid,parameters]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if([[responseObject objectForKey:@"msg"] isKindOfClass:[NSDictionary class]]){
                              NSString *msg = [[responseObject objectForKey:@"msg"] objectForKey:@"Msg"];
                              if ([msg isEqualToString:@"ok"] && [type isEqualToString:@"pass"]) {
                                  [SVProgressHUD showSuccessWithStatus:@"审批成功"];
                                  [self.tableView.header beginRefreshing];
                              }
                              else if ([msg isEqualToString:@"ok"] && [type isEqualToString:@"fail"]){
                                  [SVProgressHUD showSuccessWithStatus:@"退回成功"];
                                  [self.tableView.header beginRefreshing];
                              }
                              else
                              {
                                  [SVProgressHUD showInfoWithStatus:msg];
                              }
                          }
                          else
                          {
                              [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
                          }
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:NO];
    
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellid = @"cell";
    StayApprovalViewCell *cell = (StayApprovalViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    
    

    if ([ac isEqualToString:@"GetMyApproved"]) {
        id unkonwModel = [self.dataArray safeObjectAtIndex:indexPath.row];
        if ([unkonwModel isKindOfClass:[StayApprovalModel class]]) {
            StayApprovalModel *model = [self.dataArray objectAtIndex:indexPath.row];
            cell.markImage.hidden = YES;
            cell.selectBtn.hidden = YES;
            cell.flowStatue.hidden = NO;
          
            cell.category.text = model.pagename;
            
            NSString *str = [model.pagename substringToIndex:1];
            cell.titleLabel.text = str;
       

            
            if ([str isEqualToString:@"差"]) {
                cell.categoryImage.image = [UIImage imageNamed:@"chailv.jpg"];
            }
            else if ([str isEqualToString:@"招"]) {
                cell.categoryImage.image = [UIImage imageNamed:@"zhaodai.jpg"];
            }
            
            else if ([str isEqualToString:@"普"]) {
                cell.categoryImage.image = [UIImage imageNamed:@"putong.jpg"];
            }
            else if ([ac isEqualToString:@"借"]){
                cell.categoryImage.image = [UIImage imageNamed:@"jiekuan.jpg"];
            }
            else {
                cell.categoryImage.image = [UIImage imageNamed:@"qita.jpg"];
            }
            
            
            
            cell.time.text = model.opdate;
            cell.name.text = [NSString stringWithFormat:@"%@  %@",model.submituser,model.deptid];
            cell.money.text = [NSString stringWithFormat:@"￥%@",model.billmoney];
            cell.decs.text = model.billno;
            cell.edit = NO;
            cell.flowStatue.text = model.flowstatus;
            [cell resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
        }
    }
    else{
        id unkonwModel = [self.dataArray safeObjectAtIndex:indexPath.row];
        if ([unkonwModel isKindOfClass:[UnApprovalModel class]] ) {
            UnApprovalModel *model = (UnApprovalModel *)unkonwModel;
            if (isEdit) {
                cell.markImage.hidden = !model.status;
                cell.selectBtn.hidden = NO;
                cell.flowStatue.hidden = YES;
            }
            else{
                cell.markImage.hidden = YES;
                cell.selectBtn.hidden = YES;
                cell.flowStatue.hidden = NO;
            }
            [cell resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            
            

            cell.category.text = model.programname;
            
        
            NSString *str = [model.programname substringToIndex:1];
            cell.titleLabel.text = str;
            
            
            if ([str isEqualToString:@"差"]) {
                cell.categoryImage.image = [UIImage imageNamed:@"chailv.jpg"];
            }
            else if ([str isEqualToString:@"招"]) {
                cell.categoryImage.image = [UIImage imageNamed:@"zhaodai.jpg"];
            }
            
            else if ([str isEqualToString:@"普"]) {
                cell.categoryImage.image = [UIImage imageNamed:@"putong.jpg"];
            }
            else if ([ac isEqualToString:@"借"]){
                cell.categoryImage.image = [UIImage imageNamed:@"jiekuan.jpg"];
            }
            else {
                cell.categoryImage.image = [UIImage imageNamed:@"qita.jpg"];
            }

            
        
            cell.time.text = model.submitdate;
            cell.name.text = [NSString stringWithFormat:@"%@  %@",model.submituser,model.bdeptid];
            cell.money.text = [NSString stringWithFormat:@"￥%@",model.totalmoney];
            cell.decs.text = model.billno;
            cell.flowStatue.text = model.flowstatus;
            cell.edit = YES;
        }

    }
    cell.selectItem = ^(){
        UnApprovalModel *model = [self.dataArray objectAtIndex:indexPath.row];
        model.status = model.status ? NO: YES;
        [self selectItem:model];
        [self.tableView reloadData];
    };
    
    cell.backApply = ^(StayApprovalViewCell *cell){
        NSIndexPath *index = [tableView indexPathForCell:cell];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写退回意见"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"退回", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = index.row;
        [alert show];
    };
    cell.agreeApply = ^(StayApprovalViewCell *cell){
        NSIndexPath *index = [tableView indexPathForCell:cell];
        UnApprovalModel *model = [self.dataArray safeObjectAtIndex:index.row];
        [self singleApprove:model type:@"pass" desc:@""];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BillsDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BillsDetail"];
    if ([ac isEqualToString:@"GetMyApproved"]) {
        StayApprovalModel *model = [self.dataArray objectAtIndex:indexPath.row];
        vc.programeId = model.programid;
        vc.billid = model.billid;
    }
    else
    {
        UnApprovalModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
        vc.programeId = model.programid;
        vc.billid = model.billid;
        vc.unModel = model;
        vc.billType = 1;
        vc.reloadData = ^(){
            [self.tableView.header beginRefreshing];
        };
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma  mark AlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *text = [alertView textFieldAtIndex:0];
        if (text.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入退回意见"];
            return;
        }
    if (alertView.tag == 1000000111) {
        [self moreApproveParameters:@"fail" dsc:[text.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else{
        
        UnApprovalModel *model = [self.dataArray safeObjectAtIndex:alertView.tag];
        
        [self singleApprove:model type:@"fail" desc:[text.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
}

#pragma mark - Custom Methods

- (void)hidesRightItem{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)showRightItem{
    
    if (self.navigationItem.rightBarButtonItem == nil) {
        self.navigationItem.rightBarButtonItem = selectItem;
    }
}

- (void)selectItem:(UnApprovalModel *)model{
    
    if (model.status) {
        [_selectArr addObject:model];
    }
    else
    {
        [_selectArr removeObject:model];
    }

    UILabel *label = (UILabel *)[_bottomView viewWithTag:12];
    label.text = [NSString stringWithFormat:@"已选择%d个项目同时处理",_selectArr.count];
}

#pragma mark - Button Action

- (IBAction)changePage:(UIButton *)sender {
    for (UIView *subView in self.topView.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            if (subBtn.tag == sender.tag) {
                subBtn.selected = YES;
                
                CGRect frame = self.lineView.frame;
                [UIView animateWithDuration:0.3 animations:^{
//                    self.lineView.frame = CGRectMake(frame.size.width * (subBtn.tag - 10), frame.origin.y, frame.size.width, frame.size.height);
                    self.lineLeftConstraint.constant = frame.size.width * (subBtn.tag - 10);
                }];
//                self.tableView.header = nil;
//                self.tableView.footer = nil;
                switch (sender.tag) {
                    case 10:
                    {
                        ac = @"GetMyWaiteApprove";
                        [self showRightItem];
                        self.tableView.header.refreshingBlock = ^{
                            [self refreshUnApplyData];
                        };
                        self.tableView.footer.refreshingBlock = ^{
                            [self loadUnApplyMoreData];
                        };
                    }
                        break;
                    case 11:
                    {
                        ac = @"GetMyApproved";
                        if (isEdit) {
                            isEdit = NO;
                            [self unSelectedState];
                        }
                        [self hidesRightItem];
                        self.tableView.header.refreshingBlock = ^{
                            [self refreshApplyData];
                        };
                        self.tableView.footer.refreshingBlock = ^{
                            [self loadMoreData];
                        };
                    }
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


//进入编辑草稿页面
- (void)editItem{
    if ([ac isEqualToString:@"GetMyApproved"]) {
        return;
    }
    isEdit = isEdit ? NO : YES;
    
    if (!isEdit) {
        [self unSelectedState];
    }
    else{
        self.bottomConstraint.constant = CGRectGetHeight(_bottomView.frame);
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    
    [self.tableView reloadData];
}

- (void)unSelectedState{
    for (StayApprovalModel *model in self.dataArray) {
        model.status = NO;
    }
    self.bottomConstraint.constant = 0.0f;
    
    self.bottomView.transform = CGAffineTransformMakeTranslation(0, 150);
    
    [self resetStatues];
}

- (void)resetStatues{
    // 底部视图消失时，重置选择数组
    [_selectArr removeAllObjects];
    _selectLabel.text = [NSString stringWithFormat:@"已选择%d个项目同时处理",_selectArr.count];
}

- (IBAction)moreAgreeApprove:(id)sender {

    [self moreApproveParameters:@"pass" dsc:@""];

}

- (IBAction)moreBackApprove:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写退回意见"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"退回", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1000000111;
    [alert show];
    
}

- (void)moreApproveParameters:(NSString *)type dsc:(NSString *)dsc{
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < _selectArr.count; i++) {
        UnApprovalModel *model = [_selectArr safeObjectAtIndex:i];
        NSString *signalStr = [NSString stringWithFormat:@"ProgramID=%@,BillNo=%@,BillID=%@,disc=%@,stepid=%@,returnrule=%@,dynamicid=%@,ResultType=%@",model.programid,model.billno,model.billid,dsc,model.stepid,model.returnrule,model.dynamicid,type];
        if (i == _selectArr.count - 1) {
            str = (NSMutableString *)[str stringByAppendingFormat:@"%@",signalStr];
        }
        else
            str = (NSMutableString *)[str stringByAppendingFormat:@"%@;",signalStr];
    }
    NSLog(@"str : %@",str);
    
    [self moreApprove:str type:type];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
        

    
}

@end
