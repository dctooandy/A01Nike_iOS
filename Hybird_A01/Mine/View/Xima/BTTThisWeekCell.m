//
//  BTTThisWeekCell.m
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTThisWeekCell.h"
#import "BTTXimaItemModel.h"

@interface BTTThisWeekCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *validAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateLabel;


@end

@implementation BTTThisWeekCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
}

- (void)setModel:(BTTXimaItemModel *)model {
    _model = model;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.xmName];
    self.validAmountLabel.text = [NSString stringWithFormat:@"%@元",[PublicMethod transferNumToThousandFormat:model.xmAmount]];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%@",[PublicMethod transferNumToThousandFormat:model.totalBetAmont]];
    self.rateLabel.text = model.xmRate;
}

- (void)setThisWeekCellType:(BTTXimaThisWeekCellType)thisWeekCellType {
    _thisWeekCellType = thisWeekCellType;
    if (_thisWeekCellType == BTTXimaThisWeekCellTypeSelect) {
        self.selectIcon.image = ImageNamed(@"xima_select");
    } else if (_thisWeekCellType == BTTXimaThisWeekCellTypeSelect) {
        self.selectIcon.image = ImageNamed(@"xima_unselect");
    } else {
        self.selectIcon.image = ImageNamed(@"xima_select_disable");
    }
}

@end
