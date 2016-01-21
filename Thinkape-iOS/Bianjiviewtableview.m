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
@interface Bianjiviewtableview ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,SDPhotoBrowserDelegate,QLPreviewControllerDataSource,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,assign)int countu;
@property(nonatomic,strong)NSMutableArray *imagedatarry;
@property(nonatomic,strong)NSMutableArray *updatearry;
@property (weak, nonatomic) IBOutlet UIButton *safetext;
@property(nonatomic,strong)NSMutableDictionary *dict1;
@end

@implementation Bianjiviewtableview
{
    NSString *delteImageID;
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
    
    self.title=@"单据明细";
    
    self.tableview.bounces=YES;
    self.imagedatarry=[NSMutableArray array];
    self.updatearry =[NSMutableArray array];
    self.dict1 =[[NSMutableDictionary alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    CostLayoutModel *model = [self.costArray objectAtIndex:_indexto];
    
   
    return model.fileds.count+2;
   
    
}

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
//     LayoutModel *layoutModel =[model.fileds safeObjectAtIndex:indexPath.row];
    
   cell.textlabel.text=[NSString stringWithFormat:@"%@",layoutModel.name];
    NSArray *array =[self.costArr safeObjectAtIndex:_indexto];
    //            NSDictionary *dict =[array safeObjectAtIndex:self.indexto];
   
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.dict1=app.dict;
    
    cell.detailtext.text=[self.dict1 objectForKey:layoutModel.fieldname];
    
    _updatearry=app.uptateimage;
    _imagedatarry=app.uptateimage;
//    
//    if (!bgView) {
////         _imagedatarry.count + _updatearry.count
//        NSInteger count =2;
//        CGFloat speace = 15.0f;
//        CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
//        int row = count / 3 + 1;
//        bgView.backgroundColor = [UIColor redColor];
//        [bgView setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (speace + imageWidth) * row)];
////        [bgView removeFromSuperview];
//        //    [self addItems:bgView];
//        [cell.contentView addSubview:bgView];
//    }
    if (indexPath.row==model.fileds.count) {
        [cell.textlabel removeFromSuperview];
        
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(80, 10, 30, 30)];
        [button setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(plusimage) forControlEvents:UIControlEventTouchUpInside];
       
        [cell.contentView addSubview:button];
//        [self addItems:cell.contentView];
       
    }
    if (indexPath.row==model.fileds.count+1) {
        
        if (_updatearry != 0 || _imagedatarry.count != 0) {
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
                [btn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
//                if ([self isUnCommint]) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
                    [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
                    deleteBtn.tag = 1024+ i;
//                    [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                    [btn addSubview:deleteBtn];
                }
//                
            }
     }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
   
    }

}
//- (IBAction)safedate:(id)sender {
//    
//    
//    
//    NSIndexPath *index =[self.tableview indexPathForSelectedRow];
//    CostLayoutModel *model = [self.costArray safeObjectAtIndex:_indexto];
//   BijicellTableViewCell *cell =[self.tableview cellForRowAtIndexPath:index];
//  LayoutModel *layout =[model.fileds safeObjectAtIndex:index.row];
//    NSArray *dataArr =[_costArr safeObjectAtIndex:index.row];
//    self.dict1 =[dataArr safeObjectAtIndex:index.row];
//    if ([layout.fieldname isEqualToString:@"leavedate"]) {
//       
////        cell.detailtext.text =[]
//    }
//    
//    
//    
//    
//    
//       [self.tableview reloadData];
// 
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    
//    
//    
//    
//    
//    
//}
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
        UIImage *image = [UIImage imageWithCGImage:[set thumbnail]];
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

- (void)showImage:(UIButton *)btn{
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
