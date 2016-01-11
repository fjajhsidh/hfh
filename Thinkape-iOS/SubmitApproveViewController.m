//
//  SubmitApproveViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/6/4.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

//
//  SubmitApproveViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/6/4.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "SubmitApproveViewController.h"
#import "KindsModel.h"
#import "KindsLayoutModel.h"
#import "BillsLayoutViewCell.h"
#import "KindsItemsView.h"
#import "KindsItemModel.h"
#import "YPCGViewController.h"
#import "CTAssetsPickerController.h"
#import "KindsPickerView.h"
#import "ImageModel.h"
#import "SDPhotoBrowser.h"
#import "DatePickerView.h"
#import "SDPhotoBrowser.h"
#import "UIImage+SKPImage.h"
#import <QuickLook/QLPreviewController.h>
#import <QuickLook/QLPreviewItem.h>

@interface SubmitApproveViewController () <KindsItemsViewDelegate,CTAssetsPickerControllerDelegate,SDPhotoBrowserDelegate,QLPreviewControllerDataSource>
{
    NSString *delteImageID;
    NSString *sspid;
    BOOL commintBills;
    BOOL isSingal;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) KindsModel *selectModel;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) NSMutableArray *layoutArray;
@property (strong, nonatomic) NSMutableDictionary *XMLParameterDic;
@property (strong, nonatomic) NSMutableDictionary *tableViewDic;
@property (strong, nonatomic) NSString *newflag;
@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSMutableArray *imagePaths;
@property (strong, nonatomic) KindsPickerView *kindsPickerView;
@property (strong, nonatomic) DatePickerView *datePickerView;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *commintBtn;
@property(nonatomic,assign)BOOL isHaven;

@end

@implementation SubmitApproveViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.type = 0;
        commintBills = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchArray = [[NSMutableArray alloc] init];
    _selectModel = [[KindsModel alloc] init];
    _layoutArray = [[NSMutableArray alloc] initWithCapacity:0];
    _imagePaths = [[NSMutableArray alloc] initWithCapacity:0];
    self.XMLParameterDic = [[NSMutableDictionary alloc] init];
    self.tableViewDic = [[NSMutableDictionary alloc] init];
    
    if (self.type == 0) {
        UIButton *backBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBt setImage:[UIImage imageNamed:@"right_item"] forState:UIControlStateNormal];
        [backBt setFrame:CGRectMake(80, 10, 44, 44)];
        // [backBt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
        [backBt addTarget:self action:@selector(editItem) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBt];
        self.navigationItem.rightBarButtonItem = back;
        if (!self.kindsPickerView) {
            self.kindsPickerView = [[[NSBundle mainBundle] loadNibNamed:@"KindsPickerView" owner:self options:nil] lastObject];
            [self.kindsPickerView setFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
            __block SubmitApproveViewController *weakSelf = self;
            self.kindsPickerView.selectItemCallBack = ^(KindsModel *model){
                weakSelf.selectModel = model;
                [weakSelf billDetails];
            };
            [self.view addSubview:self.kindsPickerView];
        }
        
        [self requestBillsType];
    }
    else{
        [self.commintBtn setTitle:@"提交" forState:UIControlStateNormal];
        [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        self.title = @"编辑草稿";
        [self requestEdithBillsType];
    }
    
}

/**
 *  初始化详细表单分类界面
 *
 */
- (void)initItemView:(NSArray *)arr tag:(NSInteger)tag{
    KindsItemsView *itemView;
    itemView = [[[NSBundle mainBundle] loadNibNamed:@"KindsItems" owner:self options:nil] lastObject];
    itemView.frame = CGRectMake(50, 100, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20);
    itemView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
    itemView.delegate = self;
    itemView.transform =CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT / 2.0 - CGRectGetHeight(itemView.frame) / 2.0f);
    itemView.dataArray = arr;
    itemView.isSingl = isSingal;
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

#pragma mark - KindsItemsViewDelegate

- (void)selectItem:(NSString *)name ID:(NSString *)ID view:(KindsItemsView *)view{
    NSInteger tag = view.tag;
    KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:tag];
    [self.XMLParameterDic setObject:ID forKey:layoutModel.key];
    [self.tableViewDic setObject:name forKey:layoutModel.key];
    [view closed];
    [self.tableView reloadData];
}

