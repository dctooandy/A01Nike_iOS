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

@property (weak, nonatomic) IBOutlet UIImageView *hotIcon;

@end

@implementation BTTGameCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setGameIcon:(NSString *)gameIcon {
    _gameIcon = gameIcon;
    if (_gameIcon.length) {
        self.gameIconImageView.image = ImageNamed(gameIcon);
    } else {
        self.gameIconImageView.image = ImageNamed(@"default_1");
    }
    
    if ([IVNetwork userInfo]) {
        self.tryPlayIcon.hidden = YES;
    } else {
        if ([self.gameName isEqualToString:@"沙巴体育"] || [self.gameName isEqualToString:@"AG彩票"]) {
            self.tryPlayIcon.hidden = YES;
        } else {
            self.tryPlayIcon.hidden = NO;
        }
    }
//    if ([self.gameName isEqualToString:@"BTI体育"]) {
//        self.hotIcon.hidden = NO;
//    } else {
//        self.hotIcon.hidden = YES;
//    }
}

- (void)setGameName:(NSString *)gameName {
    _gameName = gameName;
    self.gameNameLabel.text = _gameName;
}

@end
