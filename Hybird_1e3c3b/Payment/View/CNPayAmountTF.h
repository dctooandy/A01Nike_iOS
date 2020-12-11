//
//  CNPayAmountTF.h
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 支付金额控件变化回调
 
 @param text 返回控件内容
 @param isEmpty 值是空值
 */
typedef void (^CNPayAmountTFBlock)(NSString *text, BOOL isEmpty);

@interface CNPayAmountTF : UITextField <UITextFieldDelegate>
@property(nonatomic, copy) CNPayAmountTFBlock editingChanged;
@end
