//
//  BTTMeInfoHiddenCell.m
//  Hybird_A01
//
//  Created by Domino on 22/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTMeInfoHiddenCell.h"
#import "BTTMeMainModel.h"

@interface BTTMeInfoHiddenCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation BTTMeInfoHiddenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"272c3a"];
    if (SCREEN_WIDTH == 320) {
        self.nameLabel.font = kFontSystem(13);
    } else {
        self.nameLabel.font = kFontSystem(14);
    }
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
}

@end
