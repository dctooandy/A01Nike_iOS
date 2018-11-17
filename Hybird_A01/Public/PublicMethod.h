//
//  PublicMethod.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublicMethod : NSObject

/**
 *获取当前window的根控制器
 */
+ (UIViewController *)getRootViewController;

/**
 *根据控制器名字获得其对于的控制器
 */
+ (UIViewController *)getVCByItsClassName:(NSString *)className;

/**
 *获取当前屏幕显示的控制器
 */
+ (UIViewController *)getCurrentVC;

/**
 *获取当前选中的导航控制器
 */
+ (UINavigationController *)getCurrentNavVC;

/**
 * 获取当前顶层窗口
 */
+ (UIWindow *)getTopWindow;

/**
 获取当前的window
 
 @return 当前的window
 */
+ (UIWindow *)currentWindow;


/*******************字典与字符串互相转换*******************/

/**
 *NSString转JSON
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *JSON转NSString
 */
+(NSString*)dictionaryToJson:(NSDictionary *)dic;


/*******************生成随机数*******************/

/**
 * 生成随机数
 */
+ (NSString *)generateUUID;


/**
 制定路径创建文件

 @param fileName 文件名
 @param userName 登录名
 @return 返回路径
 */
+ (NSString *)createDirectoryWithFileName:(NSString *)fileName userName:(NSString *)userName;


/**
 某个时间和当前时间比较是否超过时间间隔
 @param timeInterval 时间间隔
 @param time 要比较的时间
 @return 比较的结果
 */
+ (BOOL)compareCurrentTimeinterval:(NSInteger)timeInterval compareTime:(NSTimeInterval)time;

+ (NSString *)getPreferredLanguage;

+ (NSData *)dataFromBase64String:(NSString *)base64;

/**
 *  @return 当前时间距1970年的毫秒数
 */

+ (NSString *)timeIntervalSince1970;

//获取日期（date_）对用的元素
+ (int)second:(NSDate *)date_;
+ (int)minute:(NSDate *)date_;
+ (int)hour:(NSDate *)date_;
+ (int)day:(NSDate *)date_;
+ (int)month:(NSDate *)date_;
+ (int)year:(NSDate *)date_;

//判断date_是否和当前日期在指定的范围之内
+ (BOOL)isDateToday:(NSDate *)date_;
+ (BOOL)isDateYesterday:(NSDate *)date_;
+ (BOOL)isDateThisWeek:(NSDate *)date_;
+ (BOOL)isDateThisMonth:(NSDate *)date_;
+ (BOOL)isDateThisYear:(NSDate *)date_;

//判断两个时间是否在指定的范围之内
+ (BOOL)twoDateIsSameYear:(NSDate *)fistDate_ second:(NSDate *)secondDate_;
+ (BOOL)twoDateIsSameMonth:(NSDate *)fistDate_ second:(NSDate *)secondDate_;
+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate_ second:(NSDate *)secondDate_;

// 获取指定日期所在月的天数
+ (NSInteger)numberDaysInMonthOfDate:(NSDate *)date_;
+ (NSDate *)dateByAddingComponents:(NSDate *)date_ offsetComponents:(NSDateComponents *)offsetComponents_;

//获取指定日期所在的月对应的月开始时间和月结束时间
+ (NSDate *)startDateInMonthOfDate:(NSDate *)date_;
+ (NSDate *)endDateInMonthOfDate:(NSDate *)date_;

//判断指定日期是否是本周
- (BOOL)isDateThisWeek:(NSDate *)date;

//当前时间三个月后的时间
+ (NSDate *)returnTheDayAfterThreeMouthWithDate:(NSDate *)date;


+ (UIViewController *)mostFrontViewController;

/*******************判断是否为空字符串*******************/

+ (BOOL)isBlankString:(NSString *)aStr;

+ (NSURL *)createFolderWithName:(NSString *)folderName inDirectory:(NSString *)directory;

+ (NSString*)dataPath;
//检测预留信息是否合法
+ (BOOL)isValidateLeaveMessage:(NSString *)leaveMessage;
//检查真实姓名是否合法
+ (BOOL)checkRealName:(NSString *)realName;
//检查比特币地址是否合法
+ (BOOL)checkBitcoinAddress:(NSString *)btcAddress;
//正则表达式验证手机号码
+ (BOOL)isValidatePhone:(NSString *)phone;
//正则表达式验证邮箱是否合法
+ (BOOL)isValidateEmail:(NSString *)originalEmail;
//正则表达式验证密码是否合法
+ (BOOL)isValidatePwd:(NSString *)originalPwd;


+ (NSString*)getCurrentTimesWithFormat:(NSString *)formatStr;
@end

NS_ASSUME_NONNULL_END
