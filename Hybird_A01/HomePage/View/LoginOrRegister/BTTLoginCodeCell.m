//
//  BTTLoginCodeCell.m
//  Hybird_A01
//
//  Created by Domino on 14/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginCodeCell.h"

@interface BTTLoginCodeCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UIButton *showBtn;


@end

@implementation BTTLoginCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 4;
    self.tagLabel.layer.cornerRadius = 2;
}

- (IBAction)showBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = !sender.selected;
}


@end
