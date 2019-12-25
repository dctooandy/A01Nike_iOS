//
//  BTTUSDTItemCell.m
//  Hybird_A01
//
//  Created by Domino on 24/12/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTUSDTItemCell.h"
#import "BTTUSDTButton.h"

@implementation BTTUSDTItemCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (IBAction)BtnClick:(BTTUSDTButton *)sender {
    [self resetAllBtnWithTag:sender.tag];
}


- (void)resetAllBtnWithTag:(NSInteger)tag {
    for (int i = 0; i < 9; i ++) {
        BTTUSDTButton *btn1 = (BTTUSDTButton *)[self viewWithTag:i + 1000];
        btn1.selected = NO;
        BTTUSDTButton *btn = (BTTUSDTButton *)[self viewWithTag:tag];
        if (!btn.selected) {
            btn.selected = YES;
        }
    }
}

@end
