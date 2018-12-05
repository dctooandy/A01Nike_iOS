//
//  BTTVideoGamesFooterCell.m
//  Hybird_A01
//
//  Created by Domino on 29/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGamesFooterCell.h"

@interface BTTVideoGamesFooterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *adImageView;


@end

@implementation BTTVideoGamesFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.adImageView addGestureRecognizer:tap];
    
}


- (IBAction)paizhaoClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)xinshouClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)aboutClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    if (self.clickEventBlock) {
        self.clickEventBlock(gesture.view);
    }
}


@end
