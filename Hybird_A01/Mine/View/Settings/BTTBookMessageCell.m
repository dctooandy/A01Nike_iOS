//
//  BTTBookMessageCell.m
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBookMessageCell.h"
#import "BTTMeMainModel.h"

@interface BTTBookMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation BTTBookMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (SCREEN_WIDTH == 320) {
        self.titleLabel.font = kFontSystem(12);
        self.messageLabel.font = kFontSystem(12);
        self.emailLabel.font = kFontSystem(12);
    }
}


- (IBAction)emailBook:(UISwitch *)sender {
}


- (IBAction)messageBook:(UISwitch *)sender {
}


- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.titleLabel.text = model.name;
    
}

@end
