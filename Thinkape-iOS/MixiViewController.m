//
//  MixiViewController.m
//  Thinkape-iOS
//
//  Created by admin on 16/1/5.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "MixiViewController.h"
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
@interface MixiViewController ()<UITextFieldDelegate,KindsItemsViewDelegate,UINavigationControllerDelegate,SDPhotoBrowserDelegate,UIActionSheetDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;


//试验用

@property (strong, nonatomic) KindsModel *selectModel;
@property (strong, nonatomic) KindsPickerView *kindsPickerView;
@property(nonatomic,strong)UITextField *textfield;

@property(nonatomic,strong)DatePickerView *datePickerView;
@property(nonatomic,strong)NSMutableDictionary *tableviewDic;
@property(nonatomic,strong)CostLayoutModel *coster;
@property(nonatomic,strong)NSMutableArray *Tositoma;
@property(nonatomic,strong)NSMutableArray *updateImage;
@property(nonatomic,strong)NSMutableArray *imageupdate;
@property(nonatomic,strong)NSMutableDictionary *dicz;
@property(nonatomic,strong)NSMutableDictionary *datemeory;
@property(nonatomic,strong)NSMutableDictionary *add;
@property(nonatomic,strong)NSMutableDictionary *editor;
@property(nonatomic,assign)BOOL issee;
@end

@implementation MixiViewController
{
    NSString *delteImageIDS;
    UIView *bgView;
    CGFloat textFiledHeight;
    UIButton *sureBtn;
    UIButton *backBatn;
    UIView *infoView;
    BOOL isSinglal;
   
}
-(NSMutableDictionary *)datemeory
{
    if (!_datemeory) {
        _datemeory =[NSMutableDictionary dictionary];
    }
    return _datemeory;
}
-(NSMutableDictionary *)dicz
{
    if (!_dicz) {
        _dicz=[NSMutableDictionary dictionary];
    }
    return _dicz;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)] ]
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
   
    self.textfield=[[UITextField alloc] initWithFrame:CGRectMake(140, 5, 170, 30)];
     self.textfield.textAlignment=NSTextAlignmentCenter;
     self.textfield.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
     _selectModel=[[KindsModel alloc] init];
    self.tableviewDic=[NSMutableDictionary dictionary];
    _imageupdate=[NSMutableArray array];
    _updateImage=[NSMutableArray array];
    
//    self.tableviewDic = [NSMutableDictionary dictionaryWithDictionary:_costatrraylost];
    _coster=[self.costatrraylost safeObjectAtIndex:_index];
    
    self.Tositoma =_coster.fileds;
    
   
//
//    self.bottomtrance.constant=;
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(10, SCREEN_HEIGHT-60, SCREEN_WIDTH-20, 40)];
    
    
    [btn setTitle:@"保 存" forState:UIControlStateNormal];
    //设置边框为圆角
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:10];
    
    [btn setBackgroundColor:[UIColor colorWithRed:0.70 green:0.189 blue:0.213 alpha:1.000]];
    [btn addTarget:self action:@selector(savetolist) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    [self.view addSubview:btn];
    
//    self.dict2= appe.dict;
    AppDelegate *appe = [UIApplication sharedApplication].delegate;
      self.dict2 = [NSMutableDictionary dictionaryWithDictionary:appe.dict];
    
   

    
//    [self selectType];
    
}
-(NSString *)filePath{
    NSString *documentsPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath =[documentsPath stringByAppendingPathComponent:@"Leo.txt"];
    NSLog(@"文件夹位置%@",filePath);
    return filePath;
}
-(NSString *)filePaths{
    NSString *documentsPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath =[documentsPath stringByAppendingPathComponent:@"xing.txt"];
    NSLog(@"文件夹位置%@",filePath);
    return filePath;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // CostLayoutModel *model = [self.costatrraylost safeObjectAtIndex:_index];
    
    //    LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:indexPath.row];
    //
    NSInteger height =0;
    if (indexPath.row != self.coster.fileds.count) {
        return 40;
        
        
    }
  
    else
  
    {
     
          //            NSInteger count = _imagedatarry.count + _updatearry.count;
          NSInteger count = _imageupdate.count;
          CGFloat speace = 15.0f;
          CGFloat imageWidth = (SCREEN_WIDTH - 4*speace) / 3.0f;
          //            int row = count / 3 + 1;
          int row = count / 3+1;
          height= (speace + imageWidth) * row;
          NSLog(@"cell的高度%d",height);
          
          //            return (speace + imageWidth) * row;


  }
    
    
    
//    if (indexPath.row!=model.fileds.count+1) {
//        //            NSInteger count = _imagedatarry.count + _updatearry.count;
//        NSInteger count = _imageupdate.count;
//        CGFloat speace = 15.0f;
//        CGFloat imageWidth = (SCREEN_WIDTH - 4*speace) / 3.0f;
//        //            int row = count / 3 + 1;
//        int row = count / 3+1;
//        height= (speace + imageWidth) * row;
//        NSLog(@"cell的高度%d",height);
//        
//        //            return (speace + imageWidth) * row;
//    }
    
    //    }
    return height;
    
}




