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
@property (strong, nonatomic) UIViewController * currentViewController;
@end
@implementation BTTUserForzenBGView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}
-(void)setupViewController:(UIViewController *)cView
{
    _currentViewController = cView;
}
-(void)setupUI
{
    weakSelf(weakSelf)
    
    self.tapToWithdraw = ^{
        if ([weakSelf.currentViewController navigationController])
        {
            [[weakSelf.currentViewController navigationController] popToRootViewControllerAnimated:YES];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoMineNotification object:nil];
        });
    };
    self.tapToHome = ^{
        if ([weakSelf.currentViewController navigationController])
        {
            [[weakSelf.currentViewController navigationController] popToRootViewControllerAnimated:YES];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoHomePageNotification object:nil];
        });
    };

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
