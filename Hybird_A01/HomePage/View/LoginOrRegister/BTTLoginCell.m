//
//  BTTLoginCell.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginCell.h"

@interface BTTLoginCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation BTTLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.bgView.layer.cornerRadius = 5;
}

@end
