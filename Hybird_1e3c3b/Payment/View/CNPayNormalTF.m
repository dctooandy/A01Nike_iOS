//
//  CNPayNormalTF.m
//  Hybird_1e3c3b
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
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.placeholder attributes:
    @{NSForegroundColorAttributeName:COLOR_HEX(0x82868F),
                 NSFontAttributeName:self.font
         }];
    self.attributedPlaceholder = attrString;
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"pay_TFDelete"] forState:UIControlStateNormal];
}

@end
