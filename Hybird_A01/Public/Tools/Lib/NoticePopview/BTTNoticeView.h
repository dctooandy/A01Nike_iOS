//
//  BTTNoticeView.h
//  Hybird_A01
//
//  Created by Domino on 2018/7/27.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTTNoticeView : UIView



/**
 弹出框显示

 @param message 弹出框消息内容
 @param title 按钮标题
 @param buttonClickedBlock 按钮点击回调
 */
- (void)showAlertWithMessage:(NSString *)message buttonTitle:(NSString *)title buttonClickedBlock:(void(^)(void))buttonClickedBlock;

// 
- (void)bringNoticeViewToFront;

@end
