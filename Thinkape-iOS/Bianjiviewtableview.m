//
//  Bianjiviewtableview.m
//  Thinkape-iOS
//
//  Created by admin on 16/1/1.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "Bianjiviewtableview.h"
#import "BijicellTableViewCell.h"
#import "CostLayoutModel.h"
#import "LayoutModel.h"
#import "AppDelegate.h"
#import "SDPhotoBrowser.h"
#import "LinkViewController.h"
#import <QuickLook/QLPreviewController.h>
#import <QuickLook/QLPreviewItem.h>
#import "CTToastTipView.h"
#import "ImageModel.h"
#import "UIImage+SKPImage.h"
#import "CTAssetsPickerController.h"
#import "Bianjito.h"
#import "Bianjito.h"
#import "CostLayoutModel.h"
#import "LayoutModel.h"
#import "BijicellTableViewCell.h"
#import "AppDelegate.h"
#import "SubmitApproveViewController.h"
#import "DatePickerView.h"
#import "SDPhotoBrowser.h"
#import "KindsModel.h"
#import "KindsItemsView.h"
#import "KindsLayoutModel.h"
#import "KindsItemModel.h"
#import "KindsPickerView.h"
#import "DatePickerView.h"
#import "MiXimodel.h"
#import "CTToastTipView.h"
#import <QuickLook/QLPreviewItem.h>
#import <QuickLook/QLPreviewController.h>
#import "UIImage+SKPImage.h"
#import "CTAssetsPickerController.h"
#import "ImageModel.h"
#import "DataManager.h"
@interface Bianjiviewtableview ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,SDPhotoBrowserDelegate,QLPreviewControllerDataSource,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,assign)int countu;
@property(nonatomic,strong)NSMutableArray *imagedatarry;
@property(nonatomic,strong)NSMutableArray *updatearry;
@property (weak, nonatomic) IBOutlet UIButton *safetext;
@property(nonatomic,strong)NSMutableDictionary *dict1;
@property(nonatomic,strong)UITextField *textstring;
@property(nonatomic,strong)UIButton *addImage;
@property(nonatomic,strong)UITextField *textfield;
@property(nonatomic,strong)DatePickerView *datePickerView;
@property (strong, nonatomic) KindsModel *selectModel;
@property (strong, nonatomic) KindsPickerView *kindsPickerView;
@property(nonatomic,strong)NSMutableDictionary *tableviewDic;
@property(nonatomic,strong)CostLayoutModel *coster;
@end

