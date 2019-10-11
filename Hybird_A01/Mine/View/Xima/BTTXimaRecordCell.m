//
//  BTTXimaRecordCell.m
//  Hybird_A01
//
//  Created by Domino on 10/10/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTXimaRecordCell.h"
#import "BTTXimaRecordModel.h"

@interface BTTXimaRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation BTTXimaRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    
}

- (void)setXimaRecordCellType:(BTTXimaRecordCellType)ximaRecordCellType {
    _ximaRecordCellType = ximaRecordCellType;
    switch (_ximaRecordCellType) {
        case BTTXimaRecordCellTypeTitle:
        {
            self.timeLabel.textColor = UIColor.whiteColor;
            self.amountLabel.textColor = UIColor.whiteColor;
            self.timeLabel.text = @"时间";
            self.amountLabel.text = @"洗码投注额";
            self.contentView.backgroundColor = [UIColor colorWithHexString:@"292d36"];
        }
            break;
            
        case BTTXimaRecordCellTypeFirst:
        {
            self.timeLabel.textColor = [UIColor colorWithHexString:@"818791"];
            self.amountLabel.textColor = [UIColor colorWithHexString:@"818791"];
            self.contentView.backgroundColor = [UIColor colorWithHexString:@"292d36"];
        }
            break;
            
        case BTTXimaRecordCellTypeSecond:
        {
            self.timeLabel.textColor = [UIColor colorWithHexString:@"818791"];
            self.amountLabel.textColor = [UIColor colorWithHexString:@"818791"];
            self.contentView.backgroundColor = [UIColor colorWithHexString:@"393e4a"];
        }
            break;
            
        case BTTXimaRecordCellTypeLast:
        {
            self.timeLabel.textColor = [UIColor colorWithHexString:@"c9af7d"];
            self.amountLabel.textColor = [UIColor colorWithHexString:@"c9af7d"];
            self.timeLabel.text = @"总计";
        }
            break;
            
        default:
            break;
    }
}

- (void)setModel:(BTTXimaRecordItemModel *)model {
    _model = model;
    if (self.ximaRecordCellType == BTTXimaRecordCellTypeFirst || self.ximaRecordCellType == BTTXimaRecordCellTypeSecond) {
        self.timeLabel.text = model.date;
        self.amountLabel.text = model.amount;
    }
}

@end