-(void)requestminxi
{
    
}
#pragma mark-提交
-(void)savetolist
{
   
    Bianjito *bi =[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
//     [ _costarrdate replaceObjectAtIndex:0 withObject:self.dict2];
    
    if (bi.index==0) {
         bi.editstart = YES;
         bi.editnew=self.dict2;
    }else
    {
       bi.isstrart = YES;
        bi.editxiao=self.dict2;
    }
    
    [self.navigationController popToViewController:bi animated:YES];
    
    NSLog(@"=======%@",self.dict2);
    
    
//    [self.navigationController pushViewController:bianji animated:YES ];
    
}

#pragma mark-UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   
    int number=0;
    CostLayoutModel *model = [self.costatrraylost objectAtIndex:_index];
    if (model.fileds.count!=0) {
        number=model.fileds.count+1;
    }
    return number;
    
    NSLog(@"返回的是哪个")
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

//    self.tableviewDic = [self.costarrdate safeObjectAtIndex:0];
//    
   // CostLayoutModel *model = [self.costatrraylost safeObjectAtIndex:_index];
    
    MiXimodel *layoutModel =[self.Tositoma
                            safeObjectAtIndex:indexPath.row];
    
    //    _layoutModel =[self.Tositoma
//                            safeObjectAtIndex:indexPath.row];
    
    BijicellTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"BijicellTableViewCell" owner:self options:nil] lastObject];
    }
   
    
   
    cell.textlabel.text=[NSString stringWithFormat:@"%@",layoutModel.name];
    
    
//    cell.detailtext.text =[self.dict2 objectForKey:layoutModel.fieldname];
//    if ([self.selectAcceptType isEqualToString:@"add"]) {
//        
//       
//             cell.detailtext.text= [self.add objectForKey:layoutModel.fieldname];
//             
//       
//        if (layoutModel.ismust) {
//            
//            cell.detailtext.placeholder=@"请输入不能为空";
//            
//        }else
//        {
//            cell.detailtext.text= @"";
//        }
//        if ([layoutModel.fieldname isEqualToString:@"billmoney"]) {
//            cell.detailtext.text = @"";
//        }
//        if ([layoutModel.fieldname isEqualToString:@"ybmoney"]) {
//            cell.detailtext.text=@"";
//        
//        }
//        
//        [_dicz setObject:cell.detailtext.text forKey:layoutModel.fieldname];
    
//    }else
//    if ([self.selectAcceptType isEqualToString:@"editor"]){
   
    cell.detailtext.text= [self.dict2 objectForKey:layoutModel.fieldname];
    
    if ([layoutModel.sqldatatype isEqualToString:@"number"]) {
        cell.detailtext.keyboardType =UIKeyboardTypeDecimalPad ;
    }
   
//    NSString *value = [self.tableViewDic objectForKey:layoutModel.key];
//    value = value.length >0 ? value :@"";
//    self.dict2 =[NSMutableDictionary dictionary];
//    AppDelegate *acer =
//    
//    self.dict2=acer.dict;
   
//    layoutModel.fieldname=@"";
    
