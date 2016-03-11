//
//  BillsDetailViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/5/5.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "BillsDetailViewController.h"
#import "LayoutModel.h"
#import "CostLayoutModel.h"
#import "BillsDetailViewCell.h"
#import "CostDetailViewController.h"
#import "HistoryModel.h"
#import "HistoryViewCell.h"
#import "DocumentsFlowchartCell.h"
#import "SDPhotoBrowser.h"
#import "LinkViewController.h"
#import <QuickLook/QLPreviewController.h>
#import <QuickLook/QLPreviewItem.h>
#import "CTToastTipView.h"
#import "SendMsgViewController.h"
#import "ImageModel.h"
#import "UIImage+SKPImage.h"
#import "CTAssetsPickerController.h"
#import "BianJiViewController.h"
#import "applyChangeModel.h"
#import <Photos/Photos.h>
#import "AppDelegate.h"
@interface BillsDetailViewController ()<SDPhotoBrowserDelegate,QLPreviewControllerDataSource,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UIActionSheetDelegate>{
    NSString *delteImageID;
}
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftConstraint;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong,nonatomic) NSMutableArray *mainLayoutArray; // 主表 布局视图
@property (strong,nonatomic) NSMutableArray *costLayoutArray; // 花费 布局视图
@property (strong,nonatomic) NSMutableArray *pathFlow; // 审批流程
@property (nonatomic,strong) NSMutableArray *mainData;
@property (nonatomic,strong) NSMutableArray *costData;
@property (nonatomic,strong) NSMutableArray *uploadArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSUInteger selectedIndex; // 0:单据详情 1:审批追溯 2:审批流程 default :0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstaraint;
@property (nonatomic,strong) UITextField *beizhuText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (nonatomic , strong) NSMutableArray *imageArray;
@property(nonatomic,strong)UIActionSheet *actionsheet;

//wo
@property(strong,nonatomic)NSDictionary * changedict;
@property(strong,nonatomic)NSMutableArray * changeArr;
@property(strong,nonatomic)applyChangeModel * changeModel;

@property(weak,nonatomic)NSString * tuiHuiStr;
@property(nonatomic)BOOL tuihui;
@property(nonatomic,strong)NSString * leixing;
@end

@implementation BillsDetailViewController
{
    UIView * bgView;
    CGFloat textFiledHeight;
    UIButton *sureBtn;
    UIButton *backBatn;
    UIView *infoView;
    CGFloat lastConstant; // 记录最后一次tableView 与底部的距离
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.billType = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //wo
    self.tuihui=NO;
    
    self.selectedIndex = 0;
    self.selectedion2=0;
    self.title = @"详情";
    UIButton *firstBtn = (UIButton *)[self.topView viewWithTag:10];
    firstBtn.selected = YES;
    _mainLayoutArray = [[NSMutableArray alloc] init];
    _costLayoutArray = [[NSMutableArray alloc] init];
    _mainData = [[NSMutableArray alloc] init];
    _costData = [[NSMutableArray alloc] init];
    _pathFlow = [[NSMutableArray alloc] init];
    //wo 申请转报销转借款
    self.changeArr=[[NSMutableArray alloc]init];
    self.changeModel=[[applyChangeModel alloc]init];
    
    [self requestDataSource];
    self.topConstaraint.constant = -188.0f;
    lastConstant = 50.0f;
    if (self.billType == 1) {
        
        textFiledHeight = 0.0f;
        self.tableViewBottomConstraint.constant = 50 + textFiledHeight;
        UIButton *backBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBt setImage:[UIImage imageNamed:@"right_item"] forState:UIControlStateNormal];
        [backBt setFrame:CGRectMake(80, 10, 44, 44)];
        // [backBt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
        [backBt addTarget:self action:@selector(editItem) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBt];
        self.navigationItem.rightBarButtonItem = back;
        [self addFooterView];
    }
    
    // Do any additional setup after loading the view.
}

//wo添加申请转报销，申请转借款的按钮
-(void)addRightNagationBar{
    AppDelegate *ap=[UIApplication sharedApplication].delegate;
    NSLog(@"转报销转借款%@",ap.zhuanStr);
    NSLog(@"转报销转借款%@",self.leixing);
//    if ([ap.danJu isEqualToString:@"未完成审批"]) {
//        if ([ap.flowstatus isEqualToString:@"未提交"]||[ap.flowstatus isEqualToString:@"已退回"]||[ap.flowstatus isEqualToString:@"已弃申"]) {
//            
//            
//            UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(item3Click:)];
//       //     self.navigationItem.rightBarButtonItems = @[item3];
//        }
//    }
    
    
    if ([ap.zhuanStr isEqualToString:@"11"]) {
        if([ap.danJu isEqualToString:@"已完成审批"]){
            
            if ([self.leixing isEqualToString:@"差旅申请交通费明细"]) {
                UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"转报销" style:UIBarButtonItemStylePlain target:self action:@selector(item1Click:)];
                if (self.changeArr.count) {
                    self.navigationItem.rightBarButtonItem = item1;}
                }else if ([self.leixing isEqualToString:@"差旅申请借款明细"]){
                
                    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"转借款" style:UIBarButtonItemStylePlain target:self action:@selector(item2Click:)];
                    if (self.changeArr.count) {
                        self.navigationItem.rightBarButtonItem=item2;
                        
                        
                    }

                
                }
            
//            UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"转报销" style:UIBarButtonItemStylePlain target:self action:@selector(item1Click:)];
//            
//            UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"转借款" style:UIBarButtonItemStylePlain target:self action:@selector(item2Click:)];
//            if (self.changeArr.count) {
//                self.navigationItem.rightBarButtonItems = @[item1, item2];
//                
                
            
        }
    }
    NSLog(@"changeArr%@",self.changeArr);
}

