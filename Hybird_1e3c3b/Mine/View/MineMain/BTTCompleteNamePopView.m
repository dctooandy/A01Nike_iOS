//
//  BTTCompleteNamePopView.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 7/9/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTCompleteNamePopView.h"

@interface BTTCompleteNamePopView()
@property (weak, nonatomic) IBOutlet UIView *bgImgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation BTTCompleteNamePopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [PublicMethod setViewSelectCorner:(UIRectCornerTopRight | UIRectCornerTopLeft) view:self.titleLab cornerRadius:4.0];
    [PublicMethod setViewSelectCorner:(UIRectCornerBottomRight | UIRectCornerBottomLeft) view:self.bgImgView cornerRadius:4.0];
    [PublicMethod setViewSelectCorner:(UIRectCornerBottomRight | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerTopLeft) view:self.commitBtn cornerRadius:4.0];
    
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
    if (self.nameTextField.text.length > 0) {
        if (self.commitBtnBlock) {
            self.commitBtnBlock(self.nameTextField.text);
        }
    } else {
        [MBProgressHUD showError:@"请输入真实姓名" toView:self];
    }
}

@end
