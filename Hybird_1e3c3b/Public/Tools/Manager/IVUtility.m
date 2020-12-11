//
//  IVUtility.m
//  Hybird_1e3c3b
//
//  Created by Levy on 1/9/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "IVUtility.h"
#import <CommonCrypto/CommonDigest.h>
static UIWindow *ivAlertWindow;
static dispatch_queue_t alertQueue;
static dispatch_semaphore_t alertSemaphore;

@implementation IVUtility

/**
 弹出alert
 
 @param titles 按钮的文字数组
 @param handlers 点击事件数组
 @param title 标题
 @param message 信息
 */
+ (void)showAlertWithActionTitles:(NSArray *)titles handlers:(NSArray *)handlers title:(NSString *)title message:(NSString *)message{
    if (!alertQueue) {
        alertQueue = dispatch_queue_create("com.ivi.alert.queue", DISPATCH_QUEUE_SERIAL);
        alertSemaphore = dispatch_semaphore_create(1);
        ivAlertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        ivAlertWindow.windowLevel = UIWindowLevelAlert + 1;
        ivAlertWindow.rootViewController = [UIViewController new];
    }
    dispatch_async(alertQueue, ^{
        dispatch_semaphore_wait(alertSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertVC =[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            for (int i = 0; i < titles.count; i++) {
                NSString *actionTitle = titles[i];
                IVActionHandler handler = handlers[i];
                IVActionHandler rehandler = ^(UIAlertAction *action) {
                    ivAlertWindow.hidden = YES;
                    dispatch_semaphore_signal(alertSemaphore);
                    handler(action);
                };
                UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:rehandler];
                [alertVC addAction:action];
            }
            
            ivAlertWindow.hidden = NO;
            [ivAlertWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
        });
    });
}

+ (void)showToastWithMessage:(NSString *)message
{
    if ([[NSThread currentThread] isMainThread]) {
        [self showToastMainQueueWithMessage:message];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showToastMainQueueWithMessage:message];
    });
}

+ (void)showToastMainQueueWithMessage:(NSString *)message
{
    UILabel *label = [UILabel new];
    label.text = message;
    label.font = [UIFont systemFontOfSize:15.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.7f];
    CGFloat centerX = [UIScreen mainScreen].bounds.size.width * 0.5;
    CGFloat centerY = [UIScreen mainScreen].bounds.size.height * 0.5;
    CGFloat height = 40.f;
    CGFloat width = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, height)].width;
    label.center = CGPointMake(centerX, centerY);
    label.bounds = CGRectMake(0, 0, width + 10, height);
    label.layer.cornerRadius = 3.f;
    label.layer.masksToBounds = YES;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label.alpha = 0;
        [label removeFromSuperview];
    });
}

/**
 绘制单色背景图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (NSString *)dictionaryToJSONString:(NSDictionary *)dict
{
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.count > 0) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonStr;
    }
    return nil;
}
+ (NSData *)objectToJSONData:(id)object
{
    if (object) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
        return data;
    }
    return nil;
}
+ (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}
+ (void)exitApp
{
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:1.0f animations:^{
        keyWin.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

@end
