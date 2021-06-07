//
//  BTTDragonBoatAutoPopView.m
//  Hybird_1e3c3b
//
//  Created by Andy on 6/3/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTDragonBoatAutoPopView.h"
@interface BTTDragonBoatAutoPopView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstraintsHeightWidth;

@property (weak, nonatomic) IBOutlet UILabel *chanceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger totalPagesNum;
@property (strong, nonatomic) NSArray* randomArray;
@property (strong, nonatomic) NSArray* stackViewsArray;
@property (weak, nonatomic) IBOutlet UIStackView *groupStackViewOne;
@property (weak, nonatomic) IBOutlet UIStackView *groupStackViewTwo;
@property (weak, nonatomic) IBOutlet UIStackView *groupStackViewThree;
@property (weak, nonatomic) IBOutlet UIStackView *groupStackViewFour;
@property (weak, nonatomic) IBOutlet UIStackView *groupStackViewFive;

@end
@implementation BTTDragonBoatAutoPopView
+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.stackViewsArray = [[NSArray alloc] initWithObjects:self.groupStackViewOne,self.groupStackViewTwo,self.groupStackViewThree,self.groupStackViewFour,self.groupStackViewFive, nil];
}
- (void)configForCouponNum:(NSString *)coupon couponData:(NSArray*)dataArray
{
    self.randomArray = dataArray;
    self.currentPage = 1;
    self.totalPagesNum = (dataArray.count / 5 == 0 ? 1 : (dataArray.count % 5 == 0 ? dataArray.count / 5 : dataArray.count / 5 + 1));
    
    self.chanceNumLabel.text = coupon;
    [self setDataLabelText];
    [self showNumbers];
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)btnAction:(UIButton *)sender {
    if (sender.tag ==1)
    {
        if (self.currentPage > 1)
        {
            self.currentPage -= 1;
        }
    }else
    {
        if (self.currentPage + 1 <= self.totalPagesNum)
        {
            self.currentPage += 1;
        }
    }
    [self setDataLabelText];
    [self showNumbers];
//    if (self.btnBlock) {
//        self.btnBlock(sender);
//    }
}
- (void)showNumbers
{
    NSInteger lengthNum = 5;
    NSInteger modNum = self.randomArray.count % 5;
    if ((self.currentPage == self.totalPagesNum) && modNum != 0)
    {
        lengthNum = modNum;
    }
    NSRange dataRange = NSMakeRange((self.currentPage - 1) * 5, lengthNum);
    NSArray * newDataArray = [self.randomArray subarrayWithRange:dataRange];
    for (int i = 0 ; i < 5 ; i ++)
    {
        if ((i + 1) > lengthNum)
        {
            if (self.stackViewsArray[i])
            {
                UIStackView * outView = self.stackViewsArray[i];
                if ([outView.superview superview])
                {
                    [[outView.superview superview] setHidden:YES];
                }
            }
        }else
        {
            UIStackView * currentView = self.stackViewsArray[i];
            if ([currentView.superview superview])
            {
                [[currentView.superview superview] setHidden:NO];
                NSArray * numArray = [newDataArray[i] componentsSeparatedByString:@","];
                for (UIButton * buttonView in currentView.subviews)
                {
                    [buttonView setTitle:numArray[buttonView.tag - 1] forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (void)setDataLabelText
{
    NSInteger modNum = self.randomArray.count % 5;
    NSInteger groupInt = ([self.chanceNumLabel.text integerValue] >= 5 ? [self.chanceNumLabel.text integerValue]/5 + (modNum != 0 ? 1: 0) : 1);
    self.dataLabel.text = [NSString stringWithFormat:@"共計%@张      %ld/%ld組",self.chanceNumLabel.text,self.currentPage,groupInt];
}

@end
