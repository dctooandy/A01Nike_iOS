//
//  BTTAccountBlanceHiddenCell.m
//  Hybird_A01
//
//  Created by Domino on 22/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAccountBlanceHiddenCell.h"
#import "BTTGamesHallModel.h"


@interface BTTAccountBlanceHiddenCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation BTTAccountBlanceHiddenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"272c3a"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

- (void)setModel:(BTTGamesHallModel *)model {
    _model = model;
    self.nameLabel.text = model.zhName;
    self.amountLabel.text = model.amount;
}

@end
