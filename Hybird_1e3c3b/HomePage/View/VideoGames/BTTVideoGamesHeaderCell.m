//
//  BTTVideoGamesHeaderCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 27/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGamesHeaderCell.h"

@interface BTTVideoGamesHeaderCell ()

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;


@end

@implementation BTTVideoGamesHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}


- (IBAction)searchBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
