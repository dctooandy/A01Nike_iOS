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
@property (strong, nonatomic) NSMutableArray *currentCouponArray;
@property (strong, nonatomic) NSString *stringOne;
@property (strong, nonatomic) NSString *stringTwo;
@property (strong, nonatomic) NSString *stringThree;
@property (strong, nonatomic) NSString *stringFour;
@property (strong, nonatomic) NSString *stringFive;


@end

@implementation BTTDragonBoatMenualPopView
@synthesize currentCouponArray;
+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    currentCouponArray = [[NSMutableArray alloc] init];
    [self resetCurrentCouponArray];
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

- (IBAction)backCouponAction:(UIButton *)sender {
    if (self.callBackBlock) {
        self.callBackBlock(@"",@"",@"");
    }
}
- (IBAction)nextCouponAction:(UIButton *)sender {
    if ([self checkSelectedNumForArray])
    {
        if (self.callBackBlock) {
            self.callBackBlock([NSString stringWithFormat:@"[%@,%@,%@,%@,%@]",self.stringOne,self.stringTwo,self.stringThree,self.stringFour,self.stringFive],@"",@"");
        }
        [self resetCurrentCouponArray];
        [self resetAllStackView];
    }
}
- (void)setCurrentCouponPage:(NSArray*)couponArray
{
    if ([couponArray count] == 5)
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
- (void)resetCurrentCouponArray
{
    [self.currentCouponArray removeAllObjects];
    self.stringOne = @"99";
    self.stringTwo = @"99";
    self.stringThree = @"99";
    self.stringFour = @"99";
    self.stringFive = @"99";
    [self.currentCouponArray addObject:self.stringOne];
    [self.currentCouponArray addObject:self.stringTwo];
    [self.currentCouponArray addObject:self.stringThree];
    [self.currentCouponArray addObject:self.stringFour];
    [self.currentCouponArray addObject:self.stringFive];
    
}
- (BOOL)checkSelectedNumForArray
{
    return ![self.currentCouponArray containsObject:@"99"];
}
- (IBAction)ballBtnAction:(UIButton *)sender {
    [sender setBackgroundImage:ImageNamed(@"redBall") forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (sender.tag >= 10000)
    {
        
        [self.currentCouponArray replaceObjectAtIndex:0 withObject: [NSString stringWithFormat:@"%ld",(long)sender.tag - 10000]];
        [self changeStackView:self.stackViewOne whitButton:sender clearAction:NO];
    }else if (sender.tag >= 1000)
    {
        [self.currentCouponArray replaceObjectAtIndex:1 withObject: [NSString stringWithFormat:@"%ld",(long)sender.tag - 1000]];
        [self changeStackView:self.stackViewTwo whitButton:sender clearAction:NO];
    }else if (sender.tag >= 100)
    {
        [self.currentCouponArray replaceObjectAtIndex:2 withObject: [NSString stringWithFormat:@"%ld",(long)sender.tag - 100]];
        [self changeStackView:self.stackViewThree whitButton:sender clearAction:NO];
    }else if (sender.tag >= 10)
    {
        [self.currentCouponArray replaceObjectAtIndex:3 withObject: [NSString stringWithFormat:@"%ld",(long)sender.tag - 10]];
        [self changeStackView:self.stackViewFour whitButton:sender clearAction:NO];
    }else{
        [self.currentCouponArray replaceObjectAtIndex:4 withObject: [NSString stringWithFormat:@"%ld",(long)sender.tag]];
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