//    [self.dict2 removeObjectForKey:layoutModel.fieldname];
//    cell.detailtext.frame= CGRectMake((SCREEN_WIDTH-150)/2,0,300,40);
 
 
    
    
//    [self.tableviewDic setObject:cell.detailtext.text forKey:layoutModel.fieldname];
    

    
//    if ([layoutModel.fieldname isEqualToString:@"itemid_show"]||[layoutModel.fieldname isEqualToString:@"costtypeid_show"]||[layoutModel.fieldname isEqualToString:@"memo"]) {
//        cell.detailtext.placeholder=@"";
//       
//        
//    }else
//    {
//        cell.detailtext.placeholder=@"不能为空";
//        
//    }
//
    cell.detailtext.delegate=self;
    cell.detailtext.tag=indexPath.row;
    
//    if (cell.textlabel.text==nil) {
//        cell.selectionStyle=UITableViewRowActionStyleNormal;
//        
//    }
    
    if (indexPath.row==self.coster.fileds.count) {
        [cell.textlabel removeFromSuperview];
        [cell.detailtext removeFromSuperview];
   
        if (!bgView) {
            bgView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (SCREEN_WIDTH - 36) * 0.75)];
            bgView.tag = 204;
        }
        NSInteger count = _imageupdate.count + _updateImage.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
        int row = count / 3 + 1;
        [bgView setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (speace + imageWidth) * row)];
       [bgView removeFromSuperview];
        [self addItems:bgView];
          [cell.contentView addSubview:bgView];
      
        
    }
  
    cell.selectionStyle=UITableViewCellAccessoryNone;

    return cell;
    
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
    if (_updateImage.count != 0 || _imageupdate.count != 0) {
        NSInteger count = _updateImage.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 36 - 4*speace) / 3.0f;
        
        for (int i = 0; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            NSString *url = [_updateImage safeObjectAtIndex:i];
            if ([self fileType:url] == 1) {
                [btn setImage:[UIImage imageNamed:@"word"] forState:UIControlStateNormal];
            }
            else{
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            }
            btn.tag = 1024+ i;
            [btn addTarget:self action:@selector(showImagess:) forControlEvents:UIControlEventTouchUpInside];
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
        count += _imageupdate.count;
        for (int i = _updateImage.count; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            [btn setBackgroundImage:[_imageupdate safeObjectAtIndex:i - _updateImage.count] forState:UIControlStateNormal];
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
        [addImage addTarget:self action:@selector(plusimages) forControlEvents:UIControlEventTouchUpInside];
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
        [addImage addTarget:self action:@selector(plusimages) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:addImage];
        //        }
        
    }
    
    
}
- (void)deleteImages:(UIButton *)btn{
    
    if (btn.tag >=1024 && btn.tag < 2024) {
        //        NSString *url = [_updatearry safeObjectAtIndex:btn.tag - 1024];
        //
        //        NSString *imgid = [[url componentsSeparatedByString:@"?"] lastObject];
        ImageModel *model = [_updateImage safeObjectAtIndex:btn.tag - 1024];
        
        if (delteImageIDS.length == 0) {
            delteImageIDS = [NSString stringWithFormat:@"%@",model.ID];
        }
        else{
            delteImageIDS = [NSString stringWithFormat:@"%@,%@",delteImageIDS,model.ID];
        }
        [_updateImage removeObject:model];
        
        
    }
    else{
        [_imageupdate removeObjectAtIndex:btn.tag - 2024];
        [self.tableview reloadData];
    }
    [self.tableview reloadData];
}

