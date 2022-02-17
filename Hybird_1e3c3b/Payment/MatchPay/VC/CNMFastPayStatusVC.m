//
//  CNMFastPayStatusVC.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/17/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMFastPayStatusVC.h"
typedef NS_ENUM(NSUInteger, CNMPayStatus) {
    CNMPayStatusSubmit,  //已提交
    CNMPayStatusPaying,  //等待支付
    CNMPayStatusConfirm, //已确认
    CNMPayStatusSuccess  //已完成
};

@interface CNMFastPayStatusVC ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *statusIVs;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *statusLbs;
@property (nonatomic, assign) CNMPayStatus status;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerH;
/// 时间前面
@property (weak, nonatomic) IBOutlet UILabel *tip1Lb;
/// 时间标签
@property (weak, nonatomic) IBOutlet UILabel *tip2Lb;
/// 时间后面
@property (weak, nonatomic) IBOutlet UILabel *tip3Lb;
/// 时间下面
@property (weak, nonatomic) IBOutlet UILabel *tip4Lb;
/// 大字提示语
@property (weak, nonatomic) IBOutlet UILabel *tip5Lb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip5LbH;

@end

@implementation CNMFastPayStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStatusUI:CNMPayStatusPaying];
}

- (void)setStatusUI:(CNMPayStatus)status {
    for (int i = 0; i <= status; i++) {
        if (i >= self.statusIVs.count) {
            break;
        }
        UIImageView *iv = self.statusIVs[i];
        [iv setHighlighted:YES];
        UILabel *label = self.statusLbs[i];
        label.textColor = kHexColor(0xD2D2D2);
    }
    
    switch (status) {
        case CNMPayStatusConfirm:
            self.headerH.constant = 140;
            self.tip1Lb.text = @"已等待";
            self.tip3Lb.hidden = YES;
            self.tip4Lb.hidden = YES;
            self.tip5Lb.hidden = YES;
            break;
        case CNMPayStatusSuccess:
            self.headerH.constant = 140;
            self.tip1Lb.hidden = YES;
            self.tip2Lb.hidden = YES;
            self.tip3Lb.hidden = YES;
            self.tip4Lb.hidden = YES;
            self.tip5Lb.hidden = NO;
            self.tip5Lb.textColor = kHexColor(0x818791);
            self.tip5Lb.text = @"您完成了一笔存款";
            self.tip5LbH.constant = 16;
            break;
        default:
            break;
    }
}
@end
