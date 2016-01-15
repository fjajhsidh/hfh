//
//  KindsLayoutModel.h
//  Thinkape-iOS
//
//  Created by tixa on 15/6/8.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KindsLayoutModel : NSObject

@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) NSString *datasource;
@property (nonatomic,strong) NSString *MobileQuerySpan;
@property (nonatomic,strong) NSString *DataVer;
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *Value;
@property (nonatomic,strong) NSString *Text;
@property (nonatomic,strong) NSString *SqlDataType;
@property (nonatomic , assign) BOOL IsMust;
@property (nonatomic , assign) BOOL IsSingle;

@end
