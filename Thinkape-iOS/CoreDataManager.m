//
//  CoreDataManager.m
//  Thinkape-iOS
//
//  Created by tixa on 15/6/8.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "CoreDataManager.h"

static CoreDataManager *manager = nil;

@interface CoreDataManager ()

@property (nonatomic,strong) NSManagedObjectContext *context;

@end

@implementation CoreDataManager


+ (CoreDataManager *)shareManager{
    static dispatch_once_t p;
    dispatch_once(&p, ^{
        manager = [[CoreDataManager alloc] init];

    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        // 从应用程序包中加载模型文件
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        // 传入模型对象，初始化NSPersistentStoreCoordinator
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model] ;
        // 构建SQLite数据库文件的路径
        NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"layoutKinds.data"]];
        // 添加持久化存储库，这里使用SQLite作为存储库
        NSError *error = nil;
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
        if (store == nil) { // 直接抛异常
            [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        }
        // 初始化上下文，设置persistentStoreCoordinator属性

        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
    }
    return self;
}


- (void)saveDataForTable:(NSString *)objectName model:(NSDictionary *)dic sql:(NSString *)key{
   
    NSArray *arr = [self search:objectName sql:key context:self.context];
    // 如果元素不重复
    if (arr.count == 0) {
        // 传入上下文，创建一个模型实体对象
        NSManagedObject *model = [NSEntityDescription insertNewObjectForEntityForName:objectName inManagedObjectContext:self.context];
        for (NSString *str in [dic allKeys]) {
            // 设置Person的简单属性
            [model setValue:[dic objectForKey:str] forKey:str];
        }
        // 利用上下文对象，将数据同步到持久化存储库
        NSError *error = nil;
        if (arr.count != 0) {
            return;
        }
        BOOL success = [self.context save:&error];
        if (!success) {
            [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        }
    }


}

- (void)insertDataForTable:(NSString *)tableName data:(NSDictionary *)dic{
    
    NSManagedObject *model = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:_context];
    for (NSString *str in [dic allKeys]) {
        [model setValue:[dic objectForKey:str] forKey:str];
    }
    // 利用上下文对象，将数据同步到持久化存储库
    NSError *error = nil;
    BOOL success = [_context save:&error];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }
}


- (NSArray * )search:(NSString *)tableName sql:(NSString *)sql context:(NSManagedObjectContext *)context{
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    if ([tableName isEqualToString:@"KindItem"]) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sort];
    }
    //设置条件过滤(搜索name中包含字符串"Itcast-1"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*Itcast-1*)
    if (sql.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
        request.predicate = predicate;
    }
    // 执行请求
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];

    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
  
    return arr;
}

- (NSArray *)fetchDataForTable:(NSString *)tableName sql:(NSString *)sql{
    NSArray *arr = [NSArray arrayWithArray:[self search:tableName sql:sql context:_context]];
    return arr;
}

- (void)updateModelForTable:(NSString *)tableName sql:(NSString *)key data:(NSDictionary *)dic{
//    [_context reset];
    // 先查找需要更新的元素 然后替换
    NSManagedObject *model = [[self search:tableName sql:key context:_context] lastObject];
    if (model == nil) {
        [self insertDataForTable:tableName data:dic];
    }
    else
    {
        for (NSString *str in [dic allKeys]) {
            [model setValue:[dic objectForKey:str] forKey:str];
        }
        NSError *error = nil;
        BOOL success = [_context save:&error];
        if (!success) {
            [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        }
    }
}

- (NSString *)searchDataVer:(NSString *)dataSource{
    NSManagedObject *obj = [[self search:@"KindsLayout" sql:dataSource context:_context] lastObject];
    return [obj valueForKey:@"dataVer"];
}

- (BOOL)deleateDataForTabel:(NSString *)tableName sql:(NSString *)sql{
    NSArray *arr = [self fetchDataForTable:tableName sql:nil];
    for (NSManagedObject * obj in arr) {
        [_context deleteObject:obj];
    }
    NSError *error = nil;
    BOOL success = [_context save:&error];
    return success;
}

@end
