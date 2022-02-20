//
//  KYMFastWithdrewVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/19.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMFastWithdrewVC.h"
#import "KYMWithdrewStatusView.h"
@interface KYMFastWithdrewVC ()

@property (nonatomic, assign) NSUInteger currentStep;
@property (weak, nonatomic) IBOutlet KYMWithdrewStatusView *statusView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *amountLB;
@property (weak, nonatomic) IBOutlet UILabel *amountStatusLB1;
@property (weak, nonatomic) IBOutlet UILabel *amountStatusLB2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountStatusLB2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountStatusLB2Top;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation KYMFastWithdrewVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusView.status = 0;
    self.currentStep = 0;

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)setCurrentStep:(NSUInteger)currentStep
{
    _currentStep = currentStep;

    switch (currentStep) {
        case 0:
            self.statusViewHeight.constant = 160;
            self.amountViewHeight.constant = 81;
    
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = YES;
            [self.submitBtn setTitle:@"取消取款" forState:UIControlStateNormal];
            break;
        case 1:
            self.statusViewHeight.constant = 160;
            self.amountViewHeight.constant = 81;
       
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = YES;
            break;
        case 2:
            self.statusViewHeight.constant = 160;
            self.amountViewHeight.constant = 106;
    
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = NO;
            self.amountStatusLB2Top.constant = 3;
            self.amountStatusLB2Height.constant = 20;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:12];
            self.amountStatusLB2.text = @"在15分钟点击确认到账，可以获得0.5%取款返利金";
            break;
        case 3:
            self.statusViewHeight.constant = 160;
            self.amountViewHeight.constant = 106;
        
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = NO;
            self.amountStatusLB2Top.constant = 3;
            self.amountStatusLB2Height.constant = 20;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:12];
            self.amountStatusLB2.text = @"在15分钟点击确认到账，可以获得0.5%取款返利金";

            
            break;
        case 4:
            self.statusViewHeight.constant = 138;
            self.amountViewHeight.constant = 133;
           
            self.amountStatusLB1.hidden = NO;
            self.amountStatusLB2.hidden = NO;
            self.amountStatusLB2Top.constant = 22;
            self.amountStatusLB2Height.constant = 40;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:14];
            self.amountStatusLB2.text = @"由于您未在规定时间确认，系统判断您已确认到账\n如提现未到账或金额不符，请及时联系客服";
            break;
        case 5:
            self.statusViewHeight.constant = 138;
            self.amountViewHeight.constant = 123;
          
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = NO;
            self.amountStatusLB2Top.constant = 1;
            self.amountStatusLB2Height.constant = 40;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:14];
            self.amountStatusLB2.text = @"恭喜老板！获得取款返利金2.5元\n每周一统一发放";
            break;
            
        default:
            break;
    }
   
}
- (IBAction)submitBtnClicked:(id)sender {
}
- (IBAction)customerBtnClicked:(id)sender {
}
@end
