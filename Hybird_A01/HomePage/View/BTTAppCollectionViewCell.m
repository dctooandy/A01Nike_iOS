//
//  BTTAppCollectionViewCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/8/15.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BTTAppCollectionViewCell.h"
#import "BTTAppIconModel.h"

@interface BTTAppCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *appName;


@end

@implementation BTTAppCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAppIconModel:(BTTAppIconModel *)appIconModel {
    _appIconModel = appIconModel;
    self.iconImageView.image = ImageNamed(_appIconModel.icon);
    self.appName.text = _appIconModel.name;
}

@end
