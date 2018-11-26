//
//  BTTXimaSuccessItemCell.m
//  Hybird_A01
//
//  Created by Domino on 24/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTXimaSuccessItemCell.h"
#import "BTTXimaSuccessItemModel.h"

@interface BTTXimaSuccessItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation BTTXimaSuccessItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
}


- (void)setModel:(BTTXimaSuccessItemModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
}

@end