-(void)saveto
{
   
    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults
//                            ];
//    
//    
//    [user setObject:self.dict2  forKey:@"fale"];
//    
//    [user synchronize];
  
        NSDictionary *dic =@{@"sda":self.dict2};
        [dic writeToFile:[self filePath] atomically:YES];
   
 
    
}
-(void)toerror
{
    NSDictionary *dic =@{@"xingbian":self.add};
    [dic writeToFile:[self filePaths] atomically:YES];
    
}
-(void)readto
{
//    NSIndexPath *indexPath =[self.tableview indexPathForSelectedRow];
//    
//    MiXimodel *layoutModel =[self.coster.fileds
//                             safeObjectAtIndex:indexPath.row];
    
    
//    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
//   self.dict2  =[user objectForKey:@"fale"];
    NSMutableDictionary *dic =[NSMutableDictionary  dictionaryWithContentsOfFile:[self filePath]];
    self.dict2 = [dic objectForKey:@"sda"];
   
    
}
-(void)readnew
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithContentsOfFile:[self filePaths]];
    self.add = [dic objectForKey:@"xingbian"];
    
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
-(void)plusimages
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"info:%@",info);
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *image = [UIImage imageWithData:[originalImage thumbImage:originalImage]];
    image = [image fixOrientation:image];
    [_imageupdate addObject:image];
    [self.tableview reloadData];
}
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    id class = [assets lastObject];
    for (ALAsset *set in assets) {
        UIImage *image = [UIImage imageWithCGImage:[set thumbnail]];
        [_imageupdate addObject:image];
    }
    [self.tableview reloadData];
    NSLog(@"class :%@",[class class]);
}
- (void)showSelectImage:(UIButton *)btn{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
    browser.sourceImagesContainerView = nil;
    
    browser.imageCount = _imageupdate.count;
    
    browser.currentImageIndex = btn.tag - 2024 - _updateImage.count;
    
    browser.delegate = self;
    browser.tag = 11;
    [browser show]; // 展示图片浏览器
}

- (void)showImagess:(UIButton *)btn{
    NSString *url = [_updateImage safeObjectAtIndex:btn.tag - 1024];
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
        
        browser.imageCount = _updateImage.count;
        
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
        return _imageupdate[index];
    }
    else
        return nil;
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    if (browser.tag == 10) {
        NSLog(@"url %@",[_updateImage objectAtIndex:index]);
        NSString *model = [_updateImage objectAtIndex:index];
        return [NSURL URLWithString:model];
    }
    else
        return nil;
    
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return [NSURL fileURLWithPath:[[RequestCenter defaultCenter] filePath]];
}


#pragma mark-KindsItemsViewDelegate

- (void)selectItem:(NSString *)name ID:(NSString *)ID view:(KindsItemsView *)view{
    
      NSInteger tag = view.tag;
    NSLog(@"%@=%@=%lu",name,ID,tag);
    NSLog(@"tag值%lu",self.textfield.tag);
 //   CostLayoutModel *model =[self.costatrraylost safeObjectAtIndex:_index];
    
    MiXimodel *layoutModel = [self.coster.fileds safeObjectAtIndex:self.textfield.tag];
    NSLog(@"键值：%@=%@",layoutModel.fieldname,name);
    
   [self.dict2 setValue:name forKey:layoutModel.fieldname];
   
    
    NSLog(@"字典：%@",self.dict2);
    
    
    
    [view closed];
    [self.tableview reloadData];
}
//- (void)selectItemArray:(NSArray *)arr view:(KindsItemsView *)view{
//    NSString *idStr = @"";
//    NSString *nameStr = @"";
//    NSInteger tag = view.tag;
//    MiXimodel *layoutModel = [self.costatrraylost safeObjectAtIndex:tag];
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
//    //    [self.XMLParameterDic setObject:idStr forKey:layoutModel.key];
//    //    [self.tableViewDic setObject:nameStr forKey:layoutModel.key];
//    [self.tableview reloadData];
//}
//



