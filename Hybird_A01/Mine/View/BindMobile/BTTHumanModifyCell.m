//
//  BTTHumanModifyCell.m
//  Hybird_A01
//
//  Created by Jairo on 31/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTHumanModifyCell.h"

@interface BTTHumanModifyCell()
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@end

@implementation BTTHumanModifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.modifyBtn.layer.cornerRadius = 8.0;
    self.modifyBtn.clipsToBounds = true;
}

-(void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    [self.modifyBtn setTitle:_btnTitle forState:UIControlStateNormal];
}

-(void)setBtnTag:(NSInteger)btnTag {
    _btnTag = btnTag;
    self.modifyBtn.tag = _btnTag;
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
