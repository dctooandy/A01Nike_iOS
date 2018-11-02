//
//  BTTWCDBManager.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTWCDBManager : NSObject

/**
 * 如果指定用户名的数据库文件不存在,则创建并打开数据库。否则打开指定用户名的数据库。
 */
+ (instancetype)shareDatabaseWithUserid:(NSString *)userName;

/**
 * 创建表和索引(如果该表已经存在，则不会重新创建，WCDB底层已经做了判断)
 * 对于需要增加的字段，只需在定义处添加，并再次执行该函数即可
 */
+ (BOOL)createTableAndIndexesOfName:(NSString *)tableName
                          withClass:(Class<WCTTableCoding>)cls;

/**
 * 获取当前数据库对象
 */
+ (WCTDatabase *)getCurrentDatabase;

/**
 * 损坏修复,WCDB内建了修复工具，以应对数据库损坏，无法使用的情况。开发者需要在数据库未损坏时，对数据库元信息定时进行备份，如下:
 */
+ (void)backupWithCipher:(NSString *)MyBackupPassword;

/**
 * 加密,WCDB提供基于sqlcipher的数据库加密功能，如下：
 */
+ (void)setCipherKey:(NSString *)MyPassword;

/**
 * 由于WCDB支持多线程访问数据库，因此，该接口(close)会等待所有数据库操作都结束后，才会执行该操作，以确保数据库完全关闭。
 */
+ (void)closeCurrentDatabase:(WCTCloseBlock)block;


//-------------------------------CRUD(增删改查)-------------------------------//

//****************************增****************************//

/**
 * 插入单个个对象
 */
+ (BOOL)insertObject:(WCTObject *)object
               into:(NSString *)tableName;

/**
 * 插入多个对象
 */
+ (BOOL)insertObjects:(NSArray<WCTObject *> *)objects
                into:(NSString *)tableName;


/**
 插入更新多个对象
 */
+ (BOOL)insertOrReplaceObjects:(NSArray<WCTObject *> *)objects
                          into:(NSString *)tableName;

//****************************删****************************//

/**
 * 删除表内的所有数据
 */
+ (BOOL)deleteAllObjectsFromTable:(NSString *)tableName;

/**
 * 删除表内的符合条件的数据
 */
//deleteObjectsFromTable:后可组合接 where、orderBy、limit、offset以删除部分数据
+ (BOOL)deleteObjectsFromTable:(NSString *)tableName
                        where:(const WCTCondition &)condition;

//****************************改****************************//

/**
 * 通过object更新某一列的部分数据
 */
+ (BOOL)updateRowsInTable:(NSString *)tableName
              onProperty:(const WCTProperty &)property
              withObject:(WCTObject *)object
                   where:(const WCTCondition &)condition;

/**
 * 通过object更新指定列的部分数据
 */
//className.AllProperties则用于获取类定义的所有字段映射的列表或者{Message.localID, Message.content}
+ (BOOL)updateRowsInTable:(NSString *)tableName
            onProperties:(const WCTPropertyList &)propertyList
              withObject:(WCTObject *)object
                   where:(const WCTCondition &)condition;


/**
 修改table中某个字段的所有数据
 
 @param tableName tableName
 @param property 字段
 @param value 值
 @return 是否成功
 */
+ (BOOL)updateAllRowsInTable:(NSString *)tableName
                  onProperty:(const WCTProperty &)property
                   withValue:(WCTValue *)value;


/**
 修改table中某个字段的符合条件所有数据
 
 @param tableName tableName
 @param property 字段
 @param value 值
 @param condition 条件
 @return 是否成功
 */
+ (BOOL)updateRowsInTable:(NSString *)tableName
               onProperty:(const WCTProperty &)property
                withValue:(WCTValue *)value
                    where:(const WCTCondition &)condition;


/**
 根据条件修改table中某个字段的符合条件所有数据
 
 @param tableName tableName
 @param property 字段
 @param value 值
 @param condition 条件
 @param limit limit description
 @return 是否成功
 */
+ (BOOL)updateRowsInTable:(NSString *)tableName
               onProperty:(const WCTProperty &)property
                withValue:(WCTValue *)value
                    where:(const WCTCondition &)condition
                    limit:(const WCTLimit &)limit;

