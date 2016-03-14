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
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,assign)int firstindex;
@property(nonatomic,assign)BOOL ishandan;
@end

@implementation Bianjito

{
    CGFloat width;
    CGFloat itemWidth;
    CGFloat speace;
    UILabel *label;
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
   
    
    if (_dataArr.count!=0) {
        [self readtoarray];
        _firstindex=1;
    }
 
    [self addRightNavgation];
    [self itemLength];
    [self layoutScroll];
    self.scrollview.bounces=NO;
    self.navigationController.navigationBarHidden=NO;
    if (self.editstart==YES||self.isstrart==YES) {
        [self.tableview reloadData];
    }
   
    

}
-(void)addRightNavgation{
    UIButton *imageview = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imageview setBackgroundImage:[UIImage imageNamed:@"jiaban_white.png"] forState:UIControlStateNormal];
    [imageview addTarget:self action:@selector(appcer) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:imageview];
    
    self.navigationItem.rightBarButtonItem=item;






}


-(void)appcer
{
    
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
//            UILabel *label;
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
                   
                  LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:label.tag -1];
                    
                  _dataArr = [_costDataArr safeObjectAtIndex:_index];
                   
                  _datar = [_dataArr safeObjectAtIndex:indexPath.row-2];
               
                   
                    //判断传值是否经过传值而过来的字典
                 
                [self savetoarray];
                
                if (_index==0) {
                        
                        
                        if (self.editstart==YES) {
                            //通过我的点的行数，值就会带到那行
//                                                  if (indexPath.row==_indexRow+2) {
                            
                           
                            
                            NSMutableDictionary *adc =[NSMutableDictionary dictionaryWithDictionary:self.editnew];
                            if (adc.count==0) {
                                
                            }
                             else
                             {
                            NSMutableArray *sad =[NSMutableArray arrayWithArray:_dataArr];
                            [sad replaceObjectAtIndex:_indexRow withObject:adc];
                                 _dataArr = sad;
                             }
                            
                            //替换数组
                            
                            
                            _datar = [_dataArr safeObjectAtIndex:indexPath.row-2];
                            
                            NSString *cc = [_datar objectForKey:layoutModel.fieldname];
                           
                            
                            label.text =cc;
                            
                            _firstindex=2;
                           
                           
                            
              //  }
               
                      
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                    if (_index==1) {
                        if (self.isstrart==YES&&self.isstrart==NO) {
                            
                            if (self.editxiao.count !=0) {
                                
                            
                            NSMutableDictionary *adc =[NSMutableDictionary dictionaryWithDictionary:self.editxiao];
                          
                            NSMutableArray *sad =[NSMutableArray arrayWithArray:_dataArr];
                            [sad replaceObjectAtIndex:_indexRow withObject:adc];
                            
                            _dataArr = sad;
                            //替换数组
                            
                            }
                            _datar = [_dataArr safeObjectAtIndex:indexPath.row-2];
                            
                            NSString *cc = [_datar objectForKey:layoutModel.fieldname];
                            
                            
                            label.text =cc;
                            
                           
                            _firstindex=1;
                        }
                        [self savetoarray];
                    }
                    
                    
                    

                    
                    
                    
                    
                                        NSLog(@"_datar====%@",_datar);
                    NSLog(@"%@",label.text);
                    
                    NSLog(@"_datar====%@",_datar);
                    NSLog(@"%@",label.text);
                    
                    
                    if (self.editstart==NO||self.isstrart==NO) {
                      
                        if (_firstindex==1) {
                            
                            [self readtoarray];
                            
                             _datar = [_dataArr safeObjectAtIndex:indexPath.row-2];
                            
                        }else
                        {
                          
                        _datar = [_dataArr safeObjectAtIndex:indexPath.row-2];
                        label.text = [_datar objectForKey:layoutModel.fieldname];
                           
                        }
                       
                    }
                 
                  
                   
                    NSLog(@"%@",label.text);

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
-(void)saveto:(NSMutableDictionary *)save
{
    NSDictionary *dic =@{@"sda":save};
    [dic writeToFile:[self filePath] atomically:YES];
    
}
-(void)readtodate:(NSMutableDictionary *)read
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithContentsOfFile:[self filePath]];
   read= [dic objectForKey:@"sda"];
}
-(NSString *)filePath{
    NSString *documentsPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath =[documentsPath stringByAppendingPathComponent:@"su.txt"];
    NSLog(@"文件夹位置%@",filePath);
    return filePath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
  
    if (indexPath.row==1||indexPath.row==0) {
        return;
    }
    
   
        
 

    
    AppDelegate *app =[UIApplication sharedApplication].delegate;
   

    
        
     _indexRow = indexPath.row-2;

    if (self.isstrart ==NO) {
        
        app.dict = _datar;
    }
    if (self.isstrart ==YES||_firstindex==1) {
        app.dict=_datar;
    
      
    }
   

    MixiViewController *vc =[[MixiViewController alloc] init];
    vc.index = _index;
   
    vc.costatrraylost=self.costLayoutArray;
    vc.costarrdate=_costDataArr;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)readtoarray
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithContentsOfFile:[self fileArray]];
   _dataArr= [dic objectForKey:@"sda"];
}
-(void)savetoarray
{
    NSDictionary *dic =@{@"sda":_dataArr};
    [dic writeToFile:[self filePath] atomically:YES];
}
-(NSString *)fileArray{
    NSString *documentsPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath =[documentsPath stringByAppendingPathComponent:@"arraya.txt"];
    NSLog(@"文件夹位置%@",filePath);
    return filePath;
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
