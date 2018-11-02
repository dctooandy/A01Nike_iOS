//
//  BTTWCDBManager.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTWCDBManager.h"

@interface BTTWCDBManager ()

@property (nonatomic,strong) WCTDatabase *db;

@end

static BTTWCDBManager *wcdb = nil;

@implementation BTTWCDBManager

//如果指定工号的数据库文件不存在，则创建并打开数据库；反之打开指定工号的数据库。
+ (instancetype)shareDatabaseWithUserid:(NSString *)userName {
    if (wcdb == nil) {
        wcdb = [BTTWCDBManager new];
        NSString * dbPath = [PublicMethod createDirectoryWithFileName:@"sqlite" userName:userName];
        NSString * dbName = [NSString stringWithFormat:@"%@.sqlite",userName];
        dbPath = [dbPath stringByAppendingPathComponent:dbName];
        NSLog(@"当前数据库文件路径:%@",dbPath);
        wcdb.db = [[WCTDatabase alloc]initWithPath:dbPath];
        
        /*
         //SQL Execution Monitor 监控所有执行的SQL，该接口可用于调试，确定SQL是否执行正确。
         [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) {
         NSLog(@"SQL: %@", sql);
         }];*/
        
        //所有性能监控都会有少量的性能损坏，请根据需求开启。
#ifdef DEBUG
        //Error Monitor
        [WCTStatistics SetGlobalErrorReport:^(WCTError *error) {
            NSLog(@"[WCDB]%@", error);
        }];
#endif
    }
    return wcdb;
}

//获取当前数据库对象
+ (WCTDatabase *)getCurrentDatabase {
    return wcdb.db;
}

//创建表和索引
+ (BOOL)createTableAndIndexesOfName:(NSString *)tableName withClass:(Class<WCTTableCoding>)cls {
    //    if ([wcdb.db isTableExists:tableName]) {
    //        return YES;
    //    }
    return [wcdb.db createTableAndIndexesOfName:tableName withClass:cls];
}

//损坏修复,WCDB内建了修复工具，以应对数据库损坏，无法使用的情况。开发者需要在数据库未损坏时，对数据库元信息定时进行备份，如下:

+ (void)backupWithCipher:(NSString *)MyBackupPassword {
    NSData *backupPassword = [MyBackupPassword dataUsingEncoding:NSASCIIStringEncoding];
    [wcdb.db backupWithCipher:backupPassword];
}

//加密,WCDB提供基于sqlcipher的数据库加密功能，如下：
+ (void)setCipherKey:(NSString *)MyPassword {
    NSData *password = [MyPassword dataUsingEncoding:NSASCIIStringEncoding];
    [wcdb.db setCipherKey:password];
}

//由于WCDB支持多线程访问数据库，因此，该接口(close)会等待所有数据库操作都结束后，才会执行该操作，以确保数据库完全关闭。
+ (void)closeCurrentDatabase:(WCTCloseBlock)block {
    [wcdb.db close:^{
        wcdb = nil;
        //如：文件操作不是一个原子操作。若一个线程正在操作数据库，而另一个线程进行移动数据库文件，可能导致数据库损坏。因此，文件操作的最佳实践是确保数据库已关闭。
        block();
    }];
}

//-------------------------------CRUD(增删改查)--------------------------------//

//增
+ (BOOL)insertObject:(WCTObject *)object
               into:(NSString *)tableName {
    return [wcdb.db insertObject:object into:tableName];
}

+ (BOOL)insertObjects:(NSArray<WCTObject *> *)objects
                into:(NSString *)tableName {
    return [wcdb.db insertObjects:objects into:tableName];
}

+ (BOOL)insertOrReplaceObjects:(NSArray<WCTObject *> *)objects
                          into:(NSString *)tableName {
    return [wcdb.db insertOrReplaceObjects:objects into:tableName];
}

//删
+ (BOOL)deleteAllObjectsFromTable:(NSString *)tableName {
    return [wcdb.db deleteAllObjectsFromTable:tableName];
}

+ (BOOL)deleteObjectsFromTable:(NSString *)tableName
                        where:(const WCTCondition &)condition {
    return [wcdb.db deleteObjectsFromTable:tableName where:condition];
}

//改
+ (BOOL)updateRowsInTable:(NSString *)tableName
              onProperty:(const WCTProperty &)property
              withObject:(WCTObject *)object
                   where:(const WCTCondition &)condition {
    return [wcdb.db updateRowsInTable:tableName onProperty:property withObject:object where:condition];
}

+ (BOOL)updateRowsInTable:(NSString *)tableName
            onProperties:(const WCTPropertyList &)propertyList
              withObject:(WCTObject *)object
                   where:(const WCTCondition &)condition {
    return [wcdb.db updateRowsInTable:tableName onProperties:propertyList withObject:object where:condition];
}

+ (BOOL)updateAllRowsInTable:(NSString *)tableName
                  onProperty:(const WCTProperty &)property
                   withValue:(WCTValue *)value {
    return [wcdb.db updateAllRowsInTable:tableName onProperty:property withValue:value];
}

