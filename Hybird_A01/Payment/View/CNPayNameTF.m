//
//  CNPayNameTF.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/18.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayNameTF.h"
#import "CNPayConstant.h"

@implementation CNPayNameTF


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.placeholder = @"请输入真实姓名";
    self.font = [UIFont systemFontOfSize:13];
    self.textColor = COLOR_HEX(0xDBBD85);
    self.textAlignment = NSTextAlignmentRight;
    [self setValue:COLOR_HEX(0x82868F) forKeyPath:@"_placeholderLabel.textColor"];
    self.delegate = self;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.keyboardType = UIKeyboardTypeDefault;
    [self addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self setValue:self.textColor forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"pay_TFDelete"] forState:UIControlStateNormal];
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    NSString *toBeString = textField.text;
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制，有高亮选择的字符串，则暂不对文字进行统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 当输入符合规则和退格键时允许改变输入框
    if ([self isMacthRegex:string] || [string isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

/// 大小写字母、中文正则判断（包括空格 -·.。）
- (BOOL)isMacthRegex:(NSString *)str {
    NSString *regex = @"^[➋➌➍➎➏➐➑➒a-zA-Z\u4E00-\u9FA5\\s-·.。]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}

/// 获得 50 长度的字符
- (NSString *)getSubString:(NSString*)string {
    NSInteger maxLength = 50;
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [string dataUsingEncoding:encoding];
    NSInteger length = [data length];
    if (length > maxLength) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, maxLength)];
        //【注意】：当截取maxLength长度字符时把中文字符截断返回的content会是nil
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, maxLength - 1)];
            content = [[NSString alloc] initWithData:data1 encoding:encoding];
        }
        return content;
    }
    return nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    !_endedHandler ?: _endedHandler();
}

@end
