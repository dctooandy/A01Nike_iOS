//
//  DSBRedBagPopView.m
//  Hybird_1e3c3b
//
//  Created by Levy on 7/30/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "DSBRedBagPopView.h"

@interface DSBRedBagPopView ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;

@end

@implementation DSBRedBagPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap {
    if (self.tapActivity) {
        self.tapActivity();
    }
}
- (IBAction)lqBtn_click:(id)sender {
    if (self.tapConfirm) {
        self.tapConfirm();
    }
}

- (void)setContentMessage:(NSString *)message{
    _contentImg.image = [UIImage imageNamed:message];
}

- (IBAction)cancelBtnAction:(id)sender {
    if (self.tapActivity) {
        self.tapActivity();
    }
}

@end
