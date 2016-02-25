//
//  FanKuiSViewController.m
//  Thinkape-iOS
//
//  Created by admin on 16/2/14.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "FanKuiSViewController.h"
#import "MacroDefinition.h"
#import "SDPhotoBrowser.h"
#import <QuickLook/QLPreviewController.h>
#import <QuickLook/QLPreviewItem.h>
#import "CTToastTipView.h"
#import "ImageModel.h"
#import "UIImage+SKPImage.h"
#import "CTAssetsPickerController.h"

#import <NSArray+BFKit.h>
@interface FanKuiSViewController ()<UITextViewDelegate,UIActionSheetDelegate,SDPhotoBrowserDelegate,QLPreviewControllerDataSource,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *imageArrce;
@property(nonatomic,strong)NSMutableArray *imageUP;
@property(nonatomic,strong)UIActionSheet *actionSheet;
@property(nonatomic,copy)NSString *dictString;
@property(nonatomic,copy)NSString *Messagephone;

@end

@implementation FanKuiSViewController
{
    UIView *bgView;
    NSString *delteImageID;
    NSString *cusid;
    NSString *fank;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    fank =@"请输入你的宝贵意见和建议,以便我们能够为您提供更好的服务！";
    
    self.yijian.text =fank;
    self.yijian.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];

    self.yijian.delegate = self;
    self.yijian.layer.borderColor=[UIColor colorWithHexString:@"#ccc"].CGColor;
    self.yijian.layer.cornerRadius=5.0f;
    self.yijian.layer.borderWidth=1;
    self.Tijiao.layer.cornerRadius=5.0f;
    self.tableview.layer.borderColor=[UIColor colorWithHexString:@"#ccc"].CGColor;
    self.tableview.layer.borderWidth=1;
    self.textMessage.placeholder = @"电话/邮箱/QQ/微信号";
    self.textMessage.layer.borderColor =[UIColor colorWithHexString:@"#ccc"].CGColor;
    self.textMessage.delegate = self;
    _imageUP = [[NSMutableArray alloc] initWithCapacity:0];
    self.tableview.delegate=self;
    
  
   
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text= @"请输入你的宝贵意见和建议,以便我们能够为您提供更好的服务！";
        textView.textColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.5];
    }
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    
    
    if ([textView.text isEqualToString:@"请输入你的宝贵意见和建议,以便我们能够为您提供更好的服务！"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
       
    }
   
    
    
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    
    self.dictString = textView.text;
    NSLog(@"反馈的建议是=%@",self.dictString);
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.Messagephone=textField.text;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strad = @"Cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:strad];
    
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strad];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
    if (indexPath.row==0) {
        cell.textLabel.text=@"图片";
        
    }
    
    if (indexPath.row==1) {
        //            if (_imageUP.count != 0 || _imageArrce.count != 0) {
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        NSInteger count = _imageUP.count;
        CGFloat speace = 10.0f;
        //                CGFloat imageWidth = (SCREEN_WIDTH - 4*speace) / 3.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 20*speace) / 3.0f;
        for (int i = 0; i < count; i++) {
            int cloum = i %5;
            int row = i / 5;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            ImageModel *model = [_imageUP safeObjectAtIndex:i];
            if ([self fileType:model.FilePath] == 1) {
                [btn setImage:[UIImage imageNamed:@"word"] forState:UIControlStateNormal];
            }
            else{
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.FilePath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ab_nav_bg"]];
            }
            btn.tag = 1024+ i;
            [btn addTarget:self action:@selector(showImageS:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setFrame:CGRectMake(imageWidth - 15, 0,15, 15)];
            [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
            deleteBtn.tag = 1024+ i;
            [deleteBtn addTarget:self action:@selector(deleteImageS:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:deleteBtn];
        }
        count += _imageArrce.count;
        for (int i = _imageUP.count; i < count; i++) {
            int cloum = i %5;
            int row = i / 5;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            [btn setBackgroundImage:[_imageArrce safeObjectAtIndex:i - _imageUP.count] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showSelectImageS:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2024+ i;
            [cell.contentView addSubview:btn];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setFrame:CGRectMake(imageWidth - 15, 0, 15, 15)];
            [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
            deleteBtn.tag = 2024+ i;
            [deleteBtn addTarget:self action:@selector(deleteImageS:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:deleteBtn];
            
        }
        int btnCloum = count %5;
        int btnRow = count / 5;
        cell.backgroundColor = [UIColor clearColor];
        UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [addImage setFrame:CGRectMake(speace + (speace + imageWidth) * btnCloum, speace + (speace + imageWidth) * btnRow, imageWidth, imageWidth)];
        [addImage setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        [addImage addTarget:self action:@selector(showPickImageVCS) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addImage];
        
        //            }else
        //            {
        //                CGFloat speace = 15.0f;
        //                CGFloat imageWidth = (SCREEN_WIDTH - 36 - 4*speace) / 3.0f;
        //                UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
        //                [addImage setFrame:CGRectMake(speace + (speace + imageWidth) * 0, speace + (speace + imageWidth) * 0, imageWidth, imageWidth)];
        //                [addImage setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        //                [addImage addTarget:self action:@selector(showPickImageVCS) forControlEvents:UIControlEventTouchUpInside];
        //                [cell.contentView addSubview:addImage];
        //            }
        //
    }
    

    
    
    
        return cell;
    }
- (void)showPickImageVCS{
        if (!_imageArrce) {
            _imageArrce = [[NSMutableArray alloc] initWithCapacity:0];
        }
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"本地相册", nil];
        [self.actionSheet showInView:self.view];
    
        
    }
    
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
        return 1;
    }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        
        //        NSInteger count = _imageArrce.count;
        //        CGFloat speace = 15.0f;
        //        CGFloat imageWidth = (SCREEN_WIDTH - 4*speace) / 3.0f;
        //        int row = count / 3 + 1;
        //        return (speace + imageWidth) * row;
        int row =0;
        if (indexPath.row==0) {
            
            return 20;
            
        }
        else {
            NSInteger count = _imageArrce.count+_imageUP.count;
            CGFloat speace = 10.0f;
            CGFloat imageWidth = (SCREEN_WIDTH - 20*speace) / 3.0f;
            long rows = count / 5 +1;
            
            row= (speace + imageWidth) * rows+90;
            
        }
        return row;
    }
- (void)deleteImageS:(UIButton *)btn{
        
        if (btn.tag >=1024 && btn.tag < 2024) {
            ImageModel *model = [_imageUP safeObjectAtIndex:btn.tag - 1024];
            if (delteImageID.length == 0) {
                delteImageID = [NSString stringWithFormat:@"%@",model.ID];
            }
            else{
                delteImageID = [NSString stringWithFormat:@"%@,%@",delteImageID,model.ID];
            }
            [_imageUP removeObject:model];
        }
        else{
            [_imageArrce removeObjectAtIndex:btn.tag - 2024];
            [self.tableview reloadData];
        }
        [self.tableview reloadData];
    }
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
        [_imageArrce addObject:image];
        [self.tableview reloadData];
    }
 - (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
        [picker dismissViewControllerAnimated:YES completion:nil];
        id class = [assets lastObject];
        for (ALAsset *set in assets) {
            UIImage *image = [UIImage imageWithCGImage:[set aspectRatioThumbnail]];
            [_imageArrce addObject:image];
        }
        [self.tableview reloadData];
        NSLog(@"class :%@",[class class]);
    }
 - (void)showSelectImageS:(UIButton *)btn{
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        
        browser.sourceImagesContainerView = nil;
        
        browser.imageCount = _imageArrce.count;
        
        browser.currentImageIndex = btn.tag - 2024 - _imageUP.count;
        
        browser.delegate = self;
        browser.tag = 11;
        [browser show]; // 展示图片浏览器
    }
    - (void)showImageS:(UIButton *)btn{
        ImageModel *url = [_imageUP safeObjectAtIndex:btn.tag - 1024];
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
            
            browser.imageCount = _imageUP.count;
            
            browser.currentImageIndex = btn.tag - 1024;
            
            browser.delegate = self;
            
            [browser show]; // 展示图片浏览器
        }
        
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
    - (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
        return 1;
    }
    
    - (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
        return [NSURL fileURLWithPath:[[RequestCenter defaultCenter] filePath]];
    }
    - (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
        // UIButton *imageView = (UIButton *)[bgView viewWithTag:index];
        if (browser.tag == 11) {
            return _imageArrce[index];
        }
        else
            return nil;
    }
    - (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
        if (browser.tag == 10) {
            NSLog(@"url %@",[_imageUP objectAtIndex:index]);
            ImageModel *model = [_imageUP objectAtIndex:index];
            return [NSURL URLWithString:model.FilePath];
        }
        else
            return nil;
        
    }
    - (NSString *)bate64ForImage:(UIImage *)image{
        UIImage *_originImage = image;
        NSData *_data = UIImageJPEGRepresentation(_originImage, 0.5f);
        NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return _encodedImageStr;
    }
    
//    -(void)textViewDidBeginEditing:(UITextView *)textView
//    {
//       
//        self.yijian.text = @"";
//        self.yijian.textColor = [UIColor blackColor];
//      
//       
//
//        
//    }
//

//-(void)textViewDidEndEditing:(UITextView *)textView
//    {
//        if ([self.yijian.text isEqualToString:@""]) {
//            self.yijian.text =@"请输入你的宝贵意见和建议,以便我们能够为您提供更好的服务";
//            self.yijian.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//            
//        }
//        
//        self.dictString = textView.text;
//        NSLog(@"反馈意见%@",self.dictString);
//    }
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    
   
         self.Messagephone= textField.text;
   
    NSLog(@"%@",self.Messagephone);
}
- (NSString *)XMLParameter{
    
    NSMutableString *xmlStr = [NSMutableString string];
   
    if ([self.dictString isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"意见反馈不能为空"]];
        return nil;
    }else
    {
        [xmlStr appendFormat:@"%@",self.dictString];
        
         
    }
    
    NSString *returnStr = [NSString stringWithFormat:@"<data %@></data>",xmlStr];
    NSLog(@"xmlStr : %@",returnStr);
    return returnStr;
    
    
    
}
-(NSString *)XmlMe
{
    NSMutableString *Messto =[NSMutableString string];
    [Messto appendFormat:@"%@",self.Messagephone];
    NSString *returnMessage = [NSString stringWithFormat:@"<data %@></data>",Messto];
    NSLog(@"xmlStr : %@",returnMessage);
    return returnMessage;
}
-(void)Commit
{
    NSString *Feedback= self.dictString;
    NSString *Messages = self.Messagephone;
    if (Feedback ==nil||[Feedback isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入反馈意见"];
        return;
    }
//    NSString *netSever = [NSString stringWithFormat:@"%@?ac=CusSuggestionData&u=%@&memo=%@&connway=%@",Web_Domain,self.uid,Feedback,Messages];
      NSString *netSever = [NSString stringWithFormat:@"http://27.115.23.126:5032/ashx/mobilenew.ashx?ac=CusSuggestionData&u=%@&memo=%@&ipaddress=%@&connway=%@",self.uid,Feedback,Web_Domain,Messages];
    NSLog(@"反馈的网址%@",netSever);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *op = [manager POST:[netSever stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                    parameters:nil
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                      long errors = [[responseObject objectForKey:@"error"] integerValue];
                                           
                                           
                                           
                                           if (errors==0) {
                                               [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                                               NSDictionary *dic = [responseObject objectForKey:@"msg"];
                                               cusid = [NSString stringWithFormat:@"%@",dic[@"cusid"]];                                              [self.navigationController popViewControllerAnimated:YES];
                                               ;
                                              
                                               if (![cusid isEqualToString:@""]&&_imageArrce.count >0) {
                                                   [self uploadImage:cusid ac:@"" inde:0];
                                               }
                                               if (self.updateData) {
                                                   self.updateData();
                                               }
                                           }
                                       
                                           else
                                               
                                               [SVProgressHUD showInfoWithStatus:@"提交失败，请稍后尝试"];
                                          
                                       }

                                           
                                  
                                  
                                  
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                       }];
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"totle %lld",totalBytesWritten);
    }];
   
    };



