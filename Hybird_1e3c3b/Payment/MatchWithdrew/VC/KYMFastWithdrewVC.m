//
//  KYMFastWithdrewVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/19.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMFastWithdrewVC.h"
@interface KYMFastWithdrewVC ()
@property (weak, nonatomic) IBOutlet UIView *statusItemView;
@property (nonatomic, strong) NSArray *statusTitleArray;
@property (nonatomic, assign) NSUInteger currentStep;
@property (weak, nonatomic) IBOutlet UILabel *stautsLB1;
@property (weak, nonatomic) IBOutlet UILabel *statusLB2;
@property (weak, nonatomic) IBOutlet UILabel *statusLB3;
@property (weak, nonatomic) IBOutlet UILabel *statusLB4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLB2Width;
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
    [self setupStatusItemView];
    self.currentStep = 5;
}
- (void)setupStatusItemView
{
    self.statusTitleArray = @[@"已提交",@"等待付款",@"待确认到账",@"取款完成"];
    for (int i = 0; i < self.statusTitleArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor redColor];
        imageView.tag = 1130 + i;
        [self.statusItemView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.text = self.statusTitleArray[i];
        lable.font = [UIFont fontWithName:@"PingFang SC Regular" size:14];
        lable.textColor =  [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
        lable.tag = 1230 + i;
        [self.statusItemView addSubview:lable];
        
        if (i != self.statusTitleArray.count - 1) {
            UIView *line = [[UIView alloc] init];
            line.tag = 1330 + i;
            line.backgroundColor = [UIColor colorWithRed:0xFF /255.0 green:0xFF /255.0  blue:0xFF /255.0  alpha:0.1];
            [self.statusItemView addSubview:line];
        }
    }
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat imgW = 42;
    CGFloat imgH = 42;
    [self.statusItemView layoutIfNeeded];
    CGFloat mergin = (CGRectGetWidth(self.statusItemView.frame) - imgW * 4) / 3.0;
    for (int i = 0; i < self.statusTitleArray.count; i++) {
        UIImageView *imageView = [self.statusItemView viewWithTag:1130 + i];
        CGFloat imgX = (imgW + mergin) * i;
        imageView.frame = CGRectMake(imgX, 0, imgW, imgH);
        
        UILabel *label = [self.statusItemView viewWithTag:1230 + i];
        CGFloat labelH = 20;
        CGFloat labelY = CGRectGetMaxY(imageView.frame) + 5;
        CGFloat lableW = [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : label.font} context:nil].size.width;
        CGFloat labelX = CGRectGetMidX(imageView.frame) - lableW * 0.5;
        label.frame = CGRectMake(labelX, labelY, lableW, labelH);
        
        if (i != self.statusTitleArray.count - 1) {
            UIView *line = [self.statusItemView viewWithTag:1330 + i];;
            CGFloat lineW = mergin - 4;
            CGFloat lineH = 1;
            CGFloat lineX = CGRectGetMaxX(imageView.frame) + 2;
            CGFloat lineY = CGRectGetMidY(imageView.frame) - lineH;
            line.frame = CGRectMake(lineX, lineY, lineW, lineH);
        }
    }
}
- (void)setCurrentStep:(NSUInteger)currentStep
{
    _currentStep = currentStep;
    UIImageView *imageView = [self.statusItemView viewWithTag:1130 + currentStep];
    imageView.image = [UIImage imageNamed:@""];
    UILabel *label = [self.statusItemView viewWithTag:1230 + currentStep];
    label.textColor =  [UIColor colorWithRed:0xD2 / 255.0 green:0xD2 / 255.0 blue:0xD2 / 255.0 alpha:1];
    
    switch (currentStep) {
        case 0:
            self.statusViewHeight.constant = 160;
            self.amountViewHeight.constant = 81;
            self.stautsLB1.text = @"已经提交取款订单，系统审核中...";
            self.stautsLB1.textColor = [UIColor colorWithRed:0xF4 / 255.0 green:0x35 / 255.0 blue:0x35 / 255.0 alpha:1];
            self.statusLB2.text = @"耐心等待5秒到1分钟即可";
            self.statusLB2.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Regular" size:12] ;
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = YES;
            [self.submitBtn setTitle:@"取消取款" forState:UIControlStateNormal];
            break;
        case 1:
            self.statusViewHeight.constant = 160;
            self.amountViewHeight.constant = 81;
            self.stautsLB1.text = @"审核通过，系统付款中，请等待付款通知...";
            self.stautsLB1.textColor = [UIColor colorWithRed:0xF4 / 255.0 green:0x35 / 255.0 blue:0x35 / 255.0 alpha:1];
            self.statusLB2.text = @"取款到账后，请务必在15分钟内点击确认到账";
            self.statusLB2.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Regular" size:12];
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = YES;
            break;
        case 2:
            self.statusViewHeight.constant = 160;
            self.amountViewHeight.constant = 106;
            self.stautsLB1.text = @"订单已付款，请您核实银行卡是否到账";
            self.stautsLB1.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.text = @"请在";
            self.statusLB2.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Regular" size:12];
            self.statusLB3.hidden = NO;
            self.statusLB4.hidden = NO;
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
            self.stautsLB1.text = @"订单已付款，请您核实银行卡是否到账";
            self.stautsLB1.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.text = @"未确认到账，订单异常";
            self.statusLB2.textColor = [UIColor colorWithRed:0xF4 / 255.0 green:0x35 / 255.0 blue:0x35 / 255.0 alpha:1];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:15];
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
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
            self.stautsLB1.text = @"您完成了一笔取款";
            self.stautsLB1.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.hidden = YES;
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
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
            self.stautsLB1.text = @"您完成了一笔取款";
            self.stautsLB1.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.hidden = YES;
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
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
    CGFloat lable2W = [self.statusLB2.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.statusLB2.font} context:nil].size.width + 5;
    self.statusLB2Width.constant = lable2W;
}
- (IBAction)submitBtnClicked:(id)sender {
}
- (IBAction)customerBtnClicked:(id)sender {
}
@end