@implementation Bianjiviewtableview
{
    NSString *delteImageIDS;
    UIView * bgView;
    CGFloat textFiledHeight;
    UIButton *sureBtn;
    UIButton *backBatn;
    UIView *infoView;
    CGFloat lastConstant;
    BOOL isSinglal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    
    self.title=@"编辑明细";
    
    self.tableview.bounces=YES;
    
    _selectModel=[[KindsModel alloc] init];
    self.imagedatarry=[NSMutableArray array];
    self.updatearry =[NSMutableArray array];
     self.tableviewDic=[NSMutableDictionary dictionary];
    self.dict1 =[[NSMutableDictionary alloc]init];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.dict1 = [NSMutableDictionary dictionaryWithDictionary:app.dict];
    self.textfield=[[UITextField alloc] initWithFrame:CGRectMake(140, 5, 170, 30)];
    self.textfield.textAlignment=NSTextAlignmentCenter;
    self.textfield.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    _coster=[self.costArray safeObjectAtIndex:_indexto];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int number=0;
    CostLayoutModel *model = [self.costArray objectAtIndex:_indexto];
    if (model.fileds.count!=0) {
        number=model.fileds.count+1;
    }
       return number;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    {
        
      
        
       MiXimodel *layoutModel = [self.coster.fileds safeObjectAtIndex:indexPath.row];
        
        
        BijicellTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"BijicellTableViewCell" owner:self options:nil] lastObject];
           
            
            //
            //             LayoutModel *layoutModel =[model.fileds safeObjectAtIndex:cell.textlabel.tag-1];
            //            cell.textlabel.text=layoutModel.name;
            
            //      cell.textlabel.text=[NSString stringWithFormat:@"%@",layoutModel.name];
            //        [cell.contentView addSubview:cell.textlabel];
            
        }
        UIView *subView = [cell.contentView viewWithTag:203];
        UIView *subView1 = [cell.contentView viewWithTag:204];
        [subView removeFromSuperview];
        [subView1 removeFromSuperview];
        //     LayoutModel *layoutModel =[model.fileds safeObjectAtIndex:indexPath.row];
        
        cell.textlabel.text=[NSString stringWithFormat:@"%@",layoutModel.name];
        
        NSArray *array =[self.costArr safeObjectAtIndex:_indexto];
        //            NSDictionary *dict =[array safeObjectAtIndex:self.indexto];
        
       
        
        cell.detailtext.text=[self.dict1 objectForKey:layoutModel.fieldname];
        
        if (layoutModel.ismust) {
            
            cell.detailtext.placeholder=@"请输入不能为空";
            
        }else
        {
            cell.detailtext.text= @"";
        }
        if ([layoutModel.sqldatatype isEqualToString:@"number"]) {
            cell.detailtext.keyboardType =UIKeyboardTypeDecimalPad ;
        }
        if ([layoutModel.fieldname isEqualToString:@"billmoney"]) {
            
            cell.detailtext.text=@"";
        }
        if ([layoutModel.fieldname isEqualToString:@"ybmoney"]) {
             cell.detailtext.text=@"";
        }
        cell.detailtext.delegate= self;
        cell.detailtext.tag=indexPath.row;
        
        
        
 
        
        if (indexPath.row==self.coster.fileds.count) {
            [cell.textlabel removeFromSuperview];
            [cell.detailtext removeFromSuperview];
           
            if (!bgView) {
                bgView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (SCREEN_WIDTH - 36) * 0.75)];
                bgView.tag = 204;
            }
            NSInteger count = _imagedatarry.count + _updatearry.count;
            CGFloat speace = 15.0f;
            CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
            int row = count / 3 + 1;
            [bgView setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (speace + imageWidth) * row)];
            [bgView removeFromSuperview];
            [self addItems:bgView];
             [cell.contentView addSubview:bgView];
            
        }
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    
    
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //    self.tableview.bounces=NO;
    //   CostLayoutModel *model =[self.costatrraylost safeObjectAtIndex:_index];
    NSLog(@"tag值：%lu",textField.tag);
    
    self.textfield.tag=textField.tag;
    
    MiXimodel *model2 =[self.coster.fileds safeObjectAtIndex:textField.tag];
    
    if (![model2.datasource isEqualToString:@"0"]) {
        
        
        isSinglal =model2.issingle;
        
        [self kindsDataSource:model2];
        
        return NO;
    }else
        if ([model2.sqldatatype isEqualToString:@"date"]){
            
            [self addDatePickerView:textField.tag date:textField.text];
            
            return NO;
        }
        else
            
            return YES;
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    MiXimodel *layoutModel = [self.coster.fileds safeObjectAtIndex:self.textfield.tag];
    
    if (![self isPureInt:textField.text] && [layoutModel.sqldatatype isEqualToString:@"number"] && textField.text.length != 0) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入数字"];
        textField.text = @"";
    }
    
    if ([textField.text length]>0) {
        unichar single = [textField.text characterAtIndex:0];
        if ((single>='0'&&single<='9')||single=='.') {
            //            if ([textField.text length]==0) {
            if (single=='.') {
                [SVProgressHUD showInfoWithStatus:@"开头不能是小数点点"];
                textField.text=@"";
                return NO;
            }
        }
    }
    
    //    [self.dict2 setObject:textField.text forKey:layoutModel.fieldname];
    [self.dict1 setValue:textField.text forKey:layoutModel.fieldname];
    return YES;
}
- (void)selectItem:(NSString *)name ID:(NSString *)ID view:(KindsItemsView *)view{
    
    NSInteger tag = view.tag;
    NSLog(@"%@=%@=%lu",name,ID,tag);
    NSLog(@"tag值%lu",self.textfield.tag);
    //   CostLayoutModel *model =[self.costatrraylost safeObjectAtIndex:_index];
    
    MiXimodel *layoutModel = [self.coster.fileds safeObjectAtIndex:self.textfield.tag];
    NSLog(@"键值：%@=%@",layoutModel.fieldname,name);
    
    [self.dict1 setValue:name forKey:layoutModel.fieldname];
    
    
    NSLog(@"字典：%@",self.dict1);
    
    
    [view closed];
    [self.tableview reloadData];
}
- (void)selectItemArray:(NSArray *)arr view:(KindsItemsView *)view{
    NSString *idStr = @"";
    NSString *nameStr = @"";
    NSInteger tag = view.tag;
    MiXimodel *layoutModel = [self.costArray safeObjectAtIndex:tag];
    int i = 0;
    for (KindsItemModel *model in arr) {
        if (i == 0) {
            idStr = [NSString stringWithFormat:@"%@",model.ID];
            nameStr = [NSString stringWithFormat:@"%@",model.name];
        }
        else{
            idStr = [NSString stringWithFormat:@"%@,%@",idStr,model.ID];
            nameStr = [NSString stringWithFormat:@"%@,%@",nameStr,model.name];
        }
        i++;
    }
    //    [self.XMLParameterDic setObject:idStr forKey:layoutModel.key];
    [self.dict1 setValue:nameStr forKey:layoutModel.fieldname];
    
    [self.tableview reloadData];
}
- (void)addDatePickerView:(NSInteger)tag date:(NSString *)date{
    if (!self.datePickerView) {
        self.datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
        [self.datePickerView setFrame:CGRectMake(0, self.view.frame.size.height - 218, self.view.frame.size.width, 218)];
    }
    
    self.datePickerView.tag = tag;
    NSLog(@"dddddddddddd%ld",(long)tag);
    
    __block Bianjiviewtableview *weaker=self;
    self.datePickerView.selectDateBack = ^(NSString *date){
        
        //    NSInteger tag = weaker.datePickerView.tag;
        //        LayoutModel *layout =[weaker.mainLayoutArray safeObjectAtIndex:tag];
        //
        //        [weaker.tableViewDic setObject:date forKey:layout.fieldname];
        //
        //        [weaker.datePickerView closeView:nil];
        //
        //        [weaker.tableview reloadData];
       
        
        MiXimodel *layout =[weaker.costArray safeObjectAtIndex:tag];
        
        //        [weaker.dict2 setObject:date forKey:layout.fieldname];
        layout.fieldname = date;
        NSLog(@"???????????????%@",layout.fieldname);
        
        
        //        layout.fieldname = date;
        //        NSLog(@"???????????????%@",layout.fieldname);
        //
        //        [weaker.costatrraylost insertObject:layout atIndex:tag];
        //
        
        
        //        [weaker.dict2 setObject:date forKey:layout.fieldname];
        [weaker.dict1 setValue:date forKey:layout.fieldname];
        
        //       [weaker.tableViewDic removeObjectForKey:layout.fieldname];
        //       [weaker.tableViewDic setObject:date forKey:layout.fieldname];
        
        //        [weakSelf.mainLayoutArray setValue:date forKey:layout.fieldname];
        //        textf.text=date;
        //        textf.text=date;
        NSLog(@"00000000000000%@",date);
        //
        
        //        [weaker.dict2 setObject:date forKey:layout.fieldname];
        
        
        
        //        NSLog(@"aaaaaaaaaaaaaaaa%@",textf.text);
        //        weaker.textfield.text=date;
        //        weaker.textfield.text=textf.text;
        
        [weaker.datePickerView closeView:nil];
        
        //        weakSelf.datestring = [NSMutableArray arrayWithObject:weakSelf.datetext];
        
    };
    [self.view addSubview:self.datePickerView];
    //    [self savetoDb];
    NSLog(@"====================%@",self.textfield.text);
    
    
}