- (void)uploadImage:(NSString *)theSspid ac:(NSString *)ac inde:(NSInteger)index{
    NSString *fbyte = @"";  //图片bate64
    
    
    if (_imageArrce.count != 0) {
        fbyte = [self bate64ForImage:[_imageArrce objectAtIndex:index]];
    }
    
    NSLog(@"bate64 : %@",fbyte);
    NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
    [dictData setObject:fbyte forKey:@"FByte"];
    NSString *str = [NSString stringWithFormat:@"http://27.115.23.126:5032/ashx/mobilenew.ashx?ac=CusSuggestionFile&u=%@&EX=%@&cusid=%@&FName=%@",self.uid,@".jpg",theSspid,@"image"];
    if (delteImageID.length != 0) {
        str = [NSString stringWithFormat:@"%@&delpicid=%@",str,delteImageID];
    }
    NSLog(@"str : %@",str);
    [SVProgressHUD showWithMaskType:2];
    [[AFHTTPRequestOperationManager manager] POST:str
                                       parameters:fbyte.length == 0 ? nil :@{@"FByte":fbyte}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSDictionary *error = [responseObject objectForKey:@"msg"];
                                              
                                              long edite = [[error objectForKey:@"error"] integerValue];
                                              if (edite==0) {
                                                  [SVProgressHUD dismiss];
                                                  if (index + 1 < _imageArrce.count) {
                                                      [self uploadImage:cusid ac:ac inde:index + 1];
                                                        [SVProgressHUD showErrorWithStatus:@"提交成功"];
                                              }
                                               
                                                  NSString *sterd = [error objectForKey:@"msg"];
                                                  if ([sterd isEqualToString:@"ok"])
                                                  {
                                                      
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                    
                                                  }
                                        
                                              

                                                          if (self.callsback) {
                                                              self.callsback();
                                                          }
                                                   }
                                                  }
                                              //}
                                          //}
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              
                                          }];
    
}

- (IBAction)CommitMessage:(id)sender {
    [self Commit];
}

- (NSString *)uid{
    return [DataManager shareManager].uid;
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
