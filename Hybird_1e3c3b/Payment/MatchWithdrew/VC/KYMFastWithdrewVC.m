//
//  KYMFastWithdrewVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/19.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMFastWithdrewVC.h"
#import "KYMWithdrewStatusView.h"
#import "KYMWithdrewAmountView.h"
#import "KYMWithdrewSubmitView.h"
@interface KYMFastWithdrewVC ()

@property (nonatomic, assign) KYMWithdrewStatus status;
@property (weak, nonatomic) IBOutlet KYMWithdrewStatusView *statusView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountViewHeight;
@property (weak, nonatomic) IBOutlet KYMWithdrewAmountView *amountView;
@property (weak, nonatomic) IBOutlet KYMWithdrewSubmitView *submitView;

@end

@implementation KYMFastWithdrewVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.status = 0;

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)setStatus:(KYMWithdrewStatus)status
{
    _status = status;
    self.statusView.status = status;
    self.amountView.status = status;
    switch (status) {
        case 0:
            self.statusViewHeight.constant = 160;
            self.amountViewHeight.constant = 81;
            
            break;
        case 1:
            self.statusViewHeight.constant = 160;
            self.amountViewHeight.constant = 81;
            break;
        case 2:
            self.statusViewHeight.constant = 160;
            self.amountViewHeight.constant = 106;
            break;
        case 3:
            self.statusViewHeight.constant = 160;
            self.amountViewHeight.constant = 106;
            break;
        case 4:
            self.statusViewHeight.constant = 138;
            self.amountViewHeight.constant = 133;
            break;
        case 5:
            self.statusViewHeight.constant = 138;
            self.amountViewHeight.constant = 123;
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