-(void)item1Click:(id)sender{
    if (self.changeArr.count) {
        for (int i=0; i<self.changeArr.count; i++) {
            if ([[[self.changeArr objectAtIndex:i] objectForKey:@"barText"] isEqualToString:@"转差旅费报销"]) {
                self.changeModel.iid=[[self.changeArr objectAtIndex:i] objectForKey:@"iid"];
                
                self.changeModel.SourceProgramID=[[self.changeArr objectAtIndex:i] objectForKey:@"SourceProgramID"];
                self.changeModel.TargetProgramID=[[self.changeArr objectAtIndex:i] objectForKey:@"TargetProgramID"];
                self.changeModel.barText=[[self.changeArr objectAtIndex:i] objectForKey:@"barText"];
                NSLog(@"barText%@",[[self.changeArr objectAtIndex:i] objectForKey:@"barText"]);
                NSLog(@"TargetProgramID%@",[[self.changeArr objectAtIndex:i] objectForKey:@"TargetProgramID"]);
                NSLog(@"SourceProgramID%@",[[self.changeArr objectAtIndex:i] objectForKey:@"SourceProgramID"]);
                NSLog(@"iid%@",[[self.changeArr objectAtIndex:i] objectForKey:@"iid"]);
                for (NSString *key in self.changeArr[i]) {
                    NSLog(@"%@字典%@",key,self.changeArr[i][key]);
                }
                NSLog(@"数组%@",self.changeArr[i]);
                NSLog(@"模型%@",self.changeModel);
                [self zhuanBaoXiaoHuoJieKuan];
            }
            
        }
    }
    
}
-(void)item2Click:(id)sender{
    
    if (self.changeArr.count) {
        for (int i=0; i<self.changeArr.count; i++) {
            if ([[[self.changeArr objectAtIndex:i] objectForKey:@"barText"] isEqualToString:@"生成借款单"]) {
                self.changeModel.iid=[[self.changeArr objectAtIndex:i] objectForKey:@"iid"];
                
                self.changeModel.SourceProgramID=[[self.changeArr objectAtIndex:i] objectForKey:@"SourceProgramID"];
                self.changeModel.TargetProgramID=[[self.changeArr objectAtIndex:i] objectForKey:@"TargetProgramID"];
                self.changeModel.barText=[[self.changeArr objectAtIndex:i] objectForKey:@"barText"];
                NSLog(@"barText%@",[[self.changeArr objectAtIndex:i] objectForKey:@"barText"]);
                NSLog(@"TargetProgramID%@",[[self.changeArr objectAtIndex:i] objectForKey:@"TargetProgramID"]);
                NSLog(@"SourceProgramID%@",[[self.changeArr objectAtIndex:i] objectForKey:@"SourceProgramID"]);
                NSLog(@"iid%@",[[self.changeArr objectAtIndex:i] objectForKey:@"iid"]);
                for (NSString *key in self.changeArr[i]) {
                    NSLog(@"%@字典%@",key,self.changeArr[i][key]);
                }
                NSLog(@"数组%@",self.changeArr[i]);
                NSLog(@"模型%@",self.changeModel);
                [self zhuanBaoXiaoHuoJieKuan];
            }
            
        }
    }
}

//wo上传后台转借款或报销

-(void)zhuanBaoXiaoHuoJieKuan{
    
    NSString *str=[NSString stringWithFormat:@"ac=AutoCreate&u=%@&SourceProgramID=%@&TargetProgramID=%@&BillID=%@&IsAutoSubmit=%@",self.uid,self.changeModel.SourceProgramID,self.changeModel.TargetProgramID,self.billid,@"0"];
    NSLog(@"请求的转%@",str);
    [RequestCenter GetRequest:str                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          NSLog(@"接收到的responseObject%@",responseObject);
                          [SVProgressHUD showSuccessWithStatus:@"成功"];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"错误%@",error);
                          [SVProgressHUD showSuccessWithStatus:@"失败"];
                      }];
    
    
}



- (void)editItem{
    
    if (self.topConstaraint.constant == -188.0f) {
        self.topConstaraint.constant = 64;
    }
    else
        self.topConstaraint.constant = -188.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFooterView{
    infoView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 50 - textFiledHeight, SCREEN_WIDTH - 20, 50 + textFiledHeight)];
    infoView.backgroundColor = [UIColor whiteColor];
    infoView.tag = 1024;
    [self.view addSubview:infoView];
    
    if (!self.beizhuText) {
        CGFloat y = textFiledHeight == 0 ? 0 :10;
        self.beizhuText = [[UITextField alloc] initWithFrame:CGRectMake(10, y, CGRectGetWidth(infoView.frame) - 45, textFiledHeight)];
        self.beizhuText.placeholder = @"请输入审批意见";
        self.beizhuText.clearsOnBeginEditing = YES;
        self.beizhuText.borderStyle = UITextBorderStyleRoundedRect;
        self.beizhuText.font = [UIFont systemFontOfSize:13];
    }

    [infoView addSubview:self.beizhuText];
    
    CGFloat btnWidth = (CGRectGetWidth(infoView.frame) - 40) / 2.0f;
    sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sureBtn setFrame:CGRectMake(10, CGRectGetMaxY(self.beizhuText.frame) + 10, btnWidth, 30)];
    [sureBtn addTarget:self action:@selector(agreeApprove) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundColor:[UIColor colorWithRed:0.314 green:0.816 blue:0.361 alpha:1.000]];
    [sureBtn setTitle:@"同意" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor]];
    sureBtn.tag = 1025;
    [infoView addSubview:sureBtn];
    
    backBatn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBatn setFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) + 20, CGRectGetMinY(sureBtn.frame), btnWidth, 30)];
    [backBatn addTarget:self action:@selector(backApprove:) forControlEvents:UIControlEventTouchUpInside];
    [backBatn setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
    [backBatn setTitle:@"退回" forState:UIControlStateNormal];
    [backBatn setTitleColor:[UIColor whiteColor]];
    sureBtn.tag = 1026;
    [infoView addSubview:backBatn];
}

#pragma mark - URL Request

/**
 *  单据信息
 */
