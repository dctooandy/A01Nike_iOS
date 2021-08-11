//
//  BTTCantBindCardPopView.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/11/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTCantBindCardPopView.h"

@interface BTTCantBindCardPopView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *bgImgView;

@end

@implementation BTTCantBindCardPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [PublicMethod setViewSelectCorner:(UIRectCornerTopRight | UIRectCornerTopLeft) view:self.titleLab cornerRadius:4.0];
    [PublicMethod setViewSelectCorner:(UIRectCornerBottomRight | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerTopLeft) view:self.bgImgView cornerRadius:4.0];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap)];
    self.bgImgView.userInteractionEnabled = true;
    [self.bgImgView addGestureRecognizer:bgTap];
}

-(void)bgTap {
}

- (IBAction)closeBtnAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)commitBtnAction:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

@end
