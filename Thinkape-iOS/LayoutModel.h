//
//  LayoutModel.h
//  Thinkape-iOS
//
//  Created by tixa on 15/5/27.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutModel : NSObject

@property (nonatomic,strong) NSString *fieldname;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *ishide;
@property(nonatomic,assign) BOOL ismust;
@property(nonatomic,strong)NSString *datasource;
@property(nonatomic,strong)NSString *mobilequeryspan;
@property(nonatomic,strong)NSString *isreadonly;
@property(nonatomic,strong)NSString *sqldatatype;
@property(nonatomic,strong)NSString *issingle;
@property(nonatomic,strong)NSString *mobiledefaultvalue;
@property(nonatomic,strong)NSString *mobileeventbyauto;
@property(nonatomic,strong)NSString *mobiledatasourcewhere;
//实验用
@property(nonatomic,strong)NSString *idfortext;
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)NSString *idstr;
@property(nonatomic,strong)NSString *nameStr;
@property(nonatomic,strong)NSString *dataver;
@end
