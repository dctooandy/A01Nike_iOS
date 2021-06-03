//
//  BTTDragonBoatMenualPopView.m
//  Hybird_1e3c3b
//
//  Created by Andy on 6/3/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTDragonBoatMenualPopView.h"

@interface BTTDragonBoatMenualPopView()


@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
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
    self.amountLabel.text = [NSString stringWithFormat:@"%li",(long)amountValue];
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
- (IBAction)checkBoxForRandomSelect:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"○"])
    {
        [sender setTitle:@"◎" forState:UIControlStateNormal];
    }else
    {
        [sender setTitle:@"○" forState:UIControlStateNormal];
    }
    [self layoutSubviews];
}

@end
