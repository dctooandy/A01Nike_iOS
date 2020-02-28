//
//  BTTMeMoneyHeaderCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMeMoneyHeaderCell.h"

@interface BTTMeMoneyHeaderCell ()
@property (weak, nonatomic) IBOutlet UIButton *assistantBtn;

@end

@implementation BTTMeMoneyHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)rechargeAssistant_click:(id)sender {
    if (self.rechargeAssistantTap) {
        self.rechargeAssistantTap();
    }
}

-(void)setAssistantShow:(BOOL)show{
    self.assistantBtn.hidden = !show;
}

@end