#pragma mark-UItextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    self.tableview.bounces=NO;
  //   CostLayoutModel *model =[self.costatrraylost safeObjectAtIndex:_index];
    NSLog(@"tag值：%lu",textField.tag);
    
    self.textfield.tag=textField.tag;
   MiXimodel *model2 =[self.coster.fileds safeObjectAtIndex:textField.tag];

    if (![model2.datasource isEqualToString:@"0"]&&![model2.sqldatatype isEqualToString:@"date"]) {
        
        
        isSinglal =model2.issingle;

        [self kindsDataSource:model2];
         [self.dict2 setObject:textField.text forKey:model2.fieldname];
        return NO;
    }else
        if ([model2.sqldatatype isEqualToString:@"date"]){
            
            [self addDatePickerView:textField.tag date:textField.text];
            [self.dict2 setObject:textField.text forKey:model2.fieldname];
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
    [self.dict2 setValue:textField.text forKey:layoutModel.fieldname];
    return YES;
}
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
- (void)addDatePickerView:(NSInteger)tag date:(NSString *)date{
    if (!self.datePickerView) {
        self.datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
        [self.datePickerView setFrame:CGRectMake(0, self.view.frame.size.height - 218, self.view.frame.size.width, 218)];
    }
    
   
    
    __block MixiViewController *weaker=self;
    self.datePickerView.selectDateBack = ^(NSString *date){
        
    //    NSInteger tag = weaker.datePickerView.tag;
//        LayoutModel *layout =[weaker.mainLayoutArray safeObjectAtIndex:tag];
//        
//        [weaker.tableViewDic setObject:date forKey:layout.fieldname];
//        
//        [weaker.datePickerView closeView:nil];
//        
//        [weaker.tableview reloadData];
        NSLog(@"数组%@",weaker.costatrraylost);
        
        MiXimodel *layout =[weaker.costatrraylost safeObjectAtIndex:tag];
        
       [weaker.dict2 setObject:date forKey:layout.fieldname];
        
        
        [weaker.datePickerView closeView:nil];
        
           };
    [self.tableview reloadData];
    [self.view addSubview:self.datePickerView];
    
//    [self savetoDb];
    NSLog(@"====================%@",self.textfield.text);
    
    
}
- (void)kindsDataSource:(MiXimodel *)model{
    NSString *str1 = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
    NSInteger tag= [self.costatrraylost indexOfObject:model];
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
- (void)requestKindsDataSource:(MiXimodel *)model dataVer:(NSString *)Dataver{
    //model.dataver
    //[RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetDataSourceNew&u=%@&datasource=%@&dataver=0",self.uid,model.datasource]
    //http://localhost:53336/WebUi/ashx/mobilenew.ashx?ac=GetDataSource&u=9& datasource =400102&dataver=1.3
    NSInteger tag= [self.costatrraylost indexOfObject:model];
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


- (NSString *)uid{
    return [DataManager shareManager].uid;
}

//- (NSString *)XMLParameter{
//    NSMutableString *xmlStr = [NSMutableString string];
//    int i = 0;
//    for (LayoutModel *layoutModel in self.costarrdate) {
//        AppDelegate *app =[UIApplication sharedApplication].delegate;
//        self.dict2=app.dict;
//      
//        
//        NSString *value = [self.dict2 newValueFromOldValue:_dexcel property:];
//        
//        if (layoutModel.ismust && value.length == 0) {
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空",layoutModel.name]];
//            return nil;
//        }
//        if (i != 0 && value.length != 0) {
//            if (i != self.costarrdate.count - 1) {
//                [xmlStr appendFormat:@"%@=\"%@\" ",layoutModel.fieldname,value];
//                
//            }
//            else
//            {
//                [xmlStr appendFormat:@"%@=\"%@\"",layoutModel.fieldname,value];
//            }
//        }
//        //        else if (i != 0){
//        //            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@不能为空",layoutModel.Name]];
//        //            return nil;
//        //        }
//        i++;
//    }
//    NSString *returnStr = [NSString stringWithFormat:@"<data %@></data>",xmlStr];
//    NSLog(@"xmlStr : %@",returnStr);
//    return returnStr;
//}
//- (void)selectItem:(NSString *)name ID:(NSString *)ID view:(KindsItemsView *)view{
//    NSInteger tag = view.tag;
//    
//    NSLog(@"%@%@",name,ID);
//  _layoutModel = [self.costatrraylost safeObjectAtIndex:1];
////    [self.XMLParameterDic setObject:ID forKey:layoutModel.key];
////    [self.tableViewDic setObject:name forKey:layoutModel.key];
//    
//    
//    [self.dict2 setObject:name forKey:_layoutModel.fieldname];
//    
//    
//    
//       [view closed];
//    [self.tableview reloadData];
//}
- (void)selectItemArray:(NSArray *)arr view:(KindsItemsView *)view{
    NSString *idStr = @"";
    NSString *nameStr = @"";
    NSInteger tag = view.tag;
   MiXimodel *layoutModel = [self.costatrraylost safeObjectAtIndex:tag];
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
  [self.dict2 setValue:nameStr forKey:layoutModel.fieldname];
    
    [self.tableview reloadData];
}
//
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
