//
//  Bianjito.h
//  Thinkape-iOS
//
//  Created by admin on 15/12/29.
//  Copyright © 2015年 TIXA. All rights reserved.
//


#import "ParentsViewController.h"

@interface Bianjito : ParentsViewController
@property (nonatomic,strong) NSMutableArray *costLayoutArray;
@property (nonatomic,strong) NSMutableArray *costDataArr;
@property(nonatomic,strong)NSMutableArray *updateimage;
@property(nonatomic,strong)NSMutableArray *imagedate;

@property (nonatomic,assign) int index;
//wo
@property(nonatomic,strong) NSString * selectType;
@property(nonatomic,strong)NSMutableDictionary * acceptAddDict;//新增明细接收的字典
@property(nonatomic,strong)NSMutableDictionary * acceptEditorDict;//编辑明细接受的字典

@property(nonatomic,strong)NSMutableArray * arrayDict;

@end
