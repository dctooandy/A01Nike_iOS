//
//  BTTRegisterQuickManualCell.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTRegisterQuickManualCell.h"

@interface BTTRegisterQuickManualCell ()

@property (weak, nonatomic) IBOutlet UIButton *normalBtn;

@property (weak, nonatomic) IBOutlet UIButton *quickBtn;

@property (weak, nonatomic) IBOutlet UIButton *autoBtn;

@property (weak, nonatomic) IBOutlet UIButton *manualBtn;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;


@end

@implementation BTTRegisterQuickManualCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.tagLabel.layer.cornerRadius = 2;
}


- (IBAction)normalBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)quickBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)autoBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)manualBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}



@end
