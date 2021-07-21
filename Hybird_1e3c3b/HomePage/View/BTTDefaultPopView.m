//
//  BTTDefaultPopView.m
//  Hybird_1e3c3b
//
//  Created by Andy on 7/20/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTDefaultPopView.h"
#import "UIImageView+WebCache.h"
@interface BTTDefaultPopView()
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;

@end

@implementation BTTDefaultPopView

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
        [_backGroundImageView sd_setImageWithURL:[NSURL URLWithString:sender] placeholderImage:nil];
    }else
    {
        
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
