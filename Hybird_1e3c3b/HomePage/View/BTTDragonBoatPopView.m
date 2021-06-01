//
//  BTTDragonBoatPopView.m
//  Hybird_1e3c3b
//
//  Created by Andy on 6/1/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTDragonBoatPopView.h"

@interface BTTDragonBoatPopView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *oldMemberSunTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabTopLayout;
@end

@implementation BTTDragonBoatPopView

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
