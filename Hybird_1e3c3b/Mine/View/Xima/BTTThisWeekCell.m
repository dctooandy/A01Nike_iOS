//
//  BTTThisWeekCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTThisWeekCell.h"
#import "BTTXimaItemModel.h"

@interface BTTThisWeekCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *validAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@property (weak, nonatomic) IBOutlet UIView *betRateAlertView;

@end

@implementation BTTThisWeekCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.selectButton.selected = YES;
}

- (void)setModel:(BTTXimaItemModel *)model {
    _model = model;
    NSString *unitString = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT" : @"元";
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.xmName];
    self.validAmountLabel.text = [NSString stringWithFormat:@"%@%@",[PublicMethod transferNumToThousandFormat:model.xmAmount],unitString];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%@", [PublicMethod transferNumToThousandFormat:model.totalBetAmont]];
    self.rateLabel.text = model.xmRate;
    if ([self.model.xmName isEqualToString:@"沙巴体育"] && [self.model.multiBetRate intValue] > 1)
    {
        [self.betRateAlertView setHidden:NO];
    }else
    {
        [self.betRateAlertView setHidden:YES];
    }
}

- (void)setThisWeekCellType:(BTTXimaThisWeekCellType)thisWeekCellType {
    _thisWeekCellType = thisWeekCellType;
}
- (IBAction)selecteBtn_click:(id)sender {
    if ([self.model.xmName isEqualToString:@"沙巴体育"] && [self.model.multiBetRate intValue] > 1)
    {
        if (self.tapBetRateAlertButton) {
            self.tapBetRateAlertButton();
        }
    }else
    {
        self.selectButton.selected = !self.selectButton.selected;
        if (self.tapSelecteButton) {
            self.tapSelecteButton(self.selectButton.selected);
        }
    }
}

-(void)setItemSelectedWithState:(BOOL)state{
    self.selectButton.selected = state;
}

@end
