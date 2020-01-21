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

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;


@end

@implementation BTTAccountBlanceHiddenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"272c3a"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.amountLabel.hidden = YES;
    [self.activityView startAnimating];
    self.activityView.color = [UIColor whiteColor];
}

- (void)setModel:(platformBanlaceModel *)model {
    _model = model;
    self.nameLabel.text = model.platformName;
    self.amountLabel.text = model.balance;
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
    self.amountLabel.hidden = NO;
    
}

@end
