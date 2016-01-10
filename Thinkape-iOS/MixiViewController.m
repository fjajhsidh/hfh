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
@interface MixiViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *safete;
@property(nonatomic,strong)NSMutableDictionary *dict2;

@end

@implementation MixiViewController
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
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)] ]
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.dict2 =[NSMutableDictionary dictionary];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    CostLayoutModel *model =[self.costatrraylost safeObjectAtIndex:_index];
  
    return model.fileds.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CostLayoutModel *model =[self.costatrraylost safeObjectAtIndex:_index];
    LayoutModel *layoutModel =[model.fileds safeObjectAtIndex:indexPath.row];
    
    BijicellTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"BijicellTableViewCell" owner:self options:nil] lastObject];
        
        
    }
    cell.textlabel.text=[NSString stringWithFormat:@"%@",layoutModel.name];
    
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    self.dict2=app.dict;
    
    
    
 
       cell.detailtext.text =@"";
//    self.dict2 =[NSDictionary dictionary];
//    AppDelegate *app =[UIApplication sharedApplication].delegate;
//    
//    self.dict2=app.dict;
//    
    
  
    
    
    
    if ([layoutModel.fieldname isEqualToString:@"itemid_show"]||[layoutModel.fieldname isEqualToString:@"costtypeid_show"]||[layoutModel.fieldname isEqualToString:@"memo"]) {
        cell.detailtext.placeholder=@"";
       
        
    }else
    {
        cell.detailtext.placeholder=@"不能为空";
        
    }
    
   
//    NSInteger count = _imageArray.count + _uploadArr.count;
//    CGFloat speace = 15.0f;
//    CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
//    int row = count / 3 + 1;
//    //bgView.backgroundColor = [UIColor redColor];
//    [bgView setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (speace + imageWidth) * row)];
//    [bgView removeFromSuperview];
//    [self addItems:bgView];
    
    
    
    
    
    return cell;
    
}
- (IBAction)safetosave:(id)sender {
   //    BijicellTableViewCell *cell =[self.tableview cellForRowAtIndexPath:asd];
    
//    NSString *sad=[NSString stringWithFormat:@"%@",cell.detailtext.text];
    
    
//    cell.detailtext.text=[self.dict2 didChangeValueForKey:<#(nonnull NSString *)#>]
//
//    NSIndexPath *index =[self.tableview indexPathForSelectedRow];
    
    
    CostLayoutModel *models =[self.costatrraylost safeObjectAtIndex:_index ];
    LayoutModel *layout =[models.fileds objectAtIndex:_index];
//    AppDelegate *app =[UIApplication sharedApplication].delegate;
//    self.dict2=app.dict;
    AppDelegate *aler =[UIApplication sharedApplication].delegate;
    self.dict2=aler.dict;
    
    NSIndexPath *indexs =[self.tableview indexPathForSelectedRow];
    
//    BijicellTableViewCell *cell =[self.tableview cellForRowAtIndexPath:indexs];
//    
    
//    [self.dict2 newValueFromOldValue:cell.detailtext.text property:layout.fieldname];
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
   
//    [self.tableview reloadData];
    
   
 
    
    
    
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
