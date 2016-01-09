//
//  BianJiViewController.m
//  Thinkape-iOS
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 TIXA. All rights reserved.
//

#import "BianJiViewController.h"
#import "BillsDetailViewController.h"
#import "LayoutModel.h"
#import "CostLayoutModel.h"

#import "CostDetailViewController.h"
#import "HistoryModel.h"

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
#import "HomeViewController.h"
#import "BianjiTableViewCell.h"
#import "KindsItemsView.h"
#import "KindsModel.h"
#import "KindsLayoutModel.h"
#import "KindsPickerView.h"
#import "KindsItemModel.h"
#import "DatePickerView.h"
#import "Bianjito.h"
#import "AppDelegate.h"
@interface BianJiViewController ()<UITableViewDataSource,UITableViewDelegate,SDPhotoBrowserDelegate,QLPreviewControllerDataSource,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UIActionSheetDelegate,KindsItemsViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSMutableArray *mainLayoutArray; // 主表 布局视图
@property (weak, nonatomic) IBOutlet UIView *smallview;
@property (strong,nonatomic) NSMutableArray *costLayoutArray2;

@property (strong,nonatomic) NSMutableArray *pathFlow; // 审批流程
@property (nonatomic,strong) NSMutableArray *mainData;
@property (nonatomic,strong) NSMutableArray *costData2;
@property (nonatomic,strong) NSMutableArray *uploadArr;
@property (strong, nonatomic) NSMutableArray *layoutArray;
@property (nonatomic,strong) UITextField *beizhuText;
@property(nonatomic,strong)UIActionSheet *actionshoot;
@property(nonatomic,strong)NSString *stringto;
@property (strong, nonatomic) NSMutableDictionary *tableViewDic;
@property (nonatomic , strong) NSMutableArray *imageArray;
@property (strong, nonatomic) NSString *newflag;
//试验用
@property (strong, nonatomic) KindsModel *selectModel;
@property (strong, nonatomic) KindsPickerView *kindsPickerView;
@property(nonatomic,strong)NSMutableArray *datestring;
@property(nonatomic,strong)DatePickerView *datePickerView;
@property(nonatomic,strong)NSString *datetext;
@property(nonatomic,strong)UITextField *textfiedate;
@property(nonatomic,assign)BOOL ishoer;
@end

@implementation BianJiViewController
{
    NSString *delteImageID;
    UIView *bgView;
    CGFloat textFiledHeight;
    UIButton *sureBtn;
    UIButton *backBatn;
    UIView *infoView;
    BOOL isSinglal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedion=1;
    self.title=@"详情";
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    
    _mainLayoutArray = [[NSMutableArray alloc] init];
    _costLayoutArray2 = [[NSMutableArray alloc] init];
    _mainData = [[NSMutableArray alloc] init];
    _costData2 = [[NSMutableArray alloc] init];
    _pathFlow = [[NSMutableArray alloc] init];
    
    self.datestring=[[NSMutableArray alloc] init];
    [self requestDataSource];
}

- (IBAction)Cancel:(id)sender {
}
- (IBAction)Save:(id)sender {
//    [self requestEdithBillsType];
}