- (void)requestDataSource{
    
    //ac=GetEditData&u=9&programid=130102&billid=28
    
    NSString * str=[NSString stringWithFormat:@"ac=GetEditData&u=%@&programid=%@&billid=%@",self.uid,self.programeId,self.billid];
    
    NSLog(@"意义%@",str);
    [RequestCenter GetRequest:str                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {

                          NSDictionary * mainLayout = [[[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"] objectForKey:@"main"];
                          NSLog(@"字典%@",mainLayout);
                          NSArray * costLayout = [[[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"] objectForKey:@"details"];
//                          NSLog(@"数组%@",costLayout[0]);
//wo
//                          self.leixing=[costLayout[0] objectForKey:@"name"];
                     //     NSLog(@"类型%@",self.leixing);
                          
                          
                          [_mainLayoutArray addObjectsFromArray:[LayoutModel objectArrayWithKeyValuesArray:[mainLayout objectForKey:@"fields"]]];
                          [_costLayoutArray addObjectsFromArray:[CostLayoutModel objectArrayWithKeyValuesArray:costLayout]];
                          
                          
                          //wo
//                          self.changeArr=[[NSMutableArray alloc] init];
//                          self.changeArr=[[responseObject objectForKey:@"msg"] objectForKey:@"btn"];
//                          
                          
                          
                          NSArray *dataArr = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          _mainData = [dataArr safeObjectAtIndex:0];
                          
                          [self addCommintBtn];
                          
                          [_costData addObjectsFromArray:[dataArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _costLayoutArray.count)]]];
                          _uploadArr = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"msg"] objectForKey:@"upload"]];
//                          if (_uploadArr==nil) {
//                              UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ab_nav_bg.png"]];
//                              [_uploadArr addObject:image];
//                              
//                          }
                          [self.tableView reloadData];
                          [SVProgressHUD dismiss];
                          //wo
//                      [self addRightNagationBar];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }];
    
}

/**
 *  审批历史
 */
- (void)requestHistory{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=GetApproveHistory&u=1&ukey=abc&flowid=57&ProgramID=130102&Billid=9
    
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetApproveHistory&u=%@&ukey=%@&ProgramID=%@&Billid=%@",self.uid,self.ukey,self.programeId,self.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          [SVProgressHUD dismiss];
                          NSArray *array = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          [self.dataArray addObjectsFromArray:[HistoryModel objectArrayWithKeyValuesArray:array]];
                          [self.tableView reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }
            showLoadingStatus:YES];
}

/**
 *  审批流程
 */
- (void)requestFlowPath{
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetFlowPath&u=%@&ukey=%@&ProgramID=%@&Billid=%@",self.uid,self.ukey,self.programeId,self.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                           _pathFlow = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          [SVProgressHUD dismiss];
                          [self.tableView reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }
            showLoadingStatus:YES];
}

/**
 *  转批接口
 *
 *  @param uidStr uidStr
 */
- (void)zhuanpiRequest:(NSString *)uidStr{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=TransferApprove&u=1&ukey=abc&flowid=57&ProgramID=130102&Billid=9&StepID=616&DynamicID=6999&NewAppUid=100004&NewGuid=20140529155715693
    [SVProgressHUD showSuccessWithStatus:@"转批中..."];
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=TransferApprove&u=%@&ukey=%@&flowid=%@&ProgramID=%@&Billid=%@&StepID=%@&DynamicID=%@&NewAppUid=%@&NewGuid=%@",self.uid,self.ukey,_unModel.flowid,_unModel.programid,_unModel.billid,_unModel.stepid,_unModel.dynamicid,uidStr,_unModel.newguid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                              [SVProgressHUD showSuccessWithStatus:@"转批成功!"];
                              [self backVC];
                          }
                          else
                              [self showAlertView:[responseObject objectForKey:@"msg"]];
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }
            showLoadingStatus:NO];
}

/**
 *  加签 接口
 *
 *  @param uidStr uidStr
 */

- (void)jiaqianRequest:(NSString *)uidStr{
    
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=AddSign&u=1&ukey=abc&flowid=57&ProgramID=130102&Billid=9&StepID=616&DynamicID=6999&User=100003,100004,100005
    
    [SVProgressHUD showWithStatus:@"加签中..."];
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=AddSign&u=%@&ukey=%@&flowid=%@&ProgramID=%@&Billid=%@&StepID=%@&DynamicID=%@&User=%@",self.uid,self.ukey,_unModel.flowid,_unModel.programid,_unModel.billid,_unModel.stepid,_unModel.dynamicid,uidStr]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                              
                              [SVProgressHUD showSuccessWithStatus:@"加签成功!"];
                              [self backVC];
                          }
                          else
                              [self showAlertView:[responseObject objectForKey:@"msg"]];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }
            showLoadingStatus:NO];
    
}

- (IBAction)guanzhu:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [SVProgressHUD showWithStatus:@"关注..." maskType:2];
    //http://27.115.23.126:5032/ashx/mobilenew.ashx?ac=BillAttention&u=1&programid=130102&billid=22&status=1
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=BillAttention&u=%@&programid=%@&billid=%@&status=1",self.uid,_unModel.programid,_unModel.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                              [btn setTitle:@"已关注" forState:UIControlStateNormal];
                              [SVProgressHUD showSuccessWithStatus:@"关注成功!"];
                             // [self backVC];
                          }
                          else
                              [self showAlertView:[responseObject objectForKey:@"msg"]];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           [SVProgressHUD dismiss];
                      }
            showLoadingStatus:NO];
    
}