- (void)selectItemArray:(NSArray *)arr view:(KindsItemsView *)view{
    NSString *idStr = @"";
    NSString *nameStr = @"";
    NSInteger tag = view.tag;
    KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:tag];
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
    [self.XMLParameterDic setObject:idStr forKey:layoutModel.key];
    [self.tableViewDic setObject:nameStr forKey:layoutModel.key];
    [self.tableView reloadData];
}

#pragma mark - Request Methods

/**
 *  请求表单分类信息
 */
- (void)requestBillsType{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=GetSspBillType&u=1
    
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetSspBillType&u=%@",self.uid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          [self.dataArray removeAllObjects];
                          NSDictionary *dataDic = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          NSArray *reqArr = [KindsModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"req"]];
                          NSArray *afrArr = [KindsModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"afr"]];
                          NSArray *borrowArr = [KindsModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"borrow"]];
                          [self.dataArray addObject:reqArr];
                          [self.dataArray addObject:afrArr];
                          [self.dataArray addObject:borrowArr];
                          [SVProgressHUD dismiss];
                          self.kindsPickerView.dataArray = self.dataArray;
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }];
    
}

/**
 *  请求 表单信息
 */
- (void)billDetails{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=GetSspGridField&u=9&programid=130102&gridmainid=130102
    
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetSspGridField_IOS&u=%@&programid=%@&gridmainid=%@",self.uid,_selectModel.programid,_selectModel.gridmainid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          [self.layoutArray removeAllObjects];
                          NSDictionary *dataDic = [[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"];
                          KindsLayoutModel *layoutModel = [[KindsLayoutModel alloc] init];
                          layoutModel.Name = @"类别";
                          self.newflag = [dataDic objectForKey:@"new"];
                          self.newflag = self.newflag.length > 0 ? self.newflag : @"yes";
                          [self.layoutArray addObject:layoutModel];
                          [self saveLayoutKindsToDB:dataDic callbakc:^{
                              [self.tableView reloadData];
                              [SVProgressHUD dismiss];
                          }];
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:YES];
    
}

/**
 *  根据版本号检测是否需要重新从服务器上请求数据
 *
 */
- (void)kindsDataSource:(KindsLayoutModel *)model{
    NSString *str1 = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
    NSInteger tag= [self.layoutArray indexOfObject:model];
    if (model.datasource.length != 0) {
        NSString *oldDataVer = [[CoreDataManager shareManager] searchDataVer:str1];
        if ([oldDataVer isEqualToString:model.DataVer.length >0 ? model.DataVer : @"0.01"] && oldDataVer.length >0) {
            NSString *str = [NSString stringWithFormat:@"datasource like %@ ",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
            [SVProgressHUD showWithStatus:nil maskType:2];
            [self fetchItemsData:str callbakc:^(NSArray *arr) {
                
                if (arr.count == 0) {
                    [[CoreDataManager shareManager] updateModelForTable:@"KindsLayout" sql:str data:[NSDictionary dictionaryWithObjectsAndKeys:model.DataVer.length >0 ? model.DataVer : @"0.01",@"dataVer", nil]];
                    [self requestKindsDataSource:model];
                }
                else{
                    [SVProgressHUD dismiss];
                    [self initItemView:arr tag:tag];
                }
                
            }];
        }
        else
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.DataVer.length > 0 ? model.DataVer : @"0.01",@"dataVer", nil];
            [[CoreDataManager shareManager] updateModelForTable:@"KindsLayout" sql:str1 data:dic];
            [self requestKindsDataSource:model];
        }
        
    }
}
/**
 *  请求 详细数据分类
 *
 */