- (void)kindsDataSource:(MiXimodel *)model{
    NSString *str1 = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
    NSInteger tag= [self.costArr indexOfObject:model];
    //包含9999，containsString
    if (model.datasource.length !=0) {
        NSString *oldDataVer = [[CoreDataManager shareManager] searchDataVer:str1];
        if ([oldDataVer isEqualToString:model.dataver>0 ?model.dataver:@"0.01"]&&oldDataVer.length>0) {
            NSString *str = [NSString stringWithFormat:@"datasource like %@ ",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
            [SVProgressHUD showWithStatus:nil maskType:2];
            
            [self fetchItemsData:str callbakc:^(NSArray *arr) {
                if (arr.count ==0) {
                    [[CoreDataManager shareManager]updateModelForTable:@"KindsLayout" sql:str data:[NSDictionary dictionaryWithObjectsAndKeys:model.dataver.length >0 ? model.dataver:@"0.01",@"dataVer", nil]];
                    [self requestKindsDataSource:model dataVer:model.dataver];
                    
                }
                else
                {
                    [SVProgressHUD dismiss];
                    [self initItemView:arr tag:tag];
                    
                }
            }];
            
            
            
        }
        else
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.dataver.length > 0 ? model.dataver : @"0.01",@"dataVer", nil];
            [[CoreDataManager shareManager] updateModelForTable:@"KindsLayout" sql:str1 data:dic];
            [self requestKindsDataSource:model dataVer:model.dataver];
            
            
        }
        
    }
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
    if (_updatearry.count != 0 || _imagedatarry.count != 0) {
        NSInteger count = _updatearry.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 36 - 4*speace) / 3.0f;
        
        for (int i = 0; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            NSString *url = [_updatearry safeObjectAtIndex:i];
            if ([self fileType:url] == 1) {
                [btn setImage:[UIImage imageNamed:@"word"] forState:UIControlStateNormal];
            }
            else{
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            }
            btn.tag = 1024+ i;
            [btn addTarget:self action:@selector(showImages:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
//            if ([self isUnCommint]) {
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
                [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
                deleteBtn.tag = 1024+ i;
                [deleteBtn addTarget:self action:@selector(deleteImages:) forControlEvents:UIControlEventTouchUpInside];
               [btn addSubview:deleteBtn];
//            }
            
        }
        count += _imagedatarry.count;
        for (int i = _updatearry.count; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            [btn setBackgroundImage:[_imagedatarry safeObjectAtIndex:i - _updatearry.count] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showSelectImage:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2024+ i;
                      [bgView addSubview:btn];
            
//            if ([self isUnCommint]) {
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
                [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
//                deleteBtn.tag = 1024+ i;
            deleteBtn.tag = 2024+ i;
                [deleteBtn addTarget:self action:@selector(deleteImages:) forControlEvents:UIControlEventTouchUpInside];
                [btn addSubview:deleteBtn];
//            }
        }
        int btnCloum = count %3;
        int btnRow = count / 3;
        view.backgroundColor = [UIColor clearColor];
        //看看都不能删掉，注意只有一行
        //       NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
//        if ([self isUnCommint]) {
            UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
            [addImage setFrame:CGRectMake(speace + (speace + imageWidth) * btnCloum, speace + (speace + imageWidth) * btnRow, imageWidth, imageWidth)];
            [addImage setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [addImage addTarget:self action:@selector(plusimage) forControlEvents:UIControlEventTouchUpInside];
                    [bgView addSubview:addImage];
//        }
    }
    else{
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 36 - 4*speace) / 3.0f;
//        if ([self isUnCommint]) {
            UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
            [addImage setFrame:CGRectMake(speace + (speace + imageWidth) * 0, speace + (speace + imageWidth) * 0, imageWidth, imageWidth)];
            [addImage setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [addImage addTarget:self action:@selector(plusimage) forControlEvents:UIControlEventTouchUpInside];
                    [bgView addSubview:addImage];
//        }
        
    }
    
    
}
- (void)requestKindsDataSource:(MiXimodel *)model dataVer:(NSString *)Dataver{
    //model.dataver
    //[RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetDataSourceNew&u=%@&datasource=%@&dataver=0",self.uid,model.datasource]
    //http://localhost:53336/WebUi/ashx/mobilenew.ashx?ac=GetDataSource&u=9& datasource =400102&dataver=1.3
    NSInteger tag= [self.costArr indexOfObject:model];
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetDataSourceNew&u=%@&datasource=%@&dataver=0",self.uid,model.datasource]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          id dataArr = [responseObject objectForKey:@"msg"];
                          if ([dataArr isKindOfClass:[NSArray class]]) {
                              [self saveItemsToDB:dataArr callbakc:^(NSArray *modelArr) {
                                  [self initItemView:modelArr tag:tag];
                                  [SVProgressHUD dismiss];
                              }];
                          }
                          else
                          {
                              [SVProgressHUD showInfoWithStatus:@"请求数据失败。"];
                              [SVProgressHUD dismiss];
                          }
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:YES];
}
- (void)saveItemsToDB:(NSArray *)arr callbakc:(void (^)(NSArray *modelArr))callBack{
    NSMutableArray *modelArr = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *dic in arr) {
            KindsItemModel *itemModel = [KindsItemModel objectWithKeyValues:dic];
            [modelArr addObject:itemModel];
            NSString *str = [NSString stringWithFormat:@"datasource like %@ and id like %@",[NSString stringWithFormat:@"\"%@\"",itemModel.datasource],[NSString stringWithFormat:@"\"%@\"",itemModel.ID]];
            [[CoreDataManager shareManager] updateModelForTable:@"KindItem"
                                                            sql:str
                                                           data:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(modelArr);
        });
    });
    
}