// 单条审批
- (void)singleApprove:(UnApprovalModel *)model type:(NSString *)type{
    //http://27.115.23.126:3032/ashx/mobile.ashx?ac=Approve&u=1&ukey=abc&ProgramID=130102&Billid=3&BillNo=NO130102_9&disc=fuck&stepid=617&returnrule=&dynamicid=6976&returntodynid=0&resultType=pass
    NSString *returntodynid = @"0";
//    if (![model.returnrule isEqualToString:@"ChoiceReturnStep"]) {
//        returntodynid = @"0";
//    }
//    else
//    {
//        
//    }
    
    //wo
    NSString *strRequest=[NSString stringWithFormat:@"ac=Approve&u=%@&ukey=%@&ProgramID=%@&Billid=%@&BillNo=%@&disc=%@&stepid=%@&returnrule=%@&dynamicid=%@&returntodynid=%@&resultType=%@",self.uid,self.ukey,model.programid,model.billid,model.billno,[_beizhuText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],model.stepid,model.returnrule,model.dynamicid,returntodynid,type];
    
    [RequestCenter GetRequest:strRequest
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if([[responseObject objectForKey:@"msg"] isKindOfClass:[NSDictionary class]]){
                              NSString *msg = [[responseObject objectForKey:@"msg"] objectForKey:@"Msg"];
                              if ([msg isEqualToString:@"ok"] && [type isEqualToString:@"pass"]) {
                                  [SVProgressHUD showSuccessWithStatus:@"审批成功"];
                                  [self backVC];
                              }
                              else if ([msg isEqualToString:@"ok"] && [type isEqualToString:@"fail"]){
                                  [SVProgressHUD showSuccessWithStatus:@"退回成功"];
                                  [self backVC];
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

/**
 *  未提交的数据进行提交 : type==0的时候接口
 */
- (void)commintInfo{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=UnCompleteSubmit&u=1&programid=130102&billid=139&billno=PTBX1508160033
    
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=UnCompleteSubmit&u=%@&programid=%@&billid=%@&billno=%@",self.uid,self.programeId,self.bills.billid,self.bills.billno]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                              [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                              if (self.reloadData) {
                                  self.reloadData();
                              }
                              [self.navigationController popViewControllerAnimated:YES];
                          }
                          else
                          {
                              [SVProgressHUD showSuccessWithStatus:@"提交失败"];
                          }
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }];
}

- (void)deleateOrder{
    //http://27.115.23.126:5032/ashx/mobilenew.ashx?ac=DeleteRecord&u=5&programid=130102&billid=382
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=DeleteRecord&u=%@&programid=%@&billid=%@",self.uid,self.programeId,self.bills.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                          if (self.reloadData) {
                              self.reloadData();
                          }
                          [self.navigationController popViewControllerAnimated:YES];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }];
}

#pragma mark - BtnAciton


- (IBAction)changePage:(UIButton *)sender {
    UIView *footerView = [self.view viewWithTag:1024];
    for (UIView *subView in self.topView.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            if (subBtn.tag == sender.tag) {
                subBtn.selected = YES;
                CGRect frame = self.lineView.frame;
                [UIView animateWithDuration:0.3 animations:^{
                    self.lineLeftConstraint.constant =frame.size.width * (subBtn.tag - 10);
                }];
                if (sender.tag == 10) {
                    self.selectedIndex = 0;
                    footerView.hidden = NO;
                    if (self.billType == 1) {
                        self.tableViewBottomConstraint.constant = lastConstant;
                    }
                    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
                    if (self.billType == 0 &&([[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"未提交"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已弃审"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已退回"])) {
                        self.tableViewBottomConstraint.constant = 135.0f;
                    }
                    
                }
                else if(sender.tag == 11){
                    self.selectedIndex = 1;
                    if (self.dataArray.count == 0) {
                        [self requestHistory];
                    }
                    footerView.hidden = YES;
                    self.tableViewBottomConstraint.constant = 0;
                }
                else if (sender.tag == 12){
                    self.selectedIndex = 2;
                    if (self.pathFlow.count == 0) {
                        [self requestFlowPath];
                    }
                    footerView.hidden = YES;
                    self.tableViewBottomConstraint.constant = 0;
                }
                
                [self.tableView reloadData];
            }
            else
                subBtn.selected = NO;
        }
        
    }

}

- (BOOL)isUnCommint{
    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
    return [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"未提交"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已弃审"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已退回"];
}

- (IBAction)callNum:(id)sender {
    [self callAction];
}

- (void)agreeApprove{
    [self singleApprove:_unModel type:@"pass"];
}

