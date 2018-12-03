//
//  CNPayDepostiBankCell.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/29.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayDepostiBankCell.h"

@interface CNPayDepostiBankCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;

@end

@implementation CNPayDepostiBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)delete:(id)sender {
    !_deleteHandler ?: _deleteHandler();
}

- (void)updateContent:(CNPayDepositNameModel *)model {
    self.nameLb.text = model.bank_name;
    self.descLb.text = model.deposit_type;
    self.accountNameLb.text = model.deposit_name;
    self.addressLb.text = model.deposit_location;
}

@end
