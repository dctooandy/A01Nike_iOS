//
//  BTTVideoGameCell.m
//  Hybird_A01
//
//  Created by Domino on 27/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGameCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BTTVideoGameModel.h"

@interface BTTVideoGameCell ()

@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameIconHeightConstants;

@property (weak, nonatomic) IBOutlet UIButton *label1;

@property (weak, nonatomic) IBOutlet UIButton *label2;

@property (weak, nonatomic) IBOutlet UIButton *label3;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@property (weak, nonatomic) IBOutlet UILabel *btnTitleLabel;
@end

@implementation BTTVideoGameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.gameIconHeightConstants.constant = (SCREEN_WIDTH / 2 - 22.5) / 130 * 90;
    self.label2.hidden = YES;
    self.label3.hidden = YES;
    self.btnTitleLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.btnTitleLabel addGestureRecognizer:tap];
}

- (IBAction)collectionBtnClick:(UIButton *)sender {
    if ([IVNetwork userInfo]) {
        sender.selected = !sender.selected;
        self.model.isFavority = sender.selected;
    } 
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    [self collectionBtnClick:self.collectBtn];
}

- (void)setModel:(BTTVideoGameModel *)model {
    _model = model;
    [self.gameIcon sd_setImageWithURL:[NSURL URLWithString:model.gameImage] placeholderImage:ImageNamed(@"default_1")];
    self.titleLabel.text = model.cnName;
    [self.label1 setTitle:[NSString stringWithFormat:@" %@ ",model.provider] forState:UIControlStateNormal];
    self.collectBtn.selected = model.isFavority;
    if (model.payline.integerValue && model.isPoolGame) {
        self.label2.hidden = NO;
        self.label3.hidden = NO;
        [self.label2 setTitle:[NSString stringWithFormat:@" %@线 ",model.payline] forState:UIControlStateNormal];
        [self.label3 setTitle:@" 彩金 " forState:UIControlStateNormal];
    } else {
        if (model.payline.integerValue || model.isPoolGame) {
            self.label2.hidden = NO;
            if (model.payline.integerValue) {
                [self.label2 setTitle:[NSString stringWithFormat:@" %@线 ",model.payline] forState:UIControlStateNormal];
            } else {
                [self.label2 setTitle:@" 彩金 " forState:UIControlStateNormal];
            }
        } else {
            self.label3.hidden = YES;
            self.label2.hidden = YES;
        }
    }
}


@end