- (void)requestDataSource{
    
    //ac=GetEditData&u=9&programid=130102&billid=28
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=EditData&u=%@&programid=%@&billid=%@",self.uid ,self.programeId,self.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          NSDictionary * mainLayout = [[[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"] objectForKey:@"main"];
                          NSArray * costLayout = [[[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"] objectForKey:@"details"];
                          [_mainLayoutArray addObjectsFromArray:[LayoutModel objectArrayWithKeyValuesArray:[mainLayout objectForKey:@"fields"]]];
                          [_costLayoutArray2 addObjectsFromArray:[CostLayoutModel objectArrayWithKeyValuesArray:costLayout]];
                          NSArray *dataArr = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          _mainData = [dataArr safeObjectAtIndex:0];
                          
                          
                          //                          [self addCommintBtn];
                          
                          [_costData2 addObjectsFromArray:[dataArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _costLayoutArray2.count)]]];
                          
                          _uploadArr = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"msg"] objectForKey:@"upload"]];
                          
                          [self.tableview reloadData];
                          [SVProgressHUD dismiss];
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if (_uploadArr==nil) {
                              UIImageView *image =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ab_nav_bg.png"]];
                              
                             
                             
                              
                              [_uploadArr addObject:image];
                              
                          }
                          
                      }];
    
}
- (void)requestFlowPath{
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetFlowPath&u=%@&ukey=%@&ProgramID=%@&Billid=%@",self.uid,self.ukey,self.programeId,self.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          //                          _pathFlow = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          _pathFlow =[responseObject objectForKey:@"msg"];
                          _pathFlow = [responseObject objectForKey:@"data"];
                          
                          [SVProgressHUD dismiss];
                          [self.tableview reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }
            showLoadingStatus:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger number = 0;
 
    if (_mainLayoutArray.count == 0) {
        
        number = 0;
      
        
        
    }
    else if (_uploadArr.count == 0){
        
        
        
        number = _mainLayoutArray.count + 1;
        
        if ([self isUnCommint]) {
            number = _mainLayoutArray.count + 2;
            
            
        }
        
    }
    else
        
        number = _mainLayoutArray.count + 2;
    //                  }
    //            break;
    //        case 1:{
    //            number = self.dataArray.count;
    //
    //        }
    //            break;
    //        case 2:{
    //            number = self.pathFlow.count;
    //        }
    //            break;
    //        default:
    //            break;
    //    }
    return number;
}
-(void)button{
    NSLog(@"ascasc");
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    BianjiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"BianjiTableViewCell" owner:self options:nil] lastObject];
        
    }
    UIView *subView = [cell.contentView viewWithTag:203];
    UIView *subView1 = [cell.contentView viewWithTag:204];
    [subView removeFromSuperview];
    [subView1 removeFromSuperview];
    
    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
    //    cell.lineViewHeight.constant = 0.5f;
    
    if (indexPath.row < _mainLayoutArray.count) {
        LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row];
        cell.leftlabel.text = [NSString stringWithFormat:@"%@:",model.name];
        //        cell.rightbutton text = [mainDataDic objectForKey:model.fieldname];
        //        [cell.rightbutton setTitle:[mainDataDic objectForKey:model.fieldname] forState:UIControlStateNormal];
//        [cell.rightButton setTitle:[NSString stringWithFormat:@"%@",[mainDataDic objectForKey:model.fieldname]] forState:UIControlStateNormal];
//        [cell.rightButton setTitleColor:[UIColor blackColor]];
        cell.textfield.text= [NSString stringWithFormat:@"%@",[mainDataDic objectForKey:model.fieldname]];
        
        
        //        cell.contentLabelHeight.constant = [self fixStr:[mainDataDic objectForKey:model.fieldname]];
        if ([model.fieldname isEqualToString:@"totalmoney"]) {
            //            cell.leftlabel.textColor = [UIColor hex:@"f23f4e"];
            cell.leftlabel.textColor=[UIColor hex:@"f23f4e"];
//        }
     if ([model.fieldname isEqualToString:@"billdate_show"]) {
         

         cell.textfield.tag=1;
         [self aller];
         
        
            
         
             }
//            if ([model.fieldname isEqualToString:@"deptid_show"]) {
//                
//            }
////         
       }
    
        else
            cell.leftlabel.textColor = [UIColor hex:@"333333"];
        
    }
    if (indexPath.row == _mainLayoutArray.count) {
        
        cell.leftlabel.text =nil;
        
//         [cell.rightButton setTitle:@"" forState:UIControlStateNormal];
//        [cell.contentView addSubview:[self costScrollView]];
        cell.textfield.text=nil;
        [cell.contentView addSubview:[self costScrollView]];
        
    }
    //注释看看删不删掉
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
        cell.leftlabel.text =nil;
        cell.textfield.text=nil;
//        [cell.rightButton setTitle:@"" forState:UIControlStateNormal];
        
        if (!bgView) {
            bgView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (SCREEN_WIDTH - 36) * 0.75)];
            bgView.tag = 204;
        }
        AppDelegate *app =[UIApplication sharedApplication].delegate;
        app.uptateimage=_uploadArr;
        app.imagedate=_imageArray;
        
        NSInteger count = _imageArray.count + _uploadArr.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
        int row = count / 3 + 1;
