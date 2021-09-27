//
//  VIPRightFirstCell.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/12.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "VIPRightFirstCell.h"
#import "GradientImage.h"
@implementation VIPRightFirstCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor clearColor];
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setupButtons];
    [self detectIfLogin];
}
- (void)setupButtons
{
    [self.singupButton.layer setCornerRadius:self.singupButton.frame.size.height/2];
    [self.singupButton.layer setBorderWidth:1];
    [self.singupButton.layer setBorderColor:[UIColor colorWithHexString:@"FFFFFF" alpha:0.5f].CGColor];
    self.singupButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" alpha:0.08f];
    [self.loginButton.layer setCornerRadius:self.loginButton.frame.size.height/2];
    [self.loginButton.layer setBorderWidth:1];
    [self.loginButton.layer setBorderColor:[UIColor colorWithHexString:@"FFFFFF" alpha:0.5f].CGColor];
    self.loginButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" alpha:0.08f];
}
- (void)detectIfLogin
{
    if ([IVNetwork savedUserInfo] == nil)
    {
        [self.singupButton setHidden:NO];
        [self.loginButton setHidden:NO];
    }else
    {
        [self.singupButton setHidden:YES];
        [self.loginButton setHidden:YES];
    }
}
- (IBAction)singButtonAction:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}
- (IBAction)loginButtonAction:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}
- (IBAction)nextPageAction:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}
@end
