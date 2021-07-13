//
//  BTTPaymentWarningPopView.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 7/13/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTPaymentWarningPopView.h"

@interface BTTPaymentWarningPopView()
@property (weak, nonatomic) IBOutlet UIButton *changeModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation BTTPaymentWarningPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [PublicMethod setViewSelectCorner:(UIRectCornerBottomRight | UIRectCornerBottomLeft) view:self.bgView cornerRadius:4.0];
    [PublicMethod setViewSelectCorner:(UIRectCornerTopRight | UIRectCornerTopLeft) view:self.titleLab cornerRadius:4.0];
    [PublicMethod setViewSelectCorner:(UIRectCornerBottomRight | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerTopLeft) view:self.changeModeBtn cornerRadius:4.0];
    [PublicMethod setViewSelectCorner:(UIRectCornerBottomRight | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerTopLeft) view:self.kefuBtn cornerRadius:4.0];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap)];
    self.bgView.userInteractionEnabled = true;
    [self.bgView addGestureRecognizer:bgTap];
}

-(void)bgTap {
}

- (IBAction)closeBtnAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)btnAction:(UIButton *)sender {
    //0=>kefu 1=>changeMode
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

@end
