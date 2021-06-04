//
//  BTTDragonBoatMenualPopView.m
//  Hybird_1e3c3b
//
//  Created by Andy on 6/3/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTDragonBoatMenualPopView.h"

@interface BTTDragonBoatMenualPopView()
@property (weak, nonatomic) IBOutlet UIStackView *stackViewOne;
@property (weak, nonatomic) IBOutlet UIStackView *stackViewTwo;
@property (weak, nonatomic) IBOutlet UIStackView *stackViewThree;
@property (weak, nonatomic) IBOutlet UIStackView *stackViewFour;
@property (weak, nonatomic) IBOutlet UIStackView *stackViewFive;

@end

@implementation BTTDragonBoatMenualPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)configForAmount:(NSInteger)amountValue
{

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

- (IBAction)ballBtnAction:(UIButton *)sender {
    [sender setBackgroundImage:ImageNamed(@"redBall") forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (sender.tag >= 10000)
    {
        [self changeStackView:self.stackViewOne whitButton:sender];
    }else if (sender.tag >= 1000)
    {
        [self changeStackView:self.stackViewTwo whitButton:sender];
    }else if (sender.tag >= 100)
    {
        [self changeStackView:self.stackViewThree whitButton:sender];
    }else if (sender.tag >= 10)
    {
        [self changeStackView:self.stackViewFour whitButton:sender];
    }else{
        [self changeStackView:self.stackViewFive whitButton:sender];
    }
}
- (void)changeStackView:(UIStackView *)stackView whitButton:(UIButton *)sender
{
    for (UIStackView *subView in stackView.subviews) {
        for (UIView *button in subView.subviews) {
            if ([button isKindOfClass:[UIButton class]] && button.tag != sender.tag)
            {
                [(UIButton *)button setBackgroundImage:ImageNamed(@"whiteBall") forState:UIControlStateNormal];
                [(UIButton *)button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
}
@end
