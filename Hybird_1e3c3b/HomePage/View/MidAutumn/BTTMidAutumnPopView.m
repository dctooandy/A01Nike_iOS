//
//  BTTMidAutumnPopView.m
//  Hybird_1e3c3b
//
//  Created by Domino on 03/06/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTMidAutumnPopView.h"

@interface BTTMidAutumnPopView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popupHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popupWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtnConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailBtnWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailBtnTop;

@end

@implementation BTTMidAutumnPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (SCREEN_WIDTH == 320) {
        self.popupWidth.constant *= 0.8;
        self.popupHeight.constant *= 0.8;
        self.closeBtnConstant.constant *= 0.8;
        self.detailBtnTop.constant *= 0.85;
        self.detailBtnWidth.constant *= 0.8;
        self.detailBtnHeight.constant *= 0.8;
    }
    
}

- (IBAction)detailBtnClick:(id)sender {
    
}

- (IBAction)closeBtnClick:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
@end
