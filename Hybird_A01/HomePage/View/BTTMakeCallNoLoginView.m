//
//  BTTMakeCallNoLoginView.m
//  Hybird_A01
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTMakeCallNoLoginView.h"

@interface BTTMakeCallNoLoginView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation BTTMakeCallNoLoginView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.bgImageView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    [self.bgView addGestureRecognizer:viewTap];
}

- (void)viewTap {
    [self endEditing:YES];
}

- (void)tap {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)callBackBtnClick:(UIButton *)sender {
    [self endEditing:YES];
    if (!self.phoneTextField.text.length) {
        [MBProgressHUD showError:@"请输入您的联系电话" toView:nil];
        return;
    }
    if (self.callBackBlock) {
        self.callBackBlock(self.phoneTextField.text);
    }
}
@end