+ (BOOL)updateRowsInTable:(NSString *)tableName
               onProperty:(const WCTProperty &)property
                withValue:(WCTValue *)value
                    where:(const WCTCondition &)condition {
    return [wcdb.db updateRowsInTable:tableName onProperty:property withValue:value where:condition];
}

+ (BOOL)updateRowsInTable:(NSString *)tableName
               onProperty:(const WCTProperty &)property
                withValue:(WCTValue *)value
                    where:(const WCTCondition &)condition
                    limit:(const WCTLimit &)limit {
    return [wcdb.db updateRowsInTable:tableName onProperty:property withValue:value where:condition limit:limit];
}

//查

+ (id/* <WCTObject*> */)getFirstObjectsOfClass:(Class)cls
                                    fromTable:(NSString *)tableName {
    return [[wcdb.db getAllObjectsOfClass:cls fromTable:tableName] firstObject];
}

+ (id/* <WCTObject*> */)getFirstObjectsOfClass:(Class)cls
                                    fromTable:(NSString *)tableName
                                        where:(const WCTCondition &)condition {
    return [[wcdb.db getObjectsOfClass:cls fromTable:tableName where:condition] firstObject];
}

+ (id/* <WCTObject*> */)getLastObjectsOfClass:(Class)cls
                                   fromTable:(NSString *)tableName
                                       where:(const WCTCondition &)condition {
    return [[wcdb.db getObjectsOfClass:cls fromTable:tableName where:condition] lastObject];
}

+ (id/* <WCTObject*> */)getOneObjectOfClass:(Class)cls
                                 fromTable:(NSString *)tableName
                                     where:(const WCTCondition &)condition {
    return [wcdb.db getOneObjectOfClass:cls fromTable:tableName where:condition];
}


+ (NSArray /* <WCTObject*> */ *)getAllObjectsOfClass:(Class)cls
                                          fromTable:(NSString *)tableName
{
    return [wcdb.db getAllObjectsOfClass:cls fromTable:tableName];
}

+ (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                           where:(const WCTCondition &)condition
{
    return [wcdb.db getObjectsOfClass:cls fromTable:tableName where:condition];
}

+ (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                         orderBy:(const WCTOrderByList &)orderList
{
    return [wcdb.db getObjectsOfClass:cls fromTable:tableName orderBy:orderList];
}

+ (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                           limit:(const WCTLimit &)limit
{
    return [wcdb.db getObjectsOfClass:cls fromTable:tableName limit:limit];
}

+ (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                          offset:(const WCTOffset &)offset
{
    return [wcdb.db getObjectsOfClass:cls fromTable:tableName offset:offset];
}

+ (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                           where:(const WCTCondition &)condition
                                         orderBy:(const WCTOrderByList &)orderList
{
    return [wcdb.db getObjectsOfClass:cls fromTable:tableName where:condition orderBy:orderList];
}

/**
 * 分页查询
 * 场景:翻页查询聊天记录等
 * select * from table limit a offset b
 * offset:偏移量 limit:size
 * select * from table where userid = 'zzc' orderby time desc limit 20 offset 0
 */
+ (NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                           where:(const WCTCondition &)condition
                                         orderBy:(const WCTOrderByList &)orderList
                                           limit:(const WCTLimit &)limit
                                          offset:(const WCTOffset &)offset {
    return [wcdb.db getObjectsOfClass:cls fromTable:tableName where:condition orderBy:orderList limit:limit offset:offset];
}

/**
 @param tableName 表名称
 @param resultList {Message.createTime.max(), Message.createTime.min()}
 @return 数据对象数组
 */

+ (NSArray /* <WCTObject*> */ *)getObjectsOnResults:(const WCTResultList &)resultList
                                          fromTable:(NSString *)tableName {
    return [wcdb.db getAllObjectsOnResults:resultList fromTable:tableName];
}

/**
 @param tableName 表名称
 @param resultList {Message.createTime.max(), Message.createTime.min()}
 @param condition 查询条件
 @return 数据对象数组
 */
+ (NSArray /* <WCTObject*> */ *)getObjectsOnResults:(const WCTResultList &)resultList
                                          fromTable:(NSString *)tableName
                                              where:(const WCTCondition &)condition {
    return [wcdb.db getObjectsOnResults:resultList fromTable:tableName where:condition];
}

//-------------------------------文件操作--------------------------------//

+ (BOOL)removeFilesWithError:(WCTError *_Nullable *_Nullable)error {
    return [wcdb.db removeFilesWithError:error];
}

+ (BOOL)moveFilesToDirectory:(NSString *)directory
              withExtraFiles:(NSArray<NSString *> *)extraFiles
                    andError:(WCTError *_Nullable *_Nullable)error {
    return [wcdb.db moveFilesToDirectory:directory withExtraFiles:extraFiles andError:error];
}

+ (NSArray<NSString *> *)getPaths {
    return [wcdb.db getPaths];
}

+ (NSUInteger)getFilesSizeWithError:(WCTError *_Nullable *_Nullable)error {
    return [wcdb.db getFilesSizeWithError:error];
}


@end
