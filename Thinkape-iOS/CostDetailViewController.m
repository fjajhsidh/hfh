//
//  CostDetailViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/5/6.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "CostDetailViewController.h"
#import "CostLayoutModel.h"
#import "LayoutModel.h"
#import "BillsDetailViewController.h"
#import "BianJiViewController.h"
@interface CostDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewWidth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSLayoutConstraint *tableViewWidth2;
@end

@implementation CostDetailViewController

{
    CGFloat width;
    CGFloat itemWidth;
    CGFloat speace;
    CGFloat width2;
    CGFloat itemWidth2;
    CGFloat speace2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"明 细";
    
    itemWidth = 80;
    speace = 20;
    itemWidth2 = 80;
    speace2 = 20;
//    self.costDataArr=self.costDataArr2;
//    self.costLayoutArray=self.costLayoutArray2;
    if (self.selecter==0) {
        [self itemLength];
        [self layoutScroll];
    }
    
    if (self.selecter==1) {
        
        [self itemLength2];
        [self layoutScroll2];
    }
    
 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutScroll{
    
   UIScrollView  *bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80)];
    for (int i = 0; i < _costLayoutArray.count; i++) {
        CostLayoutModel *model = [_costLayoutArray safeObjectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(60 + 35), 10, 57, 57)];
        
        [btn addTarget:self action:@selector(costDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        
//        if (model.photopath==nil) {
        
//            [btn setBackgroundImage:[UIImage imageNamed:@"ab_nav_bg.png"] forState:UIControlStateNormal];
//
//        }
//        
//       [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.photopath] forState:UIControlStateNormal];
      
//        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.photopath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ab_nav_bg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if ( imageURL == nil) {
//                  image =[UIImage imageNamed:@"ab_nav_bg.png"];
//            }
//           
//          
//            
//            
//        }];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.photopath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ab_nav_bg.png"]];
        
        
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
- (void)layoutScroll2{
    
    UIScrollView  *bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80)];
    for (int i = 0; i < _costLayoutArray2.count; i++) {
        CostLayoutModel *model = [_costLayoutArray2 safeObjectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(60 + 35), 10, 57, 57)];
        [btn addTarget:self action:@selector(costDetail2:) forControlEvents:UIControlEventTouchUpInside];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.photopath] forState:UIControlStateNormal];
        btn.tag = i;
        [bottomScroll addSubview:btn];
        
        UILabel *totleMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, 57, 15)];
        totleMoney.textColor = [UIColor whiteColor];
        totleMoney.font = [UIFont systemFontOfSize:15];
        totleMoney.text = model.TotalMoney;
        totleMoney.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:totleMoney];
    }
    [bottomScroll setContentSize:CGSizeMake(95*_costLayoutArray2.count, 80)];
    bottomScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bottomScroll];
}
- (void)costDetail:(UIButton *)btn{
    
    _index = btn.tag;

    [self itemLength];
    [self.tableView reloadData];
    
}
- (void)costDetail2:(UIButton *)btn{
    
    _index2 = btn.tag;
    
    [self itemLength2];
    [self.tableView reloadData];
    
}
- (void)itemLength{
    if (self.selecter==0) {
        CostLayoutModel *model = [self.costLayoutArray safeObjectAtIndex:_index];
        width = (itemWidth + speace) * model.fileds.count + 40 + speace;
        self.tableViewWidth.constant = width + 24;
    }
    
}
- (void)itemLength2{
    if (self.selecter==1) {
        CostLayoutModel *model = [self.costLayoutArray2 safeObjectAtIndex:_index2];
        width2 = (itemWidth2 + speace2) * model.fileds.count + 40 + speace2;
        self.tableViewWidth=self.tableViewWidth2;
        self.tableViewWidth2.constant = width2 + 24;
    }

    }
   
#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selecter==0) {
        NSArray *array2 = [_costDataArr safeObjectAtIndex:_index ];
        return array2.count + 2;
    }
//    if (self.selecter==1) {
//        NSArray *array = [_costDataArr2 safeObjectAtIndex:_index2];
//        return array.count + 2;
//    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.selecter==0) {
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
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, width, 30)];
            bgView.tag = 304;
            for (int i = 0; i < model.fileds.count + 1; i++) {
                UILabel *label;
                if (i == 0 ) {
                    label = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 40, 15)];
                }
                else
                    label = [[UILabel alloc] initWithFrame:CGRectMake(40+speace + (itemWidth + speace) * (i-1), 8, itemWidth, 15)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:13];
                label.tag = i;
                label.textColor = [UIColor colorWithHexString:@"333333"];
                [bgView addSubview:label];
                
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
                }
                else
                {
                    if (label.tag == 0) {
                        label.text = [NSString stringWithFormat:@"%d",indexPath.row - 1];
                    }
                    else{
                        LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:label.tag - 1];
                        NSArray *dataArr = [_costDataArr safeObjectAtIndex:_index ];
                        NSDictionary *dataDic = [dataArr safeObjectAtIndex:indexPath.row - 2];
                        label.text = [dataDic objectForKey:layoutModel.fieldname];
                    }
                }
                
            }
            [cell.contentView addSubview:bgView];
            
            if ((indexPath.row - 2) % 2 == 0)
                bgView.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
            else
                bgView.backgroundColor = [UIColor whiteColor];
        }
            return cell;
       
            
        
    }
    
    if (self.selecter==1) {
        
        CostLayoutModel *model = [self.costLayoutArray2 safeObjectAtIndex:_index2];
        NSString *cellid = @"cell2";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.backgroundColor = [UIColor clearColor];
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        if (indexPath.row == 0) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 17, width2, 30)];
            bgView.backgroundColor = [UIColor colorWithRed:0.275 green:0.557 blue:0.914 alpha:1.000];
            [cell.contentView addSubview:bgView];
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(13, 7.5, width2, 15)];
            title.font = [UIFont systemFontOfSize:15];
            title.text = model.name;
            title.textColor = [UIColor whiteColor];
            [bgView addSubview:title];
        }
        else{
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, width2, 30)];
            bgView.tag = 304;
            for (int i = 0; i < model.fileds.count + 1; i++) {
                UILabel *label;
                if (i == 0 ) {
                    label = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 40, 15)];
                }
                else
                    label = [[UILabel alloc] initWithFrame:CGRectMake(40+speace2 + (itemWidth2 + speace2) * (i-1), 8, itemWidth2, 15)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:13];
                label.tag = i;
                label.textColor = [UIColor colorWithHexString:@"333333"];
                [bgView addSubview:label];
                
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
                }
                else
                {
                    if (label.tag == 0) {
                        label.text = [NSString stringWithFormat:@"%d",indexPath.row - 1];
                    }
                    else{
                        LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:label.tag - 1];
                        NSArray *dataArr = [_costDataArr2 safeObjectAtIndex:_index2 ];
                        NSDictionary *dataDic = [dataArr safeObjectAtIndex:indexPath.row - 2];
                        label.text = [dataDic objectForKey:layoutModel.fieldname];
                    }
                }
                
            }
            [cell.contentView addSubview:bgView];
            
            if ((indexPath.row - 2) % 2 == 0)
                bgView.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
            else
                bgView.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }
        return nil;
   
    
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 47.0f;
    }
    else
        return 30.0f;
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

