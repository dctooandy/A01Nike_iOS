//
//  BTTPromoRecordFooterView.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 04/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTPromoRecordFooterView.h"

@interface BTTPromoRecordFooterView()
@property (nonatomic, strong)UIButton * selectAllBtn;
@property (nonatomic, strong)UIButton * cancelBtn;
@end

@implementation BTTPromoRecordFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#23262e"];
        self.totalAmount = @"0.00";
        [self setUpConfigView];
    }
    return self;
}

-(void)setUpConfigView {
    self.selectAllBtn = [[UIButton alloc] init];
    self.selectAllBtn.tag = 0;
    [self.selectAllBtn setImage:[UIImage imageNamed:@"ic_all_check_default"] forState:UIControlStateNormal];
    [self.selectAllBtn setImage:[UIImage imageNamed:@"ic_all_check_selected"] forState:UIControlStateSelected];
    [self.selectAllBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectAllBtn];
    [self.selectAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.width.height.offset(40);
    }];
    
    UILabel * allLab = [[UILabel alloc] init];
    allLab.text = @"全选";
    allLab.textColor = [UIColor colorWithHexString:@"#7c818a"];
    allLab.font = [UIFont systemFontOfSize:16];
    [self addSubview:allLab];
    [allLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.selectAllBtn.mas_right).offset(5);
    }];
    
    self.cancelBtn = [[UIButton alloc] init];
    self.cancelBtn.tag = 1;
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancelBtn setTitleColor:[UIColor colorWithHexString:@"#7c818a"] forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-5);
        make.width.offset(40);
    }];
    
    self.totalAmountLab = [[UILabel alloc] init];
    NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
    self.totalAmountLab.text = [NSString stringWithFormat:@"总计: %@ %@", self.totalAmount, unitStr];
    self.totalAmountLab.textColor = [UIColor colorWithHexString:@"#7c818a"];
    self.totalAmountLab.textAlignment = NSTextAlignmentCenter;
    self.totalAmountLab.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.totalAmountLab];
    [self.totalAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(allLab.mas_right).offset(5);
        make.right.equalTo(self.cancelBtn.mas_left).offset(-5);
    }];
}

-(void)btnAction:(UIButton *)sender {
    if (sender.tag == 0) {
        self.selectAllBtn.selected = !self.selectAllBtn.selected;
        if (self.allBtnClickBlock) {
            self.allBtnClickBlock(self.selectAllBtn.selected);
        }
    } else {
        if (self.cancelBtnClickBlock) {
            self.cancelBtnClickBlock();
        }
    }
}

-(void)setTotalAmount:(NSString *)totalAmount {
    _totalAmount = totalAmount;
    NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
    self.totalAmountLab.text = [NSString stringWithFormat:@"总计: %@ %@", self.totalAmount, unitStr];
}

-(void)calculateAmount:(NSString *)amount {
    self.totalAmount = [PublicMethod transferNumToThousandFormat:[self.totalAmount doubleValue] + [amount doubleValue]];
    NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
    self.totalAmountLab.text = [NSString stringWithFormat:@"总计: %@ %@", self.totalAmount, unitStr];
}

-(void)allBtnselect:(BOOL)select {
    [self.selectAllBtn setSelected:select];
}

@end