- (void)backApprove:(UIButton *)btn{
    
    if (btn.selected == NO) {
        btn.selected = YES;
        [self resizeFootViewFrame:0];
    }
    else {
        if (self.beizhuText.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请填写退回意见"];
        }
        else
        {
            btn.selected = NO;
            [self singleApprove:_unModel type:@"fail"];
            [self resizeFootViewFrame:1];
            //wo
            self.tuiHuiStr=self.beizhuText.text;
        }
    }
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger number = 0;
    switch (self.selectedIndex) {
        case 0:
        {
            if (_mainLayoutArray.count == 0) {
               number = 0;
            }
            else if (_uploadArr.count == 0){
                if ([self isUnCommint]) {
                    number = _mainLayoutArray.count + 2;
                 
                }
                else{
                   number = _mainLayoutArray.count + 1;
                    //更多
                    
                }
            }
            else
                number = _mainLayoutArray.count + 2;
          
        }
            break;
        case 1:{
            number = self.dataArray.count;
        }
            break;
        case 2:{
            number = self.pathFlow.count;
        }
            break;
        default:
            break;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (_selectedIndex) {
        case 0:
        {
            NSString *cellid = @"cell";
            BillsDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            
            UIView *subView = [cell.contentView viewWithTag:203];
            UIView *subView1 = [cell.contentView viewWithTag:204];
            [subView removeFromSuperview];
            [subView1 removeFromSuperview];
            
            NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
            cell.lineViewHeight.constant = 0.5f;
            
            if (indexPath.row < _mainLayoutArray.count) {
                LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row];
                cell.titleLabel.text = [NSString stringWithFormat:@"%@:",model.name];
                if([model.name containsString:@"<"]){
                    cell.titleLabel.text=[self filterHTML:[NSString stringWithFormat:@"%@",model.name]];
                
                }
                cell.contentLabel.text = [mainDataDic objectForKey:model.fieldname];
                
                cell.contentLabelHeight.constant = [self fixStr:[mainDataDic objectForKey:model.fieldname]];
                if ([model.fieldname isEqualToString:@"totalmoney"]) {
                    cell.contentLabel.textColor = [UIColor hex:@"f23f4e"];
                }
                else
                    cell.contentLabel.textColor = [UIColor hex:@"333333"];
                
            }
            if (indexPath.row == _mainLayoutArray.count) {
                cell.titleLabel.text =nil;
                cell.contentLabel.text = nil;
                [cell.contentView addSubview:[self costScrollView]];
                
            }
//            else if (indexPath.row > _mainLayoutArray.count - 3 && indexPath.row < _mainLayoutArray.count + 1){
//                LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row - 1];
//                cell.titleLabel.text = [NSString stringWithFormat:@"%@:",model.name];
//                cell.contentLabel.text = [mainDataDic objectForKey:model.fieldname];
//                cell.contentLabelHeight.constant = [self fixStr:[mainDataDic objectForKey:model.fieldname]];
//                if ([model.fieldname isEqualToString:@"totalmoney"]) {
//                    cell.contentLabel.textColor = [UIColor hex:@"f23f4e"];
//                }
//                else
//                    cell.contentLabel.textColor = [UIColor hex:@"333333"];
//            }
            else if (indexPath.row == _mainLayoutArray.count + 1){
                cell.titleLabel.text =nil;
                cell.contentLabel.text = nil;
                if (!bgView) {
                    bgView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (SCREEN_WIDTH - 36) * 0.75)];
                    bgView.tag = 204;
                }
                NSInteger count = _imageArray.count + _uploadArr.count;
                CGFloat speace = 15.0f;
                CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
                int row = count / 3 + 1;
                //bgView.backgroundColor = [UIColor redColor];
                [bgView setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (speace + imageWidth) * row)];
                [bgView removeFromSuperview];
                [self addItems:bgView];
                [cell.contentView addSubview:bgView];
            }
            
            return cell;

        }
            break;
        case 1:{
            NSString *cellID = @"Histroy";
            HistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryViewCell" owner:self options:nil] lastObject];
            }
            HistoryModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
            cell.name.text = model.cusername;
            cell.time.text = model.approve_date;
            cell.advice.text = model.resulttype;
            cell.stepName.text = model.stepname;
            cell.stepName.hidden = model.stepname.length > 0 ?NO : YES;
           //wo    退回意见
            if ([model.resulttype isEqualToString:@"不同意"]) {
                cell.advice.text = model.appopinion;
            }else{
                cell.advice.text = model.resulttype;
            }
            
            
            
            
            
            if (indexPath.row == self.dataArray.count - 1) {
                cell.lineView.hidden = YES;
            }
            return cell;
        }
            break;
            
        case 2:{
            static NSString *cellstr = @"DocumentsFlowchartCell";
            DocumentsFlowchartCell *cell = (DocumentsFlowchartCell*)[tableView cellForRowAtIndexPath:indexPath];//[tableView dequeueReusableCellWithIdentifier:cellstr];
            if (cell == nil) {
                cell = [[DocumentsFlowchartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstr];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if ([[[_pathFlow objectAtIndex:indexPath.row] objectForKey:@"stepname"] isEqualToString:@"未发起流程"]) {
                cell.lab_title.text = @"未提交";
            }else{
                cell.lab_title.text = [[_pathFlow objectAtIndex:indexPath.row] objectForKey:@"stepname"];
            }
            if (_pathFlow.count == 1) {
                cell.lab_title.backgroundColor = [UIColor colorWithRed:0.098 green:0.490 blue:0.722 alpha:1.000];;
                cell.lab_line.hidden = YES;
                [cell setStyle:1];
            }else if (indexPath.row == 0){
                cell.lab_title.backgroundColor = [UIColor colorWithRed:0.098 green:0.490 blue:0.722 alpha:1.000];;
                cell.lab_line.textColor = [UIColor colorWithRed:0.098 green:0.490 blue:0.722 alpha:1.000];;
                [cell setStyle:1];
            }else if (indexPath.row == _pathFlow.count-1){
                cell.lab_title.backgroundColor = [UIColor colorWithRed:0.941 green:0.227 blue:0.192 alpha:1.000];
                cell.lab_line.hidden = YES;
                [cell setStyle:2];
            }else{
                if ([[[_pathFlow objectAtIndex:indexPath.row] objectForKey:@"isactive"] isEqualToString:@"1"]) {
                    cell.lab_title.backgroundColor = [UIColor colorWithRed:0.847 green:0.737 blue:0.267 alpha:1.000];
                    cell.lab_title.text = [cell.lab_title.text stringByAppendingString:@"(审批中)"];
                }
            }
            cell.backgroundColor = [UIColor clearColor];
            return cell;

        }
            break;
        default:
            break;
    }

    return nil;
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat rowHeight = 0.0f;
    
    if (self.selectedIndex == 0) {
        NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
         if (indexPath.row == _mainLayoutArray.count + 1 && _uploadArr.count != 0){
             NSInteger count = _imageArray.count + _uploadArr.count;
             CGFloat speace = 15.0f;
             CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
             int row;
             if (count %3 == 0) {
                 row = count / 3;
             }
             else{
                 row = count / 3 + 1;
             }
             return (speace + imageWidth) * row + 90;
        }
         else if (indexPath.row == _mainLayoutArray.count + 1 && _uploadArr.count == 0 && [self isUnCommint]){
             NSInteger count = _imageArray.count + _uploadArr.count;
             CGFloat speace = 15.0f;
             CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
             int row = count / 3 + 1;
             return (speace + imageWidth) * row + 10;
         }
//        else if (indexPath.row > _mainLayoutArray.count - 3 && indexPath.row < _mainLayoutArray.count + 1){
//            LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row - 1];
//            rowHeight = [self fixStr:[mainDataDic objectForKey:model.fieldname]] + 20;
//        }
        else if (indexPath.row < _mainLayoutArray.count){
            LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row];
            rowHeight = [self fixStr:[mainDataDic objectForKey:model.fieldname]] + 20;
        }
        else if(_mainLayoutArray.count == indexPath.row && _costLayoutArray.count != 0 )
            rowHeight = 80;
        else
            rowHeight = 0;
    }
    else
    {
        rowHeight = 90.0f;
    }

    return rowHeight;
    
}
-(NSString *)filterHTML:(NSString *)str
{
    NSScanner * scanner = [NSScanner scannerWithString:str];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        str  =  [str  stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    return str;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex == 2) {
        NSMutableDictionary *dict = [_pathFlow objectAtIndex:indexPath.row];
        [CTToastTipView showTipText:[dict objectForKey:@"approveuser"]];
    }
}

