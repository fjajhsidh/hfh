//
//  KindsItemsView.h
//  Thinkape-iOS
//
//  Created by tixa on 15/6/8.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KindsItemsView;
@protocol KindsItemsViewDelegate <NSObject>

- (void)selectItem:(NSString *)name ID:(NSString *)ID view:(KindsItemsView *)view;
- (void)selectItemArray:(NSArray *)arr view:(KindsItemsView *)view;
@end

@interface KindsItemsView : UIView <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) void (^selectItem)(NSString *name ,NSString *ID);



@property (nonatomic,weak) id <KindsItemsViewDelegate> delegate;
@property (nonatomic , assign) BOOL isSingl;

- (void)closed;

@end
