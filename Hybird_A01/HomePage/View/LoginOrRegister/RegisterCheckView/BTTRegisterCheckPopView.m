//
//  BTTRegisterCheckPopView.m
//  Hybird_A01
//
//  Created by Domino on 21/08/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTRegisterCheckPopView.h"

@interface BTTRegisterCheckPopView ()

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;


@end

@implementation BTTRegisterCheckPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.logoutBtn.layer.cornerRadius = 20;
    
}

- (IBAction)cancelClick:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)logoutClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

- (IBAction)registerClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

@end
