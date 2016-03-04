//
//  Bianjito.m
//  Thinkape-iOS
//
//  Created by admin on 15/12/29.
//  Copyright © 2015年 TIXA. All rights reserved.
//

#import "Bianjito.h"
#import "CostLayoutModel.h"
#import "LayoutModel.h"
#import "Bianjiviewtableview.h"
#import "AppDelegate.h"
#import "MixiViewController.h"
@interface Bianjito ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview2;
@property(nonatomic,strong)UIAlertView *activer;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation Bianjito

{
    CGFloat width;
    CGFloat itemWidth;
    CGFloat speace;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self viewDidLoad];
   
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
   
    self.title = @"明 细";
    
    itemWidth = 80;
    speace = 20;
   // self.acceptAddDict=[[NSMutableDictionary alloc]init];
//    self.acceptEditorDict=[[NSMutableDictionary alloc]init];
//    self.arrayDict=[[NSMutableArray alloc]init];
//  
//    //wo
//    AppDelegate *app=[UIApplication sharedApplication].delegate;
//    NSLog(@"987=%@=%@",app.costLayoutArray,app.costDataArr);
//    self.costLayoutArray = app.costLayoutArray;
//    self.costDataArr = app.costDataArr;
    
    [self addRightNavgation];
    [self itemLength];
    [self layoutScroll];
    self.scrollview.bounces=NO;
    self.navigationController.navigationBarHidden=NO;
    if (self.editstart==YES) {
        [self.tableview reloadData];
    }
//    if (self.isEditor) {
//        self.index=1;
//    }
//    
}
-(void)addRightNavgation{
    UIButton *imageview = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imageview setBackgroundImage:[UIImage imageNamed:@"jiaban_white.png"] forState:UIControlStateNormal];
    [imageview addTarget:self action:@selector(appcer) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:imageview];
    
    self.navigationItem.rightBarButtonItem=item;






}
//-(void)saveUserDefaults{
//    
//    NSLog(@"%@",self.costLayoutArray[0]);
//    
//    
//NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:self.costLayoutArray forKey:@"costLayoutArray"];
//    [userDefaults synchronize];
//    
//}
//
//-(NSMutableArray *)readUserDefaults{
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray * arr=[userDefaults objectForKey:@"costLayoutArray"];
//    
//    return arr;
//}

-(void)appcer
{
    
//    self.selectType=@"add";
//    MixiViewController *vc =[[MixiViewController alloc] init];
//    vc.index = _index;
//    vc.costatrraylost=self.costLayoutArray;
//    vc.costarrdate=self.costDataArr;
//    vc.selectAcceptType=self.selectType;
    Bianjiviewtableview *vc =[Bianjiviewtableview new];
    vc.indexto = _index;
    vc.costArray=self.costLayoutArray;
    vc.costArr=self.costDataArr;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//wo左下角的按钮
- (void)layoutScroll{
    
    UIScrollView  *bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80)];
    for (int i = 0; i < _costLayoutArray.count; i++) {
        CostLayoutModel *model = [_costLayoutArray safeObjectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(60 + 35), 10, 57, 57)];
        [btn addTarget:self action:@selector(costDetail:) forControlEvents:UIControlEventTouchUpInside];
