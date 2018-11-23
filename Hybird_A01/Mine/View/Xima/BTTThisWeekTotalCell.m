//
//  BTTThisWeekTotalCell.m
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTThisWeekTotalCell.h"
#import "BTTXimaItemModel.h"

@interface BTTThisWeekTotalCell ()

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;


@end

@implementation BTTThisWeekTotalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

- (void)setModel:(BTTXimaTotalModel *)model {
    _model = model;
    self.totalLabel.text = [NSString stringWithFormat:@"%@元",[PublicMethod transferNumToThousandFormat:model.totalAmount.floatValue]];
}

@end
