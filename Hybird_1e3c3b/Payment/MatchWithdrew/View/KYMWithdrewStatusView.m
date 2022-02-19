//
//  KYMWithdrewStatusView.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/19.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewStatusView.h"

@interface KYMWithdrewStatusView ()
@property (weak, nonatomic) IBOutlet UIView *statusItemView;
@property (nonatomic, strong) NSArray *statusTitleArray;
@property (weak, nonatomic) IBOutlet UILabel *stautsLB1;
@property (weak, nonatomic) IBOutlet UILabel *statusLB2;
@property (weak, nonatomic) IBOutlet UILabel *statusLB3;
@property (weak, nonatomic) IBOutlet UILabel *statusLB4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLB2Width;
@end
@implementation KYMWithdrewStatusView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupStatusItemView];
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
- (void)layoutSubviews
{
    [super layoutSubviews];
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

- (void)setStatus:(KYMWithdrewStatus)status
{
    _status = status;
    UIImageView *imageView = [self.statusItemView viewWithTag:1130 + status];
    imageView.image = [UIImage imageNamed:@""];
    UILabel *label = [self.statusItemView viewWithTag:1230 + status];
    label.textColor =  [UIColor colorWithRed:0xD2 / 255.0 green:0xD2 / 255.0 blue:0xD2 / 255.0 alpha:1];
    
    switch (status) {
        case 0:
            self.stautsLB1.text = @"已经提交取款订单，系统审核中...";
            self.stautsLB1.textColor = [UIColor colorWithRed:0xF4 / 255.0 green:0x35 / 255.0 blue:0x35 / 255.0 alpha:1];
            self.statusLB2.text = @"耐心等待5秒到1分钟即可";
            self.statusLB2.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Regular" size:12] ;
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
            break;
        case 1:
            self.stautsLB1.text = @"审核通过，系统付款中，请等待付款通知...";
            self.stautsLB1.textColor = [UIColor colorWithRed:0xF4 / 255.0 green:0x35 / 255.0 blue:0x35 / 255.0 alpha:1];
            self.statusLB2.text = @"取款到账后，请务必在15分钟内点击确认到账";
            self.statusLB2.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Regular" size:12];
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
            break;
        case 2:
            self.stautsLB1.text = @"订单已付款，请您核实银行卡是否到账";
            self.stautsLB1.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.text = @"请在";
            self.statusLB2.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Regular" size:12];
            self.statusLB3.hidden = NO;
            self.statusLB4.hidden = NO;
            break;
        case 3:
            self.stautsLB1.text = @"订单已付款，请您核实银行卡是否到账";
            self.stautsLB1.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.text = @"未确认到账，订单异常";
            self.statusLB2.textColor = [UIColor colorWithRed:0xF4 / 255.0 green:0x35 / 255.0 blue:0x35 / 255.0 alpha:1];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:15];
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
        
            
            break;
        case 4:
            self.stautsLB1.text = @"您完成了一笔取款";
            self.stautsLB1.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.hidden = YES;
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
    
            break;
        case 5:
            self.stautsLB1.text = @"您完成了一笔取款";
            self.stautsLB1.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
            self.statusLB2.hidden = YES;
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
          
            break;
            
        default:
            break;
    }
    CGFloat lable2W = [self.statusLB2.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.statusLB2.font} context:nil].size.width + 5;
    self.statusLB2Width.constant = lable2W;
}
@end
