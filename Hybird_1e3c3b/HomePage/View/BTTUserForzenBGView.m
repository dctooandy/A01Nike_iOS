//
//  BTTUserForzenBGView.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/6.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTUserForzenBGView.h"
@interface BTTUserForzenBGView()

@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;
@property (weak, nonatomic) IBOutlet UIButton *homePageButton;
@end
@implementation BTTUserForzenBGView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (IBAction)withdrawBtn_click:(id)sender {
    if (self.tapToWithdraw) {
        self.tapToWithdraw();
    }
}
- (IBAction)homepageBtn_click:(id)sender {
    if (self.tapToHome) {
        self.tapToHome();
    }
}
@end