//        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.photopath] forState:UIControlStateNormal];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photopath]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ab_nav_bg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        btn.tag = i;
        [bottomScroll addSubview:btn];
        
        UILabel *totleMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, 57, 15)];
        totleMoney.textColor = [UIColor whiteColor];
        totleMoney.font = [UIFont systemFontOfSize:15];
        totleMoney.text = model.TotalMoney;
        totleMoney.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:totleMoney];
    }
    [bottomScroll setContentSize:CGSizeMake(95*_costLayoutArray.count, 80)];
    bottomScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bottomScroll];
}
- (void)costDetail:(UIButton *)btn{
    
    _index = btn.tag;
    
    [self itemLength];
    [self.tableview reloadData];
    
}
- (void)itemLength{
    CostLayoutModel *model = [self.costLayoutArray safeObjectAtIndex:_index];
    width = (itemWidth + speace) * model.fileds.count +100+ speace;
    self.tableview2.constant = width + 24;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [_costDataArr safeObjectAtIndex:_index ];
    
    return array.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CostLayoutModel *model = [self.costLayoutArray safeObjectAtIndex:_index];
    NSString *cellid = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.backgroundColor = [UIColor clearColor];
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    if (indexPath.row == 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 17, width, 30)];
        bgView.backgroundColor = [UIColor colorWithRed:0.275 green:0.557 blue:0.914 alpha:1.000];
        [cell.contentView addSubview:bgView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(13, 7.5, width, 15)];
        title.font = [UIFont systemFontOfSize:15];
        title.text = model.name;
        title.textColor = [UIColor whiteColor];

        
        [bgView addSubview:title];
        
    }
   
    else{
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, width, 50)];
        bgView.tag = 304;
        for (int i = 0; i < model.fileds.count + 1; i++) {
            UILabel *label;
            UIButton *button;
            if (i == 0 ) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 40, 15)];
                button=[[UIButton alloc] initWithFrame:CGRectMake(10, 8, 40, 15)];
            }
            else
               
                label = [[UILabel alloc] initWithFrame:CGRectMake(40+speace + (itemWidth + speace) * (i-1), 8, itemWidth, 15)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.tag = i;
            label.textColor = [UIColor colorWithHexString:@"333333"];
//       
           button=[[UIButton alloc] initWithFrame:CGRectMake(bgView.frame.origin.x-speace+(itemWidth+speace)*(i-1)-10, 8, itemWidth, 15)];
//            button.font=[UIFont systemFontOfSize:13];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.tag=i;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
          
             [bgView addSubview:label];
            [bgView addSubview:button];
           
             if (indexPath.row == 1)
             {
                if (label.tag == 0) {
                    label.text = @"序号";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else
                {
                    LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:label.tag - 1];
                    label.text = layoutModel.name;
                    
                }
                if (button.tag==1) {
                    [button setTitle:@"操作" forState:UIControlStateNormal];
               }
            }
            else
            {
                if (label.tag == 0) {
                   label.text = [NSString stringWithFormat:@"%ld",indexPath.row - 1];
                   
                }
                else{
                 
                    LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:label.tag - 1];
                  
//                    NSMutableArray *dataArr = [_costDataArr safeObjectAtIndex:_index];
                   NSMutableArray *dataArr = _costDataArr[0];
                    

                    _datar = [dataArr safeObjectAtIndex:indexPath.row-2];
                    
                    if (_index==0) {
                        //判断传值是否经过传值而过来的字典
                        if (self.editstart==YES) {
                            
                            
                            //   _costDataArr[0][indexPath.row-2]
                            
                            
                            //                            [_costDataArr[0] replaceObjectAtIndex:indexPath.row-2 withObject:self.editnew];
                            
                            //                          _datar = [dataArr safeObjectAtIndex:indexPath.row-2];
                           
                            _datar = self.editnew;
                            
                        }
                        else {
                            if (self.isstrart==YES) {
                                
                                _datar = self.editxiao;
                            }
                        }
                    }

//                     _datar = dataArr[indexPath.row-2];
                   
                  
                         label.text = [_datar objectForKey: layoutModel.fieldname];
                  
                    
                   
                    
                    NSLog(@"_datar====%@",_datar);
                    NSLog(@"%@",label.text);
                  
                    NSLog(@"_datar====%@",_datar);
                    NSLog(@"%@",label.text);
                    AppDelegate *app =[UIApplication sharedApplication].delegate;
                  
                        app.dict=_datar;
                    
                   //                    //wo
//                    if (self.editstart==YES) {
//                        _datar=self.editnew;
//                    }
//                    
//                    label.text = [_datar objectForKey:layoutModel.fieldname];
//                    NSLog(@"_datar====%@",_datar);
                    NSLog(@"%@",label.text);
                   
                   //进入明细
//                    UITapGestureRecognizer *taper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapsion:)];
//                    taper.numberOfTouchesRequired=1;
//                    [cell.contentView addGestureRecognizer:taper];
                    
                 }
                if (button.tag==1) {
                     [button setTitle:@"删除" forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(buttonaction) forControlEvents:UIControlEventTouchUpInside];
                    [bgView addSubview:button];
                    
                }
            }
        }
        [cell.contentView addSubview:bgView];
        
        if ((indexPath.row - 2) % 2 == 0)
            bgView.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
        else
            //序号的背景
            bgView.backgroundColor = [UIColor whiteColor];
        
        
        
    }
   
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    MixiViewController *vc =[[MixiViewController alloc] init];
    vc.index = _index;
    vc.costatrraylost=self.costLayoutArray;
    vc.costarrdate=_costDataArr;
    vc.selectAcceptType=self.selectType;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}
-(void)tapsion:(UITapGestureRecognizer *)sender
{
    
    
   
    MixiViewController *vc =[[MixiViewController alloc] init];
    vc.index = _index;
    vc.costatrraylost=self.costLayoutArray;
    vc.costarrdate=self.costDataArr;
    vc.selectAcceptType=self.selectType;
    [self.navigationController pushViewController:vc animated:YES];
    
    
//    self.selectType=@"editor";
//    
//   Bianjiviewtableview *vc=[[Bianjiviewtableview alloc] init];
//    vc.costArray=self.costLayoutArray;
//    vc.costArr=self.costDataArr;
//    
//    
//    vc.indexto=_index;
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)buttonaction
{
 
    [self.costDataArr removeAllObjects];
    [self.tableview reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 47.0f;
    }
    else
        return 50.0f;
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
