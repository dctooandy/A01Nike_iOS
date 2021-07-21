//
//  BTTSevenXiPriHotPopView.m
//  Hybird_1e3c3b
//
//  Created by Andy on 7/19/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTSevenXiPriHotPopView.h"

@interface BTTSevenXiPriHotPopView()
@property (weak, nonatomic) IBOutlet UIView *topTitleView;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation BTTSevenXiPriHotPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configForContent:(NSString *)sender
{
    if (sender.length > 0)
    {
        self.contentLabel.text = sender;
    }else
    {
        [self.topTitleView setHidden:YES];
        [self.bottomTitleLabel setHidden:YES];
    }
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
