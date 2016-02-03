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
@interface Bianjiviewtableview ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,SDPhotoBrowserDelegate,QLPreviewControllerDataSource,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,assign)int countu;
@property(nonatomic,strong)NSMutableArray *imagedatarry;
@property(nonatomic,strong)NSMutableArray *updatearry;
@property (weak, nonatomic) IBOutlet UIButton *safetext;
@property(nonatomic,strong)NSMutableDictionary *dict1;
@property(nonatomic,strong)UITextField *textstring;
@property(nonatomic,strong)UIButton *addImage;
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    
    self.title=@"编辑明细";
    
    self.tableview.bounces=YES;
    
    
    self.imagedatarry=[NSMutableArray array];
    self.updatearry =[NSMutableArray array];
    self.dict1 =[[NSMutableDictionary alloc]init];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.dict1 = [NSMutableDictionary dictionaryWithDictionary:app.dict];
    
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

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//{
//    
//    
//    CostLayoutModel *model = [self.costArray safeObjectAtIndex:_indexto];
//    
//    LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:indexPath.row];
//   
//    
//    BijicellTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    if (!cell) {
//        cell=[[[NSBundle mainBundle] loadNibNamed:@"BijicellTableViewCell" owner:self options:nil] lastObject];
////       
////             LayoutModel *layoutModel =[model.fileds safeObjectAtIndex:cell.textlabel.tag-1];
////            cell.textlabel.text=layoutModel.name;
//  
//        //      cell.textlabel.text=[NSString stringWithFormat:@"%@",layoutModel.name];
////        [cell.contentView addSubview:cell.textlabel];
//        
//    }
//    UIView *subView = [cell.contentView viewWithTag:203];
//    UIView *subView1 = [cell.contentView viewWithTag:204];
//    [subView removeFromSuperview];
//    [subView1 removeFromSuperview];
////     LayoutModel *layoutModel =[model.fileds safeObjectAtIndex:indexPath.row];
//    
//   cell.textlabel.text=[NSString stringWithFormat:@"%@",layoutModel.name];
//    NSArray *array =[self.costArr safeObjectAtIndex:_indexto];
//    //            NSDictionary *dict =[array safeObjectAtIndex:self.indexto];
//   
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    self.dict1=app.dict;
//    
//    cell.detailtext.text=[self.dict1 objectForKey:layoutModel.fieldname];
//    
//    _updatearry=app.uptateimage;
//    _imagedatarry=app.uptateimage;
////    
////    if (!bgView) {
//////         _imagedatarry.count + _updatearry.count
////        NSInteger count =2;
////        CGFloat speace = 15.0f;
////        CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
////        int row = count / 3 + 1;
////        bgView.backgroundColor = [UIColor redColor];
////        [bgView setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (speace + imageWidth) * row)];
//////        [bgView removeFromSuperview];
////        //    [self addItems:bgView];
////        [cell.contentView addSubview:bgView];
////    }
//    if (indexPath.row==model.fileds.count) {
//      [cell.textlabel removeFromSuperview];
//        
//        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(80, 10, 30, 30)];
//        [button setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
//       
//        
//        [button addTarget:self action:@selector(plusimage) forControlEvents:UIControlEventTouchUpInside];
//       
//        [cell.contentView addSubview:button];
////        [self addItems:cell.contentView];
//       
//    }
//    if (indexPath.row==model.fileds.count) {
//        
//        if (_updatearry != 0 || _imagedatarry.count != 0) {
//            NSInteger count = _updatearry.count;
//            CGFloat speace = 15.0f;
//            CGFloat imageWidth = (SCREEN_WIDTH - 36 - 4*speace) / 3.0f;
//            
//            for (int i = 0; i < count; i++) {
//                int cloum = i %3;
//                int row = i / 3;
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
//                NSString *url = [_updatearry safeObjectAtIndex:i];
//                if ([self fileType:url] == 1) {
//                    [btn setImage:[UIImage imageNamed:@"word"] forState:UIControlStateNormal];
//                }
//                else{
//                    [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
//                }
//                btn.tag = 1024+ i;
//                [btn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.contentView addSubview:btn];
////                if ([self isUnCommint]) {
//                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                    [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
//                    [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
//                    deleteBtn.tag = 1024+ i;
////                    [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
//                    [btn addSubview:deleteBtn];
//                }
////                
//            }
//     }
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    
//    return cell;
//   
//    }
//    
//
//
//    
//    
//    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    {
        
        
        CostLayoutModel *model = [self.costArray safeObjectAtIndex:_indexto];
        
        LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:indexPath.row];
        
        
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
        cell.detailtext.delegate= self;
        cell.detailtext.tag=indexPath.row;
        
        
        
 
        
        if (indexPath.row==model.fileds.count) {
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
    
    CostLayoutModel *model = [self.costArray safeObjectAtIndex:_indexto];
    
//    LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:indexPath.row];
//    
    NSInteger height =0;
    if (indexPath.row !=model.fileds.count) {
        return 40;
      
        
    }
//    else
    
//    {
   ;
    

    
        if (indexPath.row!=model.fileds.count+1) {
//            NSInteger count = _imagedatarry.count + _updatearry.count;
            NSInteger count = _imagedatarry.count;
            CGFloat speace = 15.0f;
            CGFloat imageWidth = (SCREEN_WIDTH - 4*speace) / 3.0f;
//            int row = count / 3 + 1;
            int row = count / 3+1;
            height= (speace + imageWidth) * row;
            NSLog(@"cell的高度%d",height);
            
//            return (speace + imageWidth) * row;
        }
 
//    }
    return height;
    
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