- (void)requestKindsDataSource:(KindsLayoutModel *)model{
    //http://localhost:53336/WebUi/ashx/mobilenew.ashx?ac=GetDataSource&u=9& datasource =400102&dataver=1.3
    NSInteger tag= [self.layoutArray indexOfObject:model];
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

- (void)saveBills:(NSString *)ac{
    NSString *xmlParameter = [self XMLParameter];
    if (xmlParameter.length == 0) {
        return;
    }
    NSString *gridmainid;
    NSString *programid;
    
    NSString *appStr =@"Data";
    NSString * ac1 = [NSString stringWithFormat:@"%@%@",ac,appStr];
    if (self.type == 0) {
        gridmainid = _selectModel.gridmainid;
        programid = _selectModel.programid;
    }
    else
    {
        gridmainid = _editModel.GridMainID;
        programid = _editModel.ProgramID;
    }
    NSString *str = [NSString stringWithFormat:@"%@?ac=%@&u=%@&data=%@&gridmainid=%@&programid=%@&new=%@",Web_Domain,ac1,self.uid,xmlParameter,gridmainid,programid,self.newflag];
    NSLog(@"str : %@",str);
    
    if ([self.newflag isEqualToString:@"no"]) {
        str = [NSString stringWithFormat:@"%@&sspid=%@",str,self.editModel.SspID];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *op = [manager POST:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                    parameters:nil
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           if ([[responseObject objectForKey:@"msg"] isKindOfClass:[NSDictionary class]]) {
                                               NSDictionary *dic = [responseObject objectForKey:@"msg"];
                                               NSString * ac2 = [NSString stringWithFormat:@"%@File",ac];
                                               sspid = [NSString stringWithFormat:@"%@",dic[@"sspid"]];
                                               //                  if (_imagesArray.count != 0 || delteImageID.length != 0) {
                                               //
                                               //                      [self uploadImage:dic[@"sspid"] ac:ac2 inde:0];
                                               //                  }
                                               if (_imagesArray.count != 0 || delteImageID.length != 0) {
                                                   
                                                   [self uploadImage:dic[@"sspid"] ac:ac2 inde:0];
                                               }
                                               else{
                                                   
                                                   
                                                   
                                                   if (commintBills==YES) {
                                                       if (self.type==0) {
                                                           [self saveCGToBill:sspid];
                                                           
                                                       }
                                                       
                                                   }else
                                                   {
                                                       [self.navigationController popViewControllerAnimated:YES];
                                                   }
                                                   if (self.callback) {
                                                       self.callback();
                                                   }
                                               }
                                               
                                               
                                               [SVProgressHUD showSuccessWithStatus:@"提交数据成功"];
                                           }
                                           else
                                               [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"msg"]];
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                       }];
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"totle %lld",totalBytesWritten);
    }];
    
}

- (void)uploadImage:(NSString *)theSspid ac:(NSString *)ac inde:(NSInteger)index{
    NSString *fbyte = @"";  //图片bate64
    NSString *sspID = [NSString stringWithFormat:@"%@",theSspid];
    if(_type == 1 && [self.newflag isEqualToString:@"no"]){
        sspID = self.editModel.SspID;
    }
    if (_imagesArray.count != 0) {
        fbyte = [self bate64ForImage:[_imagesArray objectAtIndex:index]];
    }
    
    NSLog(@"bate64 : %@",fbyte);
    NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
    [dictData setObject:fbyte forKey:@"FByte"];
    NSString *str = [NSString stringWithFormat:@"%@?ac=%@&u=%@&EX=%@&sspid=%@&FName=%@",Web_Domain,ac,self.uid,@".jpg",sspID,@"image"];
    if (delteImageID.length != 0) {
        str = [NSString stringWithFormat:@"%@&delpicid=%@",str,delteImageID];
    }
    NSLog(@"str : %@",str);
    [SVProgressHUD showWithMaskType:2];
    [[AFHTTPRequestOperationManager manager] POST:str
                                       parameters:fbyte.length == 0 ? nil :@{@"FByte":fbyte}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                                                  [SVProgressHUD dismiss];
                                                  if (index + 1 < _imagesArray.count) {
                                                      [self uploadImage:sspid ac:ac inde:index + 1];
                                                  }
                                                  //index + 1 == _imagesArray.count - 1
                                                  if (index + 1 == _imagesArray.count ) {
                                                      if (commintBills==YES) {
                                                          [self saveCGToBill:sspid];
                                                      }
                                                      else{
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                          if (self.callback) {
                                                              self.callback();
                                                          }
                                                      }
                                                  }
                                              }
                                          }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              
                                          }];
    
}

/**
 *  请求编辑草稿数据
 */
