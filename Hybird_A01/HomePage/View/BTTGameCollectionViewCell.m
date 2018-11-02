//
//  BTTGameCollectionViewCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/8/15.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BTTGameCollectionViewCell.h"

@interface BTTGameCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *gameIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *tryPlayIcon;


@end

@implementation BTTGameCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setGameIcon:(NSString *)gameIcon {
    _gameIcon = gameIcon;
    self.gameIconImageView.image = ImageNamed(_gameIcon);
    if ([IVNetwork userInfo]) {
        self.tryPlayIcon.hidden = YES;
    } else {
        self.tryPlayIcon.hidden = NO;
    }
}

- (void)setGameName:(NSString *)gameName {
    _gameName = gameName;
    self.gameNameLabel.text = _gameName;
}

@end