//        bgView.backgroundColor = [UIColor redColor];
        [bgView setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (speace + imageWidth) * row)];
        [bgView removeFromSuperview];
        [self addItems:bgView];
    
        
        [cell.contentView addSubview:bgView];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   
  
    return cell;
    
}
-(void)aller
{
    NSLog(@">>>>>>>");
}
- (void)addDatePickerView:(NSInteger)tag date:(NSString *)date{
    if (!self.datePickerView) {
        self.datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
        [self.datePickerView setFrame:CGRectMake(0, self.view.frame.size.height - 218, self.view.frame.size.width, 218)];
    }
    __block BianJiViewController *weakSelf = self;
//    self.datePickerView.tag = tag;
    
//    if (date.length != 0) {
//        self.datePickerView.date = date;
//    }
    
    self.datePickerView.selectDateCallBack = ^(NSString *date){
      
      
       
        date =[NSString stringWithFormat:@"%@",self.textfiedate.text];
        weakSelf.textfiedate.text=date;
       
//        weakSelf.datestring = [NSMutableArray arrayWithObject:weakSelf.datetext];
        
        
       
        
       
       
//        KindsLayoutModel *layoutModel =[KindsLayoutModel new];
//       layoutModel = [weakSelf.layoutArray safeObjectAtIndex:tag];
        
//        [weakSelf.XMLParameterDic setObject:date forKey:layoutModel.key];
//        [weakSelf.tableViewDic setObject:date forKey:layoutModel.key];
       [weakSelf.datePickerView closeView:nil];
       
        [weakSelf.tableview reloadData];
    };
    [self.view addSubview:self.datePickerView];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField =(UITextField *)[self.view viewWithTag:1];
//     KindsLayoutModel *layoutModel =[KindsLayoutModel new];
//   layoutModel = [self.layoutArray safeObjectAtIndex:textField.tag];
//    if (layoutModel.datasource.length > 0) {
//        isSinglal = layoutModel.IsSingle;
//        [self kindsDataSource:layoutModel];
//        return NO;
//    }
//    else if ([layoutModel.SqlDataType isEqualToString:@"date"]){
    
 
    
   
//        [self addDatePickerView:textField.tag date:textField.text];

    
   
    
    return NO;
    
//    }
//    else
//        return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat rowHeight = 0.0f;
    
    //    if (self.selectedIndex == 0) {
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
        return (speace + imageWidth) * row + 10;
    }
    else if (indexPath.row == _mainLayoutArray.count + 1 && _uploadArr.count == 0 && [self isUnCommint]){
        NSInteger count = _imageArray.count + _uploadArr.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
        int row = count / 3 + 1;
        return (speace + imageWidth) * row + 10;
    }
    //看看要不要删掉
    //        else if (indexPath.row > _mainLayoutArray.count - 3 && indexPath.row < _mainLayoutArray.count + 1){
    //           LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row - 1];
    //           rowHeight = [self fixStr:[mainDataDic objectForKey:model.fieldname]] + 20;
    //        }
    else if (indexPath.row < _mainLayoutArray.count){
        LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row];
        rowHeight = [self fixStr:[mainDataDic objectForKey:model.fieldname]] + 20;
    }
    else if(_mainLayoutArray.count == indexPath.row && _costLayoutArray2.count != 0 )
        rowHeight = 80;
    
    else
    {
        rowHeight = 0;
        
    }
    
    
    
    
    
    return rowHeight;
    
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //    if (self.selectedIndex == 2) {
//    NSMutableDictionary *dict = [_pathFlow objectAtIndex:indexPath.row];
//    [CTToastTipView showTipText:[dict objectForKey:@"approveuser"]];
//    //    }
//}
// 单条审批
//- (void)singleApprove:(UnApprovalModel *)model type:(NSString *)type{
//    //http://27.115.23.126:3032/ashx/mobile.ashx?ac=Approve&u=1&ukey=abc&ProgramID=130102&Billid=3&BillNo=NO130102_9&disc=fuck&stepid=617&returnrule=&dynamicid=6976&returntodynid=0&resultType=pass
//    NSString *returntodynid = @"0";
//    //看看这条能不能删掉
//    if (![model.returnrule isEqualToString:@"ChoiceReturnStep"]) {
//        returntodynid = @"0";
//    }
//    else
//    {
//
//    }
//    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=Approve&u=%@&ukey=%@&ProgramID=%@&Billid=%@&BillNo=%@&disc=%@&stepid=%@&returnrule=%@&dynamicid=%@&returntodynid=%@&resultType=%@",self.uid,self.ukey,model.programid,model.billid,model.billno,[_beizhuText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],model.stepid,model.returnrule,model.dynamicid,returntodynid,type]
//                   parameters:nil
//                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//                          if([[responseObject objectForKey:@"msg"] isKindOfClass:[NSDictionary class]]){
//                              NSString *msg = [[responseObject objectForKey:@"msg"] objectForKey:@"Msg"];
//                              if ([msg isEqualToString:@"ok"] && [type isEqualToString:@"pass"]) {
//                                  [SVProgressHUD showSuccessWithStatus:@"审批成功"];
//                                  [self backVC];
//                              }
//                              else if ([msg isEqualToString:@"ok"] && [type isEqualToString:@"fail"]){
//                                  [SVProgressHUD showSuccessWithStatus:@"退回成功"];
//                                  [self backVC];
//                              }
//                              else
//                              {
//                                  [SVProgressHUD showSuccessWithStatus:msg];
//                              }
//                          }
//                          else
//                          {
//                              [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
//                          }
//
//                      }
//                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//                      }
//            showLoadingStatus:NO];
//
//}
//- (void)deleateOrder{
//    //http://27.115.23.126:5032/ashx/mobilenew.ashx?ac=DeleteRecord&u=5&programid=130102&billid=382
//    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=DeleteRecord&u=%@&programid=%@&billid=%@",self.uid,self.programeId,self.bills.billid]
//                   parameters:nil
//                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//
//                          [SVProgressHUD showSuccessWithStatus:@"删除成功"];
//                          if (self.reloadData) {
//                              self.reloadData();
//                          }
//                          [self.navigationController popViewControllerAnimated:YES];
//                      }
//                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                          [SVProgressHUD dismiss];
//                      }];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)isUnCommint{
    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
    return [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"未提交"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已弃审"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已退回"];
}
//- (void)agreeApprove{
//    [self singleApprove:_unModel type:@"pass"];
//}
- (void)resizeFootViewFrame:(NSInteger)type{
    if (type == 0) {
        textFiledHeight = 30;
        // UIView *view = [self.view viewWithTag:1024];
        //        self.tableViewBottomConstraint.constant = 60 + textFiledHeight;
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
        //        self.tableViewBottomConstraint.constant = 50 + textFiledHeight;
        self.beizhuText.frame = CGRectMake(10, 0, CGRectGetWidth(infoView.frame) - 20, textFiledHeight);
        infoView.frame = CGRectMake(10, SCREEN_HEIGHT - 50 - textFiledHeight, SCREEN_WIDTH - 20, 50 + textFiledHeight);
        CGFloat btnWidth = (CGRectGetWidth(infoView.frame) - 40) / 2.0f;
        [sureBtn setFrame:CGRectMake(10, 10 , btnWidth, 30)];
        [backBatn setFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) + 20, CGRectGetMinY(sureBtn.frame), btnWidth, 30)];
    }
    
    //    lastConstant = self.tableViewBottomConstraint.constant;
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
    //        [itemView addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
    //        [view addSubview:itemView];
    //                }
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
        //看看都不能删掉，注意只有一行
        //       NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
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
        [self.tableview reloadData];
    }
    [self.tableview reloadData];
}

