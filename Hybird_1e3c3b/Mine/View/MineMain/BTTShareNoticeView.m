//
//  BTTShareNoticeView.m
//  Hybird_1e3c3b
//
//  Created by Domino on 29/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTShareNoticeView.h"

@interface BTTShareNoticeView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareIconRightConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareIconTopConstants;

@end

@implementation BTTShareNoticeView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


- (IBAction)detailBtnClick:(UIButton *)sender {
//    recommendFriends.htm
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

@end
