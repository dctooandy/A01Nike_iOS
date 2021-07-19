//
//  BTTSevenXiPriHotPopView.m
//  Hybird_1e3c3b
//
//  Created by Andy on 7/19/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTSevenXiPriHotPopView.h"

@interface BTTSevenXiPriHotPopView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *oldMemberSunTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabTopLayout;
@end

@implementation BTTSevenXiPriHotPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (IBAction)closeBtnAction:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)btnAction:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

@end