- (void)showPickImageVC{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    self.actionshoot = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"本地相册", nil];
    self.actionshoot.tag=200;
    [self.actionshoot showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==200) {
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
        //    }else{
        //
        if (buttonIndex==0) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
            //              [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=AutoCreate&u=1&sourceprogramid=%@&targetprogramid=%@&billid=%@",self.uid,_unModel.SourceProgramID,_unModel.TargetProgramID,_unModel.billid,]] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            //          NSArray *msg = [responseObject objectForKey:@"msg"];
            //          for (NSDictionary *dict in msg) {
            //              if ([[dict objectForKey:@"title"] isEqualToString:@"差旅费用报销"]) {
            //
            //              }
            //          }
            //      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //          <#code#>
            //      }];
        }
        //    if (buttonIndex==1) {
        //        NSLog(@"借款");
        //    }
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
                                              //看看能不能删掉
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
    [self.tableview reloadData];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    id class = [assets lastObject];
    for (ALAsset *set in assets) {
        UIImage *image = [UIImage imageWithCGImage:[set thumbnail]];
        [_imageArray addObject:image];
    }
    [self.tableview reloadData];
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
    //    UIButton *imageView = (UIButton *)[bgView viewWithTag:index];
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
    [scroll setContentSize:CGSizeMake(95*_costLayoutArray2.count-35, 80)];
    scroll.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < _costLayoutArray2.count; i++) {
        CostLayoutModel *model = [_costLayoutArray2 safeObjectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(60 + 35), 10, 57, 57)];
        [btn addTarget:self action:@selector(costDetails:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentMode = UIViewContentModeScaleAspectFit;
//        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photopath]]
//                                 forState:UIControlStateNormal
//                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                }];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photopath]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ab_nav_bg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
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
//
//-(void)costDetail:(UIButton *)btn{
//    
//    CostDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CostDetailVC"];
//    vc.costLayoutArray = _costLayoutArray;
//    vc.costDataArr = _costData;
//    vc.index = btn.tag;
//    [self.navigationController pushViewController:vc animated:YES];
//    
//    
//}
-(void)costDetails:(UIButton *)btn
{
//    CostDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CostDetailVC"];
    Bianjito *vc = [[Bianjito alloc] init];
    
    vc.costLayoutArray = self.costLayoutArray2;
    vc.costDataArr = self.costData2;
  
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
//实验
//- (void)selectItem:(NSString *)name ID:(NSString *)ID view:(KindsItemsView *)view{
//    NSInteger tag = view.tag;
//    KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:tag];
//    [self.XMLParameterDic setObject:ID forKey:layoutModel.key];
//    [self.tableViewDic setObject:name forKey:layoutModel.key];
//    [view closed];
//    [self.tableview reloadData];
//}

//- (void)selectItemArray:(NSArray *)arr view:(KindsItemsView *)view{
//    NSString *idStr = @"";
//    NSString *nameStr = @"";
//    NSInteger tag = view.tag;
//    KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:tag];
//    int i = 0;
//    for (KindsItemModel *model in arr) {
//        if (i == 0) {
//            idStr = [NSString stringWithFormat:@"%@",model.ID];
//            nameStr = [NSString stringWithFormat:@"%@",model.name];
//        }
//        else{
//            idStr = [NSString stringWithFormat:@"%@,%@",idStr,model.ID];
//            nameStr = [NSString stringWithFormat:@"%@,%@",nameStr,model.name];
//        }
//        i++;
//    }
//    [self.XMLParameterDic setObject:idStr forKey:layoutModel.key];
//    [self.tableViewDic setObject:nameStr forKey:layoutModel.key];
//    [self.tableview reloadData];
//}
//- (void)billDetails{
//    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=GetSspGridField&u=9&programid=130102&gridmainid=130102
//    //
//    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetSspGridField_IOS&u=%@&programid=%@&gridmainid=%@",self.uid,_selectModel.programid,_selectModel.gridmainid]
//                   parameters:nil
//                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//                          [self.layoutArray removeAllObjects];
//                          NSDictionary *dataDic = [[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"];
//                          KindsLayoutModel *layoutModel = [[KindsLayoutModel alloc] init];
//                          layoutModel.Name = @"类别";
//                          self.newflag = [dataDic objectForKey:@"new"];
//                          self.newflag = self.newflag.length > 0 ? self.newflag : @"yes";
//                          [self.layoutArray addObject:layoutModel];
//                          [self saveLayoutKindsToDB:dataDic callbakc:^{
//                              [self.tableview reloadData];
//                              [SVProgressHUD dismiss];
//                          }];
//                          
//                      }
//                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                          
//                      }
//            showLoadingStatus:YES];
//    
//}
//- (void)saveLayoutKindsToDB:(NSDictionary *)dataDic callbakc:(void (^)(void))callBack{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for (NSString *key in dataDic.allKeys) {
//            if ([[dataDic objectForKey:key] isKindOfClass:[NSDictionary class]]) {
//                KindsLayoutModel *layoutModel = [[KindsLayoutModel alloc] init];
//                [layoutModel setValuesForKeysWithDictionary:[dataDic objectForKey:key]];
//                layoutModel.key = key;
//                [self.layoutArray addObject:layoutModel];
//               
//                    [self.tableViewDic setObject:layoutModel.Text forKey:layoutModel.key];
//                    if (layoutModel.datasource.length != 0) {
//                        [self.XMLParameterDic setObject:layoutModel.Value forKey:layoutModel.key];
//                    }
//                    else
//                        [self.XMLParameterDic setObject:layoutModel.Text forKey:layoutModel.key];
//                    
//                
//                if (layoutModel.datasource.length > 0) {
//                    NSString *str = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",layoutModel.datasource]];
//                    [[CoreDataManager shareManager] saveDataForTable:@"KindsLayout"
//                                                               model:[NSDictionary dictionaryWithObjectsAndKeys:layoutModel.datasource,@"datasource",@"-1",@"dataVer", nil]
//                                                                 sql:str];
//                }
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            callBack();
//        });
//    });
//    
//}
//- (void)requestEdithBillsType{
//    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac= CGEnterSspEdit&u=9&sspid=4
//    //self.uid,_editModel.SspID
//    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=CGEnterSspEdit_IOS&u=%@&sspid=%@",self.uid,_editModel.SspID]
//                   parameters:nil
//                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//                          [self.layoutArray removeAllObjects];
//                          NSDictionary *dataDic = [[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"];
//                          NSArray *imageArr = [[responseObject objectForKey:@"msg"] objectForKey:@"filepath"];
//                          [_imageArray addObjectsFromArray:[ImageModel objectArrayWithKeyValuesArray:imageArr]];
//                          self.newflag = [dataDic objectForKey:@"new"];
//                          self.newflag = self.newflag.length > 0 ? self.newflag : @"no";
//                          KindsLayoutModel *layoutModel = [[KindsLayoutModel alloc] init];
//                          layoutModel.Name = @"类别";
//                          layoutModel.key = @"cagegory_c";
//                          [self.layoutArray addObject:layoutModel];
//                          [self.tableViewDic setObject:_editModel.cname forKey:layoutModel.key];
//                          [self saveLayoutKindsToDB:dataDic callbakc:^{
//                              [self.tableview reloadData];
//                              [SVProgressHUD dismiss];
//                              
//                          }];
//                      }
//                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                          
//                      }
//            showLoadingStatus:YES];
//}
//
//- (NSString *)XMLParameter{
//    NSMutableString *xmlStr = [NSMutableString string];
//    int i = 0;
//    for (KindsLayoutModel *layoutModel in self.layoutArray) {
//        NSString *value = [self.XMLParameterDic objectForKey:layoutModel.key];
//        if (layoutModel.IsMust && value.length == 0) {
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空",layoutModel.Name]];
//            return nil;
//        }
//        if (i != 0 && value.length != 0) {
//            if (i != self.layoutArray.count - 1) {
//                [xmlStr appendFormat:@"%@=\"%@\" ",layoutModel.key,value];
//            }
//            else
//            {
//                [xmlStr appendFormat:@"%@=\"%@\"",layoutModel.key,value];
//            }
//        }
//
//    }
//    NSString *returnStr = [NSString stringWithFormat:@"<data %@></data>",xmlStr];
//    NSLog(@"xmlStr : %@",returnStr);
//    return returnStr;
//}
//
//
//- (void)kindsDataSource:(KindsLayoutModel *)model{
//    NSString *str1 = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
//    NSInteger tag= [self.layoutArray indexOfObject:model];
//    if (model.datasource.length != 0) {
//        NSString *oldDataVer = [[CoreDataManager shareManager] searchDataVer:str1];
//        if ([oldDataVer isEqualToString:model.DataVer.length >0 ? model.DataVer : @"0.01"] && oldDataVer.length >0) {
//            NSString *str = [NSString stringWithFormat:@"datasource like %@ ",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
//            [SVProgressHUD showWithStatus:nil maskType:2];
//            [self fetchItemsData:str callbakc:^(NSArray *arr) {
//                
//                if (arr.count == 0) {
//                    [[CoreDataManager shareManager] updateModelForTable:@"KindsLayout" sql:str data:[NSDictionary dictionaryWithObjectsAndKeys:model.DataVer.length >0 ? model.DataVer : @"0.01",@"dataVer", nil]];
//                    [self requestKindsDataSource:model];
//                }
//                else{
//                    [SVProgressHUD dismiss];
//                    [self initItemView:arr tag:tag];
//                }
//                
//            }];
//        }
//        else
//        {
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.DataVer.length > 0 ? model.DataVer : @"0.01",@"dataVer", nil];
//            [[CoreDataManager shareManager] updateModelForTable:@"KindsLayout" sql:str1 data:dic];
//            [self requestKindsDataSource:model];
//        }
//        
//    }
//}
//- (void)fetchItemsData:(NSString *)sql callbakc:(void (^)(NSArray *arr))callBack{
//    NSMutableArray *modelArr = [[NSMutableArray alloc] init];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSArray *arr =[NSArray arrayWithArray:[[CoreDataManager shareManager] fetchDataForTable:@"KindItem" sql:sql]];
//        for (NSManagedObject *obj in arr) {
//            KindsItemModel *model = [[KindsItemModel alloc] init];
//            model.name = [obj valueForKey:@"name"];
//            model.code = [obj valueForKey:@"code"];
//            model.datasource = [obj valueForKey:@"datasource"];
//            model.ID = [obj valueForKey:@"id"];
//            [modelArr addObject:model];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            callBack(modelArr);
//        });
//    });
//    
//    
//}
//- (void)requestKindsDataSource:(KindsLayoutModel *)model{
//    //http://localhost:53336/WebUi/ashx/mobilenew.ashx?ac=GetDataSource&u=9& datasource =400102&dataver=1.3
//    NSInteger tag= [self.layoutArray indexOfObject:model];
//    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetDataSourceNew&u=%@&datasource=%@&dataver=0",self.uid,model.datasource]
//                   parameters:nil
//                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//                          id dataArr = [responseObject objectForKey:@"msg"];
//                          if ([dataArr isKindOfClass:[NSArray class]]) {
//                              [self saveItemsToDB:dataArr callbakc:^(NSArray *modelArr) {
//                                  [self initItemView:modelArr tag:tag];
//                                  [SVProgressHUD dismiss];
//                              }];
//                          }
//                          else
//                          {
//                              [SVProgressHUD showInfoWithStatus:@"请求数据失败。"];
//                              [SVProgressHUD dismiss];
//                          }
//                          
//                      }
//                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                          
//                      }
//            showLoadingStatus:YES];
//}
//- (void)initItemView:(NSArray *)arr tag:(NSInteger)tag{
//    KindsItemsView *itemView;
//    itemView = [[[NSBundle mainBundle] loadNibNamed:@"KindsItems" owner:self options:nil] lastObject];
//    itemView.frame = CGRectMake(50, 100, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20);
//    itemView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
//    itemView.delegate = self;
//    itemView.transform =CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT / 2.0 - CGRectGetHeight(itemView.frame) / 2.0f);
//    itemView.dataArray = arr;
//    itemView.isSingl = isSinglal;
//    itemView.tag = tag;
//    [self.view addSubview:itemView];
//    [UIView animateWithDuration:1.0
//                          delay:0
//         usingSpringWithDamping:0.5
//          initialSpringVelocity:0.6
//                        options:UIViewAnimationOptionLayoutSubviews
//                     animations:^{
//                         itemView.transform = CGAffineTransformMakeTranslation(0, 0);
//                     }
//                     completion:^(BOOL finished) {
//                         
//                     }];
//}
//- (void)saveItemsToDB:(NSArray *)arr callbakc:(void (^)(NSArray *modelArr))callBack{
//    NSMutableArray *modelArr = [[NSMutableArray alloc] init];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for (NSDictionary *dic in arr) {
//            KindsItemModel *itemModel = [KindsItemModel objectWithKeyValues:dic];
//            [modelArr addObject:itemModel];
//            NSString *str = [NSString stringWithFormat:@"datasource like %@ and id like %@",[NSString stringWithFormat:@"\"%@\"",itemModel.datasource],[NSString stringWithFormat:@"\"%@\"",itemModel.ID]];
//            [[CoreDataManager shareManager] updateModelForTable:@"KindItem"
//                                                            sql:str
//                                                           data:dic];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            callBack(modelArr);
//        });
//    });
//    
//}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:textField.tag];
//    if (![self isPureInt:textField.text] && [layoutModel.SqlDataType isEqualToString:@"number"] && textField.text.length != 0) {
//        [SVProgressHUD showInfoWithStatus:@"请输入数字"];
//        textField.text = @"";
//    }
//    else
//    {
//        [self.XMLParameterDic setObject:textField.text forKey:layoutModel.key];
//        [self.tableViewDic setObject:textField.text forKey:layoutModel.key];
//    }
//    return YES;
//}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
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