#pragma mark - Custom Methods

// 是否显示提交按钮
- (void)addCommintBtn{
    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
    if (self.billType == 0 && ([[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"未提交"] ||[[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已弃审"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已退回"])) {
        
        UIButton *commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commintBtn setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
        [commintBtn setTitle:@"提 交" forState:UIControlStateNormal];
        [commintBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [commintBtn addTarget:self action:@selector(commintInfo) forControlEvents:UIControlEventTouchUpInside];
        [commintBtn setFrame:CGRectMake(10, SCREEN_HEIGHT - 80, SCREEN_WIDTH - 20, 30)];
        [self.view addSubview:commintBtn];
        
        UIButton *deleateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleateButton setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
        [deleateButton setTitle:@"删 除" forState:UIControlStateNormal];
        [deleateButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [deleateButton addTarget:self action:@selector(deleateOrder) forControlEvents:UIControlEventTouchUpInside];
        [deleateButton setFrame:CGRectMake(10, SCREEN_HEIGHT - 40, SCREEN_WIDTH - 20, 30)];
        [self.view addSubview:deleateButton];
        
        UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [uploadButton setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
        [uploadButton setTitle:@"上 传" forState:UIControlStateNormal];
        [uploadButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [uploadButton addTarget:self action:@selector(uploadClick:) forControlEvents:UIControlEventTouchUpInside];
        [uploadButton setFrame:CGRectMake(10, SCREEN_HEIGHT - 120, SCREEN_WIDTH - 20, 30)];
        [self.view addSubview:uploadButton];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(buttontap)];
        [item setTintColor:[UIColor whiteColor]];
        
       self.navigationItem.rightBarButtonItem=item;
        self.tableViewBottomConstraint.constant = 135.0f;
        lastConstant = 135.0f;
    }
//    else
//    {
//       
//            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"dad" style:UIBarButtonItemStylePlain target:self action:@selector(fadsa)];
//            self.navigationItem.rightBarButtonItem=item;
//            
//    }
//    self.billType == 0 && ([[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"未提交"] ||[[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已弃审"] ||
//    if (self.billType==0&&[[mainDataDic objectForKey:@"flowstatus_show"]isEqualToString:@"已审核"]) {
//        UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//        [button setBackgroundImage:[UIImage imageNamed:@"right_item"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(danju) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:button];
//        self.navigationItem.rightBarButtonItem=bar;
    
    if (self.billType==0&&[[mainDataDic objectForKey:@"flowstatus_show"]isEqualToString:@"已提交"]) {
        
        
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10, SCREEN_HEIGHT-60, SCREEN_WIDTH-20, 40)];
        
        
        [btn setTitle:@"回 收" forState:UIControlStateNormal];
        //设置边框为圆角
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:10];
        
        [btn setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
        [btn addTarget:self action:@selector(aller) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.view addSubview:btn];
        self.tableViewBottomConstraint.constant = 50.0f;
        lastConstant = 50.0f;
        
    }
    
}
-(void)aller
{
    NSString *tuiHui =[NSString stringWithFormat:@"ac=Recover&u=%@&programid=%@&billid=%@",self.uid,self.programeId,self.billid];
    NSLog(@"??????%@,???%@,%@",self.uid,self.programeId,self.billid);
    
    [RequestCenter GetRequest:tuiHui parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSString *msg =[responseObject objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            [SVProgressHUD showInfoWithStatus:@"退回成功"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.reloadData) {
                self.reloadData();
                
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"退回失败，请稍后尝试"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }
            showLoadingStatus:YES];
    
}
-(void)danju
{
   self.actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"生成借款",@"生成报销", nil];
    self.actionsheet.tag=3;
    
    
       
    [self.actionsheet showInView:self.view];
    
}
-(void)buttontap
{
    BianJiViewController *bian = [[BianJiViewController alloc] init];
    bian.billid=self.billid;
    bian.programeId=self.programeId;
    bian.flowid=self.flowid;
    bian.bills=self.bills;
    bian.reloadData = ^(){
        [self.tableView.header beginRefreshing];
        
    
    };
    [self.navigationController pushViewController:bian animated:YES];
   
}
- (void)callAction{
    
    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
    NSString *phoneNum = [mainDataDic objectForKey:@"cphone"];
    if (phoneNum.length != 0) {
        [self callPhoneNum:phoneNum];
    }
    else
        [SVProgressHUD showInfoWithStatus:@"电话为空"];
}



/**
 *  重置footerView Type
 *
 *  @param type type 0:现实输入框 1： 不显示输入框
 */
- (void)resizeFootViewFrame:(NSInteger)type{
    if (type == 0) {
        textFiledHeight = 30;
       // UIView *view = [self.view viewWithTag:1024];
        self.tableViewBottomConstraint.constant = 60 + textFiledHeight;
        self.beizhuText.frame = CGRectMake(10, 10, CGRectGetWidth(infoView.frame) - 20, textFiledHeight);
        infoView.frame = CGRectMake(10, SCREEN_HEIGHT - 50 - textFiledHeight, SCREEN_WIDTH - 20, 50 + textFiledHeight);
        CGFloat btnWidth = (CGRectGetWidth(infoView.frame) - 40) / 2.0f;
        [sureBtn setFrame:CGRectMake(10, 45 , btnWidth, 30)];
        [backBatn setFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) + 20, CGRectGetMinY(sureBtn.frame), btnWidth, 30)];
    }
    else
    {
        textFiledHeight = 0;
       // UIView *view = [self.view viewWithTag:1024];
        self.tableViewBottomConstraint.constant = 50 + textFiledHeight;
        self.beizhuText.frame = CGRectMake(10, 0, CGRectGetWidth(infoView.frame) - 20, textFiledHeight);
        infoView.frame = CGRectMake(10, SCREEN_HEIGHT - 50 - textFiledHeight, SCREEN_WIDTH - 20, 50 + textFiledHeight);
        CGFloat btnWidth = (CGRectGetWidth(infoView.frame) - 40) / 2.0f;
        [sureBtn setFrame:CGRectMake(10, 10 , btnWidth, 30)];
        [backBatn setFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) + 20, CGRectGetMinY(sureBtn.frame), btnWidth, 30)];
    }

    lastConstant = self.tableViewBottomConstraint.constant;
}

