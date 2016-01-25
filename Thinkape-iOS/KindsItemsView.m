//
//  KindsItemsView.m
//  Thinkape-iOS
//
//  Created by tixa on 15/6/8.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "KindsItemsView.h"
#import "MacroDefinition.h"
#import "KindsItemModel.h"
#import "BFKit.h"

@interface KindsItemsView()
@property (weak, nonatomic) IBOutlet UITableView *itemView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchText;
@property (nonatomic , strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *searchArr;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic, assign,getter=isSearch) BOOL search;
@end

@implementation KindsItemsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    self.itemView.tableFooterView = [[UIView alloc] init];
    self.searchArr = [[NSMutableArray alloc] init];
//    self.searchText.backgroundImage = [UIImage imageNamed:@"search_bg_blank"];
    self.search = NO;
    self.selectArr = [[NSMutableArray alloc] init];
}

- (IBAction)closeAciton:(id)sender {
    if (self.selectArr.count > 0) {
        if ([self.delegate respondsToSelector:@selector(selectItemArray:view:)]) {
            [self.delegate selectItemArray:self.selectArr view:self];
        }
    }
    [self closed];
}

- (IBAction)searchItem:(id)sender {
    [self search:self.searchText.text];
    [self.searchText resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self search:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)search:(NSString *)searchKey{
    self.search = searchKey.length > 0 ? YES : NO;
    [self.searchArr removeAllObjects];
    for (KindsItemModel *model in self.dataArray) {
        NSRange range = [model.name rangeOfString:searchKey];
        if (range.length != 0) {
            [self.searchArr addObject:model];
        }
    }

    [self.itemView reloadData];
    
}

- (void)closed{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.transform =CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT / 2.0 + CGRectGetHeight(self.frame) / 2.0f);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)setDataArray:(NSArray *)dataArray{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }
    [self.itemView reloadData];
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isSearch ? _searchArr.count : _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    KindsItemModel *model = self.isSearch ? [self.searchArr safeObjectAtIndex:indexPath.row] : [self.dataArray safeObjectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.textLabel.text = model.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KindsItemModel *model;
    if (self.isSingl) {
        if (self.isSearch) {
            model = [self.searchArr safeObjectAtIndex:indexPath.row];
        }else{
            model = [self.dataArray safeObjectAtIndex:indexPath.row];
        }
   //wo
        KindsItemsView *view=[[KindsItemsView alloc]init];
        
        NSLog(@"啦啦%@=%@=%ld",model.name ,model.ID,view.tag);
        [self.delegate selectItem:model.name ID:model.ID view:self];
    }
    else
    {
        if (self.isSearch) {
            model = [self.searchArr safeObjectAtIndex:indexPath.row];
        }else{
            model = [self.dataArray safeObjectAtIndex:indexPath.row];
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectArr removeObject:model];
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectArr addObject:model];
        }
        if ([self.closeBtn.currentTitle isEqualToString:@"关闭"]) {
            [self.closeBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
    }

}

@end
