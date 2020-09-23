//
//  BTTWithdrawHeaderCell.m
//  Hybird_A01
//
//  Created by Jairo on 05/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTWithdrawHeaderCell.h"

@interface BTTWithdrawHeaderCell()
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;

@end

@implementation BTTWithdrawHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arrowImg.transform = CGAffineTransformMakeRotation(M_PI);
}

@end