- (void)fetchItemsData:(NSString *)sql callbakc:(void (^)(NSArray *arr))callBack{
    NSMutableArray *modelArr = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *arr =[NSArray arrayWithArray:[[CoreDataManager shareManager] fetchDataForTable:@"KindItem" sql:sql]];
        for (NSManagedObject *obj in arr) {
            KindsItemModel *model = [[KindsItemModel alloc] init];
            model.name = [obj valueForKey:@"name"];
            model.code = [obj valueForKey:@"code"];
            model.datasource = [obj valueForKey:@"datasource"];
            model.ID = [obj valueForKey:@"id"];
            [modelArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(modelArr);
        });
    });
    
    
}
- (void)initItemView:(NSArray *)arr tag:(NSInteger)tag{
    KindsItemsView *itemView;
    itemView = [[[NSBundle mainBundle] loadNibNamed:@"KindsItems" owner:self options:nil] lastObject];
    itemView.frame = CGRectMake(50, 100, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20);
    itemView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
    itemView.delegate = self;
    itemView.isSingl=isSinglal;
    
    itemView.transform =CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT / 2.0 - CGRectGetHeight(itemView.frame) / 2.0f);
    itemView.dataArray = arr;
    //    itemView.isSingl = isSinglal;
    itemView.tag = tag;
    [self.view addSubview:itemView];
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         itemView.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (void)deleteImages:(UIButton *)btn{
    
    if (btn.tag >=1024 && btn.tag < 2024) {
//        NSString *url = [_updatearry safeObjectAtIndex:btn.tag - 1024];
//        
//        NSString *imgid = [[url componentsSeparatedByString:@"?"] lastObject];
         ImageModel *model = [_updatearry safeObjectAtIndex:btn.tag - 1024];
        
        if (delteImageIDS.length == 0) {
            delteImageIDS = [NSString stringWithFormat:@"%@",model.ID];
        }
        else{
            delteImageIDS = [NSString stringWithFormat:@"%@,%@",delteImageIDS,model.ID];
        }
        [_updatearry removeObject:model];
        
        
    }
    else{
        [_imagedatarry removeObjectAtIndex:btn.tag - 2024];
        [self.tableview reloadData];
    }
    [self.tableview reloadData];
}

