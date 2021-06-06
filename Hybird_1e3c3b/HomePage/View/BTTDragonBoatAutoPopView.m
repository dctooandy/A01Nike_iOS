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

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (assign, nonatomic) NSInteger currentPage;


@end

@implementation BTTDragonBoatAutoPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    
    
    [super awakeFromNib];
}
- (void)configForCouponNum:(NSString *)coupon
{
    self.currentPage = 1;
    NSInteger groupInt = ([coupon integerValue] >= 5 ? [coupon integerValue]/5 : 1);
    self.titleLabel.text = [NSString stringWithFormat:@"您随机获得 %@ 张奖卷",coupon];
    self.dataLabel.text = [NSString stringWithFormat:@"共計%@张  %ld/%ld組",coupon,_currentPage,groupInt];
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



@end
