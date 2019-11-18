//
//  BTTBaseAnimationPopView.m
//  Hybird_A01
//
//  Created by Domino on 16/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

@implementation BTTBaseAnimationPopView

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}



@end
