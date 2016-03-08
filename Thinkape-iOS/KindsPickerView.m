//
//  KindsPickerView.m
//  Thinkape-iOS
//
//  Created by tixa on 15/6/17.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "KindsPickerView.h"
#import "KindsModel.h"
#import "BFKit.h"
#import "AppDelegate.h"


@interface KindsPickerView()
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) KindsModel *selectModel;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@end

@implementation KindsPickerView
{
    NSArray *titleArr;
    NSInteger _index;
    NSInteger _colum_Two;
    BOOL isSearch;
}


- (void)awakeFromNib{
    isSearch = NO;
    titleArr = [NSArray arrayWithObjects:@"申请",@"报销",@"借款", nil];
    self.searchArray = [[NSMutableArray alloc] init];
    self.selectModel = [[KindsModel alloc] init];
    if (!self.pickerView) {
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH, 162)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];
    }
    
}

- (void)setDataArray:(NSArray *)dataArray{
    if (self.dataArray != dataArray) {
       _dataArray = dataArray;
        _selectModel = [[_dataArray firstObject] firstObject];
        [self.pickerView reloadAllComponents];
        for (int i = 0; i < 2; i ++) {
            NSInteger row = [self.pickerView selectedRowInComponent:i];
            [self resetColor:row component:i];
        }

    }
}

#pragma mark - PickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return titleArr.count;
    }
    else
    {
        if (!isSearch) {
            NSArray *arr = [self.dataArray safeObjectAtIndex:_index];
            if (arr) {
                return arr.count;
            }
            else
                return 0;
        }
        else
            return _searchArray.count;
        
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)vie{
    
    UILabel *label = [[UILabel alloc] init];
    if (component == 0) {
        [label setFrame:CGRectMake(0, 0, 40, 15)];
        label.text = [titleArr safeObjectAtIndex:row];
        
        
        //wo
        AppDelegate *app=[UIApplication sharedApplication ].delegate;
        NSLog(@"传值%@",app.zhuanStr);
        
        app.zhuanStr=label.text;
    }
    else{
        [label setFrame:CGRectMake(0, 0, 160, 15)];
        KindsModel *model;
        if (!isSearch) {
            NSArray *arr = [self.dataArray safeObjectAtIndex:_index];
            model = [arr safeObjectAtIndex:row];
        }
        else
            model = [self.searchArray safeObjectAtIndex:row];
        
        label.text = model.cname;
    }
    
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"333333"];
    return label;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) {
        return 100;
    }
    else
        return 140;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        _index = row;
        _colum_Two = 0;
        [self.pickerView reloadComponent:1];
        [self resetColor:_colum_Two component:1];
    }
    else if (component ==1){
        _colum_Two = row;
        [self resetColor:row component:component];
    }
}

- (void)resetColor:(NSInteger )row component:(NSInteger )component{
    NSArray *arr = [self.dataArray safeObjectAtIndex:_index];
    if (!isSearch) {
       // NSArray *arr = [self.dataArray safeObjectAtIndex:row];
        _selectModel = [arr safeObjectAtIndex:row];
    }
    else
        _selectModel = [self.searchArray safeObjectAtIndex:row];
    
    NSLog(@"_selectModel :%@",_selectModel);
    UILabel *label = (UILabel *)[self.pickerView viewForRow:row forComponent:component];
    label.textColor = [UIColor colorWithRed:0.231 green:0.482 blue:0.824 alpha:1.000];
}

#pragma mark - Custom Methods

- (void)searchItem:(NSString *)searchKey{
    
    NSArray *items = [self.dataArray safeObjectAtIndex:_index];
    [self.searchArray removeAllObjects];
    for (KindsModel *model in items) {
        NSRange range = [model.cname rangeOfString:searchKey];
        if (range.length != 0) {
            [self.searchArray addObject:model];
        }
    }
    [self.pickerView reloadComponent:1];
    [self resetColor:0 component:1];
    
}

#pragma mark - BtnAction

- (IBAction)doSearch:(id)sender {
    [self searchItem];
}

- (IBAction)selectItem:(UIButton *)sender {
    self.transform = CGAffineTransformMakeTranslation(0, 799);
    if(self.selectItemCallBack){
        self.selectItemCallBack(_selectModel);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self searchItem];
    return YES;
}

- (void)searchItem{
    if (self.searchText.text.length >0) {
        isSearch = YES;
        [self searchItem:self.searchText.text];
    }
    else
    {
        isSearch = NO;
        [self.pickerView reloadComponent:1];
        [self resetColor:_colum_Two component:1];
    }
    [_searchText resignFirstResponder];
}

@end
