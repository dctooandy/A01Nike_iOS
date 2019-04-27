//
//  BTTChangePwdBtnsCell.m
//  Hybird_A01
//
//  Created by Domino on 24/04/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTChangePwdBtnsCell.h"

@interface BTTChangePwdBtnsCell ()

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@end

@implementation BTTChangePwdBtnsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.cancelBtn.layer.cornerRadius = 2;

}


- (IBAction)cancelClick:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)confirmClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}



@end
