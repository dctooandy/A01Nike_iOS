//
//  CNPayNormalTF.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/28.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayNormalTF.h"
#import "CNPayConstant.h"

@implementation CNPayNormalTF

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
    self.font = [UIFont systemFontOfSize:14];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textAlignment = NSTextAlignmentRight;
    self.textColor = COLOR_HEX(0x82868F);
    [self setValue:self.textColor forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:self.textColor forKeyPath:@"_placeholderLabel.textColor"];
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"pay_TFDelete"] forState:UIControlStateNormal];
}

@end
