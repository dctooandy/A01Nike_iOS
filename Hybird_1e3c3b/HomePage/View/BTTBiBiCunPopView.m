//
//  BTTBiBiCunPopView.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 06/10/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBiBiCunPopView.h"

@interface BTTBiBiCunPopView()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@end

@implementation BTTBiBiCunPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLab.adjustsFontSizeToFitWidth = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap)];
    bgTap.numberOfTapsRequired = 1;
    self.bgImageView.userInteractionEnabled = true;
    [self.bgImageView addGestureRecognizer:bgTap];
}

-(void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    NSString * str = [NSString stringWithFormat:@"笔笔%@的优惠哦", _contentStr];
    NSRange range = [str rangeOfString:contentStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffe700"]} range:range];
    self.contentLab.attributedText = attStr;
}

-(void)bgTap {
}

-(void)tap {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)closeBtn:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)goToWithdrawal:(id)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

@end
