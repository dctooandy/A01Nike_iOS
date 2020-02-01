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
    double amount = 0;
    for (int i =0; i<model.xmList.count; i++) {
        amount = amount+model.xmList[i].xmAmount;
        if (i==model.xmList.count-1) {
            self.totalLabel.text = [NSString stringWithFormat:@"%@元",[PublicMethod transferNumToThousandFormat:amount]];
        }
    }
    
}

@end