//****************************查****************************//

/**
 * 取出第一个object
 */

+ (id/* <WCTObject*> */)getFirstObjectsOfClass:(Class)cls
                                    fromTable:(NSString *)tableName;
/**
 * 取出符合条件第一个object
 */

+ (id/* <WCTObject*> */)getFirstObjectsOfClass:(Class)cls
                                    fromTable:(NSString *)tableName
                                        where:(const WCTCondition &)condition;
/**
 * 取出符合条件最后一个object
 */
+ (id/* <WCTObject*> */)getLastObjectsOfClass:(Class)cls
                                   fromTable:(NSString *)tableName
                                       where:(const WCTCondition &)condition;

/**
 取出符合挑一个对象
 
 @param cls 类名
 @param tableName 表名
 @param condition 条件
 @return object
 */
+ (id/* <WCTObject*> */)getOneObjectOfClass:(Class)cls
                                 fromTable:(NSString *)tableName
                                     where:(const WCTCondition &)condition;

/**
 * 取出所有数据，并组合成object
 */
+(NSArray /* <WCTObject*> */ *)getAllObjectsOfClass:(Class)cls
                                          fromTable:(NSString *)tableName;
/**
 * 从数据库中取出一部分数据，并组合成object
 */
+(NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                           where:(const WCTCondition &)condition;
/**
 *从数据库中取出一部分数据，并组合成object
 */
+(NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                         orderBy:(const WCTOrderByList &)orderList;
/**
 *从数据库中取出一部分数据，并组合成object
 */
+(NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                           limit:(const WCTLimit &)limit;

/**
 *从数据库中取出一部分数据，并组合成object
 */
+(NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                          offset:(const WCTOffset &)offset;

/**
 *从数据库中取出一部分数据，并组合成object
 */
+(NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                           where:(const WCTCondition &)condition
                                         orderBy:(const WCTOrderByList &)orderList;

/**
 * 分页查询
 * 场景:翻页查询聊天记录等
 * select * from table limit a offset b
 * 表示从a条数据开始（包括a）往后取b条数据。
 * select * from table where userid = 'zzc' orderby time desc limit 20 offset 0
 */
+(NSArray /* <WCTObject*> */ *)getObjectsOfClass:(Class)cls
                                       fromTable:(NSString *)tableName
                                           where:(const WCTCondition &)condition
                                         orderBy:(const WCTOrderByList &)orderList
                                           limit:(const WCTLimit &)limit
                                          offset:(const WCTOffset &)offset;


/**
 @param tableName 表名称
 @param resultList {Message.createTime.max(), Message.createTime.min()}
 @return 数据对象数组
 */

+ (NSArray /* <WCTObject*> */ *)getObjectsOnResults:(const WCTResultList &)resultList
                                          fromTable:(NSString *)tableName;

/**
 @param tableName 表名称
 @param resultList {Message.createTime.max(), Message.createTime.min()}
 @param condition 查询条件
 @return 数据对象数组
 */
+ (NSArray /* <WCTObject*> */ *)getObjectsOnResults:(const WCTResultList &)resultList
                                          fromTable:(NSString *)tableName
                                              where:(const WCTCondition &)condition;




//----------------------文件操作---------------------//
//WCDB提供了删除数据库、移动数据库、获取数据库占用空间和使用路径的文件操作接口。

/**
 * Remove all database-related files.
 */
+ (BOOL)removeFilesWithError:(WCTError *_Nullable *_Nullable)error;

/**
 * Move all database-related files and some extra files to directory safely.You should call it on a closed database. Otherwise you will get a warning and you may get a corrupted database.
 */
+ (BOOL)moveFilesToDirectory:(NSString *)directory withExtraFiles:(NSArray<NSString *> *)extraFiles andError:(WCTError *_Nullable *_Nullable)error;

/**
 * Paths to all database-related files.
 */
+ (NSArray<NSString *> *)getPaths;

/**
 * Get the space used by the database files
 */
+ (NSUInteger)getFilesSizeWithError:(WCTError *_Nullable *_Nullable)error;


@end

NS_ASSUME_NONNULL_END
