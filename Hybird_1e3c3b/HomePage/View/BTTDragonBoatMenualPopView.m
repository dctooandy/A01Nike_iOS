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
@synthesize currentDataArray;
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
- (IBAction)nextCupponAction:(UIButton *)sender {
    [self.currentDataArray removeAllObjects];
    [self resetAllStackView];
}
- (void)setCurrentCupponPage
{
    if ([self.currentDataArray count] == 5)
    {
        
    }
}
- (void)resetAllStackView
{
    UIButton *zeroButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self changeStackView:self.stackViewOne whitButton:zeroButton clearAction:YES];
    [self changeStackView:self.stackViewTwo whitButton:zeroButton clearAction:YES];
    [self changeStackView:self.stackViewThree whitButton:zeroButton clearAction:YES];
    [self changeStackView:self.stackViewFour whitButton:zeroButton clearAction:YES];
    [self changeStackView:self.stackViewFive whitButton:zeroButton clearAction:YES];
}
- (IBAction)ballBtnAction:(UIButton *)sender {
    [sender setBackgroundImage:ImageNamed(@"redBall") forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (sender.tag >= 10000)
    {
        [self changeStackView:self.stackViewOne whitButton:sender clearAction:NO];
    }else if (sender.tag >= 1000)
    {
        [self changeStackView:self.stackViewTwo whitButton:sender clearAction:NO];
    }else if (sender.tag >= 100)
    {
        [self changeStackView:self.stackViewThree whitButton:sender clearAction:NO];
    }else if (sender.tag >= 10)
    {
        [self changeStackView:self.stackViewFour whitButton:sender clearAction:NO];
    }else{
        [self changeStackView:self.stackViewFive whitButton:sender clearAction:NO];
    }
}
- (void)changeStackView:(UIStackView *)stackView whitButton:(UIButton *)sender clearAction:(BOOL)clearNow
{
    for (UIStackView *subView in stackView.subviews) {
        for (UIView *button in subView.subviews) {
            if (clearNow || ([button isKindOfClass:[UIButton class]] && button.tag != sender.tag))
            {
                [(UIButton *)button setBackgroundImage:ImageNamed(@"whiteBall") forState:UIControlStateNormal];
                [(UIButton *)button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
}
@end
