//
//  BTTMeMoreSaveMoneyHeaderCell.m
//  Hybird_A01
//
//  Created by Domino on 26/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTMeMoreSaveMoneyHeaderCell.h"

@interface BTTMeMoreSaveMoneyHeaderCell ()

@property (weak, nonatomic) IBOutlet UIButton *xiaoZhuShowBtn;

@end

@implementation BTTMeMoreSaveMoneyHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
//    self.mineArrowsType = BTTMineArrowsTypeNoHidden;
//    BTTMeSaveMoneyShowTypeAll = 0,
//    BTTMeSaveMoneyShowTypeBig = 1,
    if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeAll ||
        self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBig ||
        self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBigOneMore) {
        self.xiaoZhuShowBtn.hidden = YES;
    } else {
        self.xiaoZhuShowBtn.hidden = YES;
    }
}

@end
