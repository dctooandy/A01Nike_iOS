//
//  IVUtility.h
//  Hybird_A01
//
//  Created by Levy on 1/9/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IVUtility : NSObject

typedef void(^IVActionHandler)(UIAlertAction *);

/**
 弹出alert
 
 @param titles 按钮的文字数组
 @param handlers 点击事件数组
 @param title 标题
 @param message 信息
 */
+ (void)showAlertWithActionTitles:(NSArray *)titles
                         handlers:(NSArray *)handlers
                            title:(NSString *)title
                          message:(NSString *)message;

/**
 显示提示框, 已经自动切到主线程

 @param message message
 */
+ (void)showToastWithMessage:(NSString *)message;

/**
 绘制单色Image
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 字典转JSON
 */
+ (NSString *)dictionaryToJSONString:(NSDictionary *)dict;
/**
 对象转NSData
 */
+ (NSData *)objectToJSONData:(id)object;
/**
 MD5
 
 @param string 需要md5的字符串
 @return md5后的字符串
 */
+ (NSString *)md5StringFromString:(NSString *)string;
/**
 退出app
 */
+ (void)exitApp;

@end

NS_ASSUME_NONNULL_END