- (void)backVC{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.reloadData) {
        self.reloadData();
    }
    
}

- (CGFloat )fixStr:(NSString *)str{
    CGRect frame = [str boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 115, 99999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    return  frame.size.height >=0 ? frame.size.height : 20;
}

- (void)addItems:(UIView *)view{
    
    for (UIView *subView in bgView.subviews) {
        [subView removeFromSuperview];
    }
    
//    CGFloat width = CGRectGetWidth(view.frame);
//    CGFloat itemWidth = (width - 4)/3;
//    int rows = _uploadArr.count / 3 + 1;
//    [view setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, itemWidth * 0.75 * rows)];
//    for (int i = 0; i < _uploadArr.count; i++) {
//        int colum = i %3;
//        int row = i/3;
//        NSString *url = [_uploadArr safeObjectAtIndex:i];
//        UIButton *itemView = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//        [itemView setFrame:CGRectMake(colum*(itemWidth + 2), row * (itemWidth * 0.75 + 2), itemWidth, itemWidth * 0.75)];
//        itemView.tag = i;
//        itemView.userInteractionEnabled  = YES;
//        }
//        [itemView addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:itemView];
//    }
    if (_uploadArr.count != 0 || _imageArray.count != 0) {
        NSInteger count = _uploadArr.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 36 - 4*speace) / 3.0f;
        
        for (int i = 0; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            NSString *url = [_uploadArr safeObjectAtIndex:i];
            if ([self fileType:url] == 1) {
                [btn setImage:[UIImage imageNamed:@"word"] forState:UIControlStateNormal];
            }
            else{
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            }
            btn.tag = 1024+ i;
            [btn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
            if ([self isUnCommint]) {
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
                [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
                deleteBtn.tag = 1024+ i;
                [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                [btn addSubview:deleteBtn];
            }
            
        }
        count += _imageArray.count;
        for (int i = _uploadArr.count; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            [btn setBackgroundImage:[_imageArray safeObjectAtIndex:i - _uploadArr.count] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showSelectImage:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2024+ i;
            [bgView addSubview:btn];
            
            if ([self isUnCommint]) {
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
                [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
                deleteBtn.tag = 1024+ i;
                [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                [btn addSubview:deleteBtn];
            }
        }
        int btnCloum = count %3;
        int btnRow = count / 3;
        view.backgroundColor = [UIColor clearColor];
        //NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
        if ([self isUnCommint]) {
            UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
            [addImage setFrame:CGRectMake(speace + (speace + imageWidth) * btnCloum, speace + (speace + imageWidth) * btnRow, imageWidth, imageWidth)];
            [addImage setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [addImage addTarget:self action:@selector(showPickImageVC) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:addImage];
        }
    }
    else{
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 36 - 4*speace) / 3.0f;
        if ([self isUnCommint]) {
            UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
            [addImage setFrame:CGRectMake(speace + (speace + imageWidth) * 0, speace + (speace + imageWidth) * 0, imageWidth, imageWidth)];
            [addImage setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [addImage addTarget:self action:@selector(showPickImageVC) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:addImage];
        }

    }
    
}

#pragma mark - CustomMethods

- (void)deleteImage:(UIButton *)btn{
    
    if (btn.tag >=1024 && btn.tag < 2024) {
        NSString *url = [_uploadArr safeObjectAtIndex:btn.tag - 1024];
        
        NSString *imgid = [[url componentsSeparatedByString:@"?"] lastObject];
        
        
        if (delteImageID.length == 0) {
            delteImageID = [NSString stringWithFormat:@"%@",imgid];
        }
        else{
            delteImageID = [NSString stringWithFormat:@"%@,%@",delteImageID,imgid];
        }
        [_uploadArr removeObject:url];
    }
    else{
        [_imageArray removeObjectAtIndex:btn.tag - 2024];
        [self.tableView reloadData];
    }
    [self.tableView reloadData];
}

- (void)showPickImageVC{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    self.actionsheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"本地相册", nil];
   self.actionsheet.tag=2;
    [self.actionsheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.actionsheet.tag==2) {
        if (buttonIndex == 0) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
        if (buttonIndex == 1)
        {
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
    }
    if (self.actionsheet.tag==3) {
        if (buttonIndex==0) {
            NSLog(@"<<<<<<<<<<<<<<<<<<<<<<");
            
        }
        if (buttonIndex==1) {
            NSLog(@"111111111111111");
            
        }
    }
   
}

- (void)uploadClick:(UIButton *)btn{
    [self uploadImage:0];
}

- (void)uploadImage:(NSInteger)index{
    NSString *fbyte = @"";  //图片bate64
    
    fbyte = [self bate64ForImage:[_imageArray safeObjectAtIndex:index]];
    NSLog(@"bate64 : %@",fbyte);
    NSString *str = [NSString stringWithFormat:@"%@?ac=UploadMoreFile64&u=%@&EX=%@&FName=%@&programid=%@&billid=%@",Web_Domain,self.uid,@".jpg",@"image",self.programeId,self.billid];
    if (delteImageID.length != 0) {
        str = [NSString stringWithFormat:@"%@&delpicid=%@",str,delteImageID];
    }
    NSLog(@"str : %@",str);
    [SVProgressHUD showWithMaskType:2];
    [[AFHTTPRequestOperationManager manager] POST:str
                                       parameters:_imageArray.count != 0? @{@"FByte":fbyte} : nil
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                              if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                                                  [SVProgressHUD dismiss];
                                                  if (index + 1 < _imageArray.count) {
                                                      [self uploadImage:index + 1];
                                                  }
                                                  if (index + 1 == _imageArray.count - 1) {
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                      if (self.reloadData) {
                                                          self.reloadData();
                                                      }
                                                  }
                                              if (_imageArray.count == 0 && delteImageID.length != 0) {
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  if (self.reloadData) {
                                                      self.reloadData();
                                                  }
                                              }
//                                              }
                                          }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              
                                          }];

}

- (NSString *)bate64ForImage:(UIImage *)image{
    UIImage *_originImage = image;
    NSData *_data = UIImageJPEGRepresentation(_originImage, 0.5f);
    NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return _encodedImageStr;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"info:%@",info);
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *image = [UIImage imageWithData:[originalImage thumbImage:originalImage]];
    image = [image fixOrientation:image];
    [_imageArray addObject:image];
    [self.tableView reloadData];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    id class = [assets lastObject];
    for (ALAsset *set in assets) {
        UIImage *image = [UIImage imageWithCGImage:[set aspectRatioThumbnail]];
        [_imageArray addObject:image];
    }
    [self.tableView reloadData];
    NSLog(@"class :%@",[class class]);
}

- (void)showSelectImage:(UIButton *)btn{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
    browser.sourceImagesContainerView = nil;
    
    browser.imageCount = _imageArray.count;
    
    browser.currentImageIndex = btn.tag - 2024 - _uploadArr.count;
    
    browser.delegate = self;
    browser.tag = 11;
    [browser show]; // 展示图片浏览器
}


- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    // UIButton *imageView = (UIButton *)[bgView viewWithTag:index];
    if (browser.tag == 11) {
        return _imageArray[index];
    }
    else
        return nil;
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    if (browser.tag == 10) {
        NSLog(@"url %@",[_uploadArr objectAtIndex:index]);
        
        NSString *model = [_uploadArr objectAtIndex:index];
        
        return [NSURL URLWithString:model];
    }
    else
        return nil;
    
}

- (NSInteger)fileType:(NSString *)fileName{
    NSArray *suffix = [fileName componentsSeparatedByString:@"."];
    NSString *type = [suffix lastObject];
    NSRange range = [type rangeOfString:@"png"];
    NSRange range1 = [type rangeOfString:@"jpg"];
    
    if (range.length >0 || range1.length > 0) {
        return 0;
    }
    else
        return 1;
}

- (void)showImage:(UIButton *)btn{
    NSString *url = [_uploadArr safeObjectAtIndex:btn.tag - 1024];
    if ([self fileType:url] == 1) {
        [[RequestCenter defaultCenter] downloadOfficeFile:url
                                                  success:^(NSString *filename) {
                                                      QLPreviewController *previewVC = [[QLPreviewController alloc] init];
                                                      previewVC.dataSource = self;
                                                      [self presentViewController:previewVC animated:YES completion:^{
                                                          
                                                      }];
                                                  }
                                                  fauiler:^(NSError *error) {
                                                      
                                                  }];

        
    }
        
    else {
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.tag = 10;
        browser.sourceImagesContainerView = nil;
        
        browser.imageCount = _uploadArr.count;
        
        browser.currentImageIndex = btn.tag - 1024;
        
        browser.delegate = self;
        
        [browser show]; // 展示图片浏览器
    }
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return [NSURL fileURLWithPath:[[RequestCenter defaultCenter] filePath]];
}

- (UIScrollView *)costScrollView{
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, 80)];
    scroll.tag = 203;
    [scroll setContentSize:CGSizeMake(95*_costLayoutArray.count-35, 80)];
    scroll.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < _costLayoutArray.count; i++) {
        CostLayoutModel *model = [_costLayoutArray safeObjectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(60 + 35), 10, 57, 57)];
        [btn addTarget:self action:@selector(costDetail:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentMode = UIViewContentModeScaleAspectFit;
//        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photopath]]
//                                 forState:UIControlStateNormal
//                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//         }];
        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photopath]]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ab_nav_bg.png"]];
        
        btn.tag = i;
    
        UILabel *totleMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, 57, 15)];
        totleMoney.textColor = [UIColor whiteColor];
        totleMoney.font = [UIFont systemFontOfSize:15];
        totleMoney.text = model.TotalMoney;
        totleMoney.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:totleMoney];
        
        [scroll addSubview:btn];
    }
    return scroll;
}