- (void)requestEdithBillsType{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac= CGEnterSspEdit&u=9&sspid=4
    //self.uid,_editModel.SspID
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=CGEnterSspEdit_IOS&u=%@&sspid=%@",self.uid,_editModel.SspID]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          [self.layoutArray removeAllObjects];
                          NSDictionary *dataDic = [[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"];
                          NSArray *imageArr = [[responseObject objectForKey:@"msg"] objectForKey:@"filepath"];
                          [_imagePaths addObjectsFromArray:[ImageModel objectArrayWithKeyValuesArray:imageArr]];
                          self.newflag = [dataDic objectForKey:@"new"];
                          self.newflag = self.newflag.length > 0 ? self.newflag : @"no";
                          KindsLayoutModel *layoutModel = [[KindsLayoutModel alloc] init];
                          layoutModel.Name = @"类别";
                          layoutModel.key = @"cagegory_c";
                          [self.layoutArray addObject:layoutModel];
                          [self.tableViewDic setObject:_editModel.cname forKey:layoutModel.key];
                          [self saveLayoutKindsToDB:dataDic callbakc:^{
                              [self.tableView reloadData];
                              [SVProgressHUD dismiss];
                              
                          }];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:YES];
}

// 编辑时  草稿 存为单据
- (void)saveCGToBill:(NSString *)AG{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac= SspCGToBills &u=9& sspid =3,4,5,6,7
    NSString *billsspid = commintBills ? sspid : _editModel.SspID;
    NSString *url = [NSString stringWithFormat:@"ac=SspCGToBills&u=%@&sspid=%@",self.uid,billsspid];
    [RequestCenter GetRequest:url
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          NSString *msg = [responseObject objectForKey:@"msg"];
                          if ([msg isEqualToString:@"ok"]) {
                              [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                              [self.navigationController popViewControllerAnimated:YES];
                              if (self.callback) {
                                  self.callback();
                              }
                          }
                          else
                              [SVProgressHUD showInfoWithStatus:@"提交失败，请稍后尝试"];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:YES];
}

#pragma mark - SQL DB Action

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

- (void)saveLayoutKindsToDB:(NSDictionary *)dataDic callbakc:(void (^)(void))callBack{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *key in dataDic.allKeys) {
            if ([[dataDic objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                KindsLayoutModel *layoutModel = [[KindsLayoutModel alloc] init];
                [layoutModel setValuesForKeysWithDictionary:[dataDic objectForKey:key]];
                layoutModel.key = key;
                [self.layoutArray addObject:layoutModel];
                if (self.type == 1) {
                    [self.tableViewDic setObject:layoutModel.Text forKey:layoutModel.key];
                    if (layoutModel.datasource.length != 0) {
                        [self.XMLParameterDic setObject:layoutModel.Value forKey:layoutModel.key];
                    }
                    else
                        [self.XMLParameterDic setObject:layoutModel.Text forKey:layoutModel.key];
                    
                }
                
                
                if (layoutModel.datasource.length > 0) {
                    NSString *str = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",layoutModel.datasource]];
                    [[CoreDataManager shareManager] saveDataForTable:@"KindsLayout"
                                                               model:[NSDictionary dictionaryWithObjectsAndKeys:layoutModel.datasource,@"datasource",@"-1",@"dataVer", nil]
                                                                 sql:str];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack();
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

#pragma mark - BtnAction

- (void)editItem{
    YPCGViewController *ypVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YPCGVC"];
    [self.navigationController pushViewController:ypVC animated:YES];
}

/**
 *  存为草稿
 *
 */
- (IBAction)saveToDraft:(UIButton *)sender {
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=savecg&u=9&data=<data gridmainid="130602" programid="130602" uid="9" deptid="3" memo="这只是1个测试" billmoney="500" ></data>&gridmainid=130102&programid=130102& EX=.jpg{$}&new=yes
    if(_type == 0)
    {
        self.newflag = @"yes";
    }
    else
    {
        self.newflag = @"no";
    }
    commintBills = NO;
    [self saveBills:@"SaveCG"];
    
}

/**
 *  递交申请
 *
 */
- (IBAction)commitApprove:(UIButton *)sender {
    if (self.type == 0) {
        commintBills = YES;
        [self saveBills:@"SaveCG"];
    }
    else
    {
        [self saveCGToBill:sspid];
    }
}

- (void)showPickImageVC{
    if (!_imagesArray) {
        _imagesArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"本地相册", nil];
    [sheet showInView:self.view];
    
    
}

//- (BOOL)isPureInt:(NSString*)string{
//  //  [NSScanner scannerWithString:string];
//    NSScanner* scan = [NSScanner scannerWithString:string];
//    float val;
//    return[scan scanFloat:&val] && [scan isAtEnd];
//}
- (BOOL)isPureInt:(NSString*)string{
    //  [NSScanner scannerWithString:string];
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"info:%@",info);
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *image = [UIImage imageWithData:[originalImage thumbImage:originalImage]];
    image = [image fixOrientation:image];
    [_imagesArray addObject:image];
    [self.tableView reloadData];
}


#pragma mark - CTAssetsPickerControllerDelegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    id class = [assets lastObject];
    for (ALAsset *set in assets) {
        UIImage *image = [UIImage imageWithCGImage:[set thumbnail]];
        [_imagesArray addObject:image];
    }
    [self.tableView reloadData];
    NSLog(@"class :%@",[class class]);
}

#pragma mark - CustomMethods

- (void)showSelectImage:(UIButton *)btn{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
    browser.sourceImagesContainerView = nil;
    
    browser.imageCount = _imagesArray.count;
    
    browser.currentImageIndex = btn.tag - 2024 - _imagePaths.count;
    
    browser.delegate = self;
    browser.tag = 11;
    [browser show]; // 展示图片浏览器
}

- (void)showImage:(UIButton *)btn{
    ImageModel *url = [_imagePaths safeObjectAtIndex:btn.tag - 1024];
    if ([self fileType:url.FilePath] == 1) {
        [[RequestCenter defaultCenter] downloadOfficeFile:url.FilePath
                                                  success:^(NSString *filename) {
                                                      QLPreviewController *previewVC = [[QLPreviewController alloc] init];
                                                      previewVC.dataSource = self;
                                                      [self presentViewController:previewVC animated:YES completion:^{
                                                          
                                                      }];
                                                  }
                                                  fauiler:^(NSError *error) {
                                                      
                                                  }];
    }
    else{
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.tag = 10;
        browser.sourceImagesContainerView = nil;
        
        browser.imageCount = _imagePaths.count;
        
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

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    // UIButton *imageView = (UIButton *)[bgView viewWithTag:index];
    if (browser.tag == 11) {
        return _imagesArray[index];
    }
    else
        return nil;
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    if (browser.tag == 10) {
        NSLog(@"url %@",[_imagePaths objectAtIndex:index]);
        ImageModel *model = [_imagePaths objectAtIndex:index];
        return [NSURL URLWithString:model.FilePath];
    }
    else
        return nil;
    
}

- (void)addDatePickerView:(NSInteger)tag date:(NSString *)date{
    if (!self.datePickerView) {
        self.datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
        [self.datePickerView setFrame:CGRectMake(0, self.view.frame.size.height - 218, self.view.frame.size.width, 218)];
    }
    __block SubmitApproveViewController *weakSelf = self;
    self.datePickerView.tag = tag;
    
    if (date.length != 0) {
        self.datePickerView.date = date;
    }
    
    self.datePickerView.selectDateCallBack = ^(NSString *date){
        NSInteger tag = weakSelf.datePickerView.tag;
        KindsLayoutModel *layoutModel = [weakSelf.layoutArray safeObjectAtIndex:tag];
        [weakSelf.XMLParameterDic setObject:date forKey:layoutModel.key];
        [weakSelf.tableViewDic setObject:date forKey:layoutModel.key];
        [weakSelf.datePickerView closeView:nil];
        [weakSelf.tableView reloadData];
    };
    [self.view addSubview:self.datePickerView];
}

//    UIImage图片转成base64字符串
- (NSString *)bate64ForImage:(UIImage *)image{
    UIImage *_originImage = image;
    NSData *_data = UIImageJPEGRepresentation(_originImage, 0.5f);
    NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return _encodedImageStr;
}


- (NSString *)XMLParameter{
    NSMutableString *xmlStr = [NSMutableString string];
    int i = 0;
    for (KindsLayoutModel *layoutModel in self.layoutArray) {
        // NSString *value = [self.XMLParameterDic objectForKey:layoutModel.key];
        //
        NSString *value = [self.XMLParameterDic objectForKey:layoutModel.key];
        
        if (layoutModel.IsMust && value.length == 0&&i !=0&&[layoutModel.key isEqualToString:@"ybmoney"]) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空",layoutModel.Name]];
            return nil;
        }
        if (i != 0 && value.length != 0) {
            if (i != self.layoutArray.count - 1) {
                [xmlStr appendFormat:@"%@=\"%@\" ",layoutModel.key,value];
            }
            else
            {
                [xmlStr appendFormat:@"%@=\"%@\"",layoutModel.key,value];
            }
        }
        //        else if (i != 0){
        //            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@不能为空",layoutModel.Name]];
        //            return nil;
        //        }
        i++;
    }
    NSString *returnStr = [NSString stringWithFormat:@"<data %@></data>",xmlStr];
    NSLog(@"xmlStr : %@",returnStr);
    return returnStr;
}

#pragma mark - TextFieldDelegate



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:textField.tag];
    if (layoutModel.datasource.length > 0) {
        isSingal = layoutModel.IsSingle;
        [self kindsDataSource:layoutModel];
        return NO;
    }
    else if ([layoutModel.SqlDataType isEqualToString:@"date"]){
        [self addDatePickerView:textField.tag date:textField.text];
        return NO;
    }
    else
        return YES;
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//        KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:textField.tag];
//            if (![self isPureInt:textField.text] && [layoutModel.SqlDataType isEqualToString:@"number"] && textField.text.length != 0) {
//                [SVProgressHUD showInfoWithStatus:@"请输入数字"];
//                textField.text = @"";
//
//
//               if ([textField.text length]>0) {
//                            unichar single = [textField.text characterAtIndex:0];
//                           if ((single>='0'&&single<='9')||single=='.') {
//                               //数据格式正确
//                                //首字母不能为0和小数点
//                                if ([textField.text length]==0) {
//                                   if (single=='.') {
//                                       [SVProgressHUD showInfoWithStatus:@"第一个数字不能为小数点" ];
//                                      textField.text=@"";
//                                       return NO;
//
//                                   }
//
//                                    if (single=='0') {
//                                       [SVProgressHUD showInfoWithStatus:@"第一个数字不能为0"];
//                                       textField.text=@"";
//                                        return NO;
//                                   }
//
//                              }
//
//
//
//
////           if ([textField.text length]>0) {
////    unichar single = [textField.text characterAtIndex:0];
////    if ((single>='0'&&single<='9')||single=='.') {
////        //数据格式正确
////        //首字母不能为0和小数点
////        if ([textField.text length]==0) {
////            if (single=='.') {
////                [SVProgressHUD showInfoWithStatus:@"第一个数字不能为小数点" ];
////                textField.text=@"";
////                return NO;
////
////            }
////
////            if (single=='0') {
////                [SVProgressHUD showInfoWithStatus:@"第一个数字不能为0"];
////                textField.text=@"";
////                return NO;
////            }
////
////        }
////
////    }
////
////        else
////        {
////            [self.XMLParameterDic setObject:textField.text forKey:layoutModel.key];
////                  [self.tableViewDic setObject:textField.text forKey:layoutModel.key];
////        }
////        return YES;
////    }

//    -(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//    {
//        KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:textField.tag];
//            if (![self isPureInt:textField.text] && [layoutModel.SqlDataType isEqualToString:@"number"] && textField.text.length != 0) {
//                [SVProgressHUD showInfoWithStatus:@"请输入数字"];
//                textField.text = @"";
//
//
//
//
//            }
//
//    //    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
//    //
//    //
//    //    }
//        if ([textField.text length]>0) {
//            unichar single =[textField.text characterAtIndex:0];
//            if ((single>='0'&&single<='9')||single=='.') {
//                if ([textField.text length]==0) {
//                    if (single=='.') {
//                        [SVProgressHUD showInfoWithStatus:@"开头不能为小数点"];
//                        textField.text=@"";
//                        return NO;
//                    }
//    //                if (single=='0') {
//    //                    [SVProgressHUD showInfoWithStatus:@"开头不能为0"];
//    //                    textField.text=@"";
//    //                    return NO;
//    //                }
//
//                }
//            }
//        }
//
//
//                [self.XMLParameterDic setObject:textField.text forKey:layoutModel.key];
//                [self.tableViewDic setObject:textField.text forKey:layoutModel.key];
//
//            return YES;
//}
//

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:textField.tag];
    if (![self isPureInt:textField.text] && [layoutModel.SqlDataType isEqualToString:@"number"] &&[textField.text rangeOfString:@"."].location&&![textField.text isEqualToString:@""]==NSNotFound) {
        [SVProgressHUD showInfoWithStatus:@"请输入数字"];
        textField.text = @"";
        _isHaven=NO;
    }
    
    if ([textField.text length]>0) {
        unichar single = [textField.text characterAtIndex:0];
        if ((single>='0'&&single<='9')||single=='.') {
            //            if ([textField.text length]==0) {
            if (single=='.') {
                [SVProgressHUD showInfoWithStatus:@"第一个字不能为点"];
                textField.text=@"";
                return NO;
            }
            
            //            }
        }
    }
    
    
    
    
    [self.XMLParameterDic setObject:textField.text forKey:layoutModel.key];
    [self.tableViewDic setObject:textField.text forKey:layoutModel.key];
    
    
    return YES;
}
#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.layoutArray.count ==0) {
        return 0;
    }
    else
        return self.layoutArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row != self.layoutArray.count) {
        KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:indexPath.row];
        NSString *cellID = @"cell";
        BillsLayoutViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.category.text = [NSString stringWithFormat:@"%@:",layoutModel.Name];
        cell.contentText.tag = indexPath.row;
        NSString *value = [self.tableViewDic objectForKey:layoutModel.key];
        value = value.length >0 ? value :@"";
        NSLog(@"值%@",value);
        cell.contentText.text = value;
        cell.contentText.enabled = YES;
        if (indexPath.row == 0 &&self.type == 0) {
            cell.contentText.text = _selectModel.cname;
            cell.contentText.enabled = NO;
        }
        else if (indexPath.row == 0 && self.type == 1){
            cell.contentText.enabled = NO;
        }
        else{
            if (layoutModel.IsMust) {
                cell.contentText.placeholder = @"请输入，不能为空";
            }
            if ([layoutModel.SqlDataType isEqualToString:@"number"]) {
                cell.contentText.keyboardType =UIKeyboardTypeDecimalPad ;
            }
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        NSInteger count = _imagePaths.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 4*speace) / 3.0f;
        
        for (int i = 0; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            ImageModel *model = [_imagePaths safeObjectAtIndex:i];
            if ([self fileType:model.FilePath] == 1) {
                [btn setImage:[UIImage imageNamed:@"word"] forState:UIControlStateNormal];
            }
            else{
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.FilePath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ab_nav_bg"]];
            }
            btn.tag = 1024+ i;
            [btn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
            [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
            deleteBtn.tag = 1024+ i;
            [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:deleteBtn];
        }
        count += _imagesArray.count;
        for (int i = _imagePaths.count; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            [btn setBackgroundImage:[_imagesArray safeObjectAtIndex:i - _imagePaths.count] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showSelectImage:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2024+ i;
            [cell.contentView addSubview:btn];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
            [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
            deleteBtn.tag = 2024+ i;
            [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:deleteBtn];
            
        }
        int btnCloum = count %3;
        int btnRow = count / 3;
        cell.backgroundColor = [UIColor clearColor];
        UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [addImage setFrame:CGRectMake(speace + (speace + imageWidth) * btnCloum, speace + (speace + imageWidth) * btnRow, imageWidth, imageWidth)];
        [addImage setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        [addImage addTarget:self action:@selector(showPickImageVC) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addImage];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != self.layoutArray.count) {
        return 40;
    }
    else{
        NSInteger count = _imagesArray.count + _imagePaths.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 4*speace) / 3.0f;
        int row = count / 3 + 1;
        return (speace + imageWidth) * row;
    }
    
}

- (void)deleteImage:(UIButton *)btn{
    
    if (btn.tag >=1024 && btn.tag < 2024) {
        ImageModel *model = [_imagePaths safeObjectAtIndex:btn.tag - 1024];
        if (delteImageID.length == 0) {
            delteImageID = [NSString stringWithFormat:@"%@",model.ID];
        }
        else{
            delteImageID = [NSString stringWithFormat:@"%@,%@",delteImageID,model.ID];
        }
        [_imagePaths removeObject:model];
    }
    else{
        [_imagesArray removeObjectAtIndex:btn.tag - 2024];
        [self.tableView reloadData];
    }
    [self.tableView reloadData];
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



