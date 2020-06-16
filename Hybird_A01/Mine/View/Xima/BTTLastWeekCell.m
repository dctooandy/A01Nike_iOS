//
//  BTTLastWeekCell.m
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLastWeekCell.h"
#import "BTTXimaItemModel.h"

@interface BTTLastWeekCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *ximaAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@end

@implementation BTTLastWeekCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
}

- (void)setItemModel:(BTTXimaItemModel *)itemModel{
    NSString *unitString = [IVNetwork savedUserInfo].newAccountFlag==1 ? @"USDT" : @"元";
    self.nameLabel.text = [NSString stringWithFormat:@"%@",itemModel.xmName];
    self.ximaAmountLabel.text = [NSString stringWithFormat:@"%@%@",[PublicMethod transferNumToThousandFormat:itemModel.xmAmount],unitString];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%@",[PublicMethod transferNumToThousandFormat:itemModel.totalBetAmont]];
    self.rateLabel.text = itemModel.xmRate;
    
}

- (void)setModel:(BTTXimaLastWeekItemModel *)model {
    _model = model;
    NSString *unitString = [IVNetwork savedUserInfo].newAccountFlag==1 ? @"USDT" : @"元";
    self.nameLabel.text = model.platformName;
    self.ximaAmountLabel.text = [NSString stringWithFormat:@"%@%@",model.amount,unitString];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%@",model.bettingAmount];
    self.rateLabel.text = model.rate;
    
}

@end