-(void)costDetail:(UIButton *)btn{
    
    CostDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CostDetailVC"];
    vc.costLayoutArray = _costLayoutArray;
    vc.costDataArr = _costData;
    vc.selecter=_selectedion2;
    vc.index = btn.tag;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (NSString *)appendStr:(NSArray *)arr{
    
    NSMutableString *returnStr = [NSMutableString string];
    for (int i = 0; i < arr.count; i ++) {
        LianxiModel *model = [arr safeObjectAtIndex:i];
        if (i == arr.count - 1) {
            [returnStr appendString:model.iuserid];
        }
        else{
            [returnStr appendFormat:@"%@,",model.iuserid];
        }
    }
    return returnStr;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"zhuanpiToLink"]) {
        LinkViewController *link = (LinkViewController *)segue.destinationViewController;
        link.linkStyle = 1;
        link.titleStr = @"转批";
        link.selectPerson = ^(NSArray *selectArr ,NSInteger type){
            if (type == 1) {
                NSString *str = [self appendStr:selectArr];
                [self zhuanpiRequest:str];
            }
        };
    }
    else if ([segue.identifier isEqualToString:@"jiaqianToLink"]) {
        LinkViewController *link = (LinkViewController *)segue.destinationViewController;
        link.linkStyle = 2;
        link.titleStr = @"加签";
        link.selectPerson = ^(NSArray *selectArr ,NSInteger type){
            if (type == 2) {
                NSString *str = [self appendStr:selectArr];
                [self jiaqianRequest:str];
            }
        };
    }
    else if ([segue.identifier isEqualToString:@"pushMsgVC"]){
        
        SendMsgViewController *send = (SendMsgViewController *)segue.destinationViewController;
        send.model = self.unModel;
        send.msgType = SendMessageTableType;
    }
}

@end