//- (BOOL)isUnCommint{
//    NSDictionary *mainDataDic = [_costArr safeObjectAtIndex:0];
//    return [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"未提交"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已弃审"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已退回"];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height =0;
    if (indexPath.row !=self.coster.fileds.count) {
        return 40;
        
        
    }
    //    else
    
    //    {
    else
    {
        
        //            NSInteger count = _imagedatarry.count + _updatearry.count;
        NSInteger count = _imagedate.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 4*speace) / 3.0f;
        //            int row = count / 3 + 1;
        int row = count / 3+1;
        height= (speace + imageWidth) * row;
        NSLog(@"cell的高度%d",height);
        
        //            return (speace + imageWidth) * row;
        
        


    return height;
    
}


}

- (CGFloat )fixStr:(NSString *)str{
    CGRect frame = [str boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 115, 99999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    return  frame.size.height >=0 ? frame.size.height : 20;
}


#warning 试验用

-(void)plusimage
{
    UIActionSheet *actionsheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地拍照",@"选取本地图片" ,nil];
    [actionsheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    if (buttonIndex==1) {
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (NSString *)bate64ForImage:(UIImage *)image{
    UIImage *_originImage = image;
    NSData *_data = UIImageJPEGRepresentation(_originImage, 0.5f);
    NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return _encodedImageStr;
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"info:%@",info);
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *image = [UIImage imageWithData:[originalImage thumbImage:originalImage]];
    image = [image fixOrientation:image];
    [_imagedatarry addObject:image];
    [self.tableview reloadData];
}
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    id class = [assets lastObject];
    for (ALAsset *set in assets) {
        UIImage *image = [UIImage imageWithCGImage:[set aspectRatioThumbnail]];
        [_imagedatarry addObject:image];
    }
    [self.tableview reloadData];
    NSLog(@"class :%@",[class class]);
}
- (void)showSelectImage:(UIButton *)btn{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
    browser.sourceImagesContainerView = nil;
    
    browser.imageCount = _imagedatarry.count;
    
    browser.currentImageIndex = btn.tag - 2024 - _updatearry.count;
    
    browser.delegate = self;
    browser.tag = 11;
    [browser show]; // 展示图片浏览器
}

- (void)showImages:(UIButton *)btn{
    NSString *url = [_updatearry safeObjectAtIndex:btn.tag - 1024];
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
        
        browser.imageCount = _updatearry.count;
        
        browser.currentImageIndex = btn.tag - 1024;
        
        browser.delegate = self;
        
        [browser show]; // 展示图片浏览器
    }
}
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    // UIButton *imageView = (UIButton *)[bgView viewWithTag:index];
    if (browser.tag == 11) {
        return _imagedatarry[index];
    }
    else
        return nil;
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    if (browser.tag == 10) {
        NSLog(@"url %@",[_updatearry objectAtIndex:index]);
        NSString *model = [_updatearry objectAtIndex:index];
        return [NSURL URLWithString:model];
    }
    else
        return nil;
    
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return [NSURL fileURLWithPath:[[RequestCenter defaultCenter] filePath]];
}
- (IBAction)savetext:(id)sender {
    
    
    Bianjito *bi =[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    [self.navigationController popToViewController:bi animated:YES];
    
}
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
