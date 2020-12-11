//
//  BTTChooseCurrencyPopView.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 26/11/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTChooseCurrencyPopView.h"

@interface BTTChooseCurrencyPopView()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation BTTChooseCurrencyPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)closeBtn:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)btnAction:(id)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}


@end
