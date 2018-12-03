//
//  CNPayDepostiBankCell.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/29.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayDepostiBankCell.h"

@implementation CNPayDepostiBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)delete:(id)sender {
    !_deleteHandler ?: _deleteHandler();
}

@end
