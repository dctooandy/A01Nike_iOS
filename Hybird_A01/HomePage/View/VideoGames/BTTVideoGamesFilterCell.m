//
//  BTTVideoGamesFilterCell.m
//  Hybird_A01
//
//  Created by Domino on 27/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGamesFilterCell.h"

@interface BTTVideoGamesFilterCell ()

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIButton *btn4;

@end

@implementation BTTVideoGamesFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.btn1.titleEdgeInsets = UIEdgeInsetsMake(0, -self.btn1.imageView.bounds.size.width+2, 0, self.btn1.imageView.bounds.size.width);
    // button图片的偏移量
    self.btn1.imageEdgeInsets = UIEdgeInsetsMake(0, self.btn1.titleLabel.bounds.size.width, 0, -self.btn1.titleLabel.bounds.size.width);
    
    self.btn2.titleEdgeInsets = UIEdgeInsetsMake(0, -self.btn2.imageView.bounds.size.width+2, 0, self.btn2.imageView.bounds.size.width);
    // button图片的偏移量
    self.btn2.imageEdgeInsets = UIEdgeInsetsMake(0, self.btn2.titleLabel.bounds.size.width, 0, -self.btn2.titleLabel.bounds.size.width);
    
    self.btn3.titleEdgeInsets = UIEdgeInsetsMake(0, -self.btn3.imageView.bounds.size.width+2, 0, self.btn3.imageView.bounds.size.width);
    // button图片的偏移量
    self.btn3.imageEdgeInsets = UIEdgeInsetsMake(0, self.btn3.titleLabel.bounds.size.width, 0, -self.btn3.titleLabel.bounds.size.width);

}

- (IBAction)btn1Click:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)btn2Click:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)btn3Click:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)btn4Click:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (void)setProvider:(NSString *)provider {
    _provider = provider;
    if (_provider.length) {
        [self.btn2 setTitle:_provider forState:UIControlStateNormal];
    }
}

-(void)setTypeStr:(NSString *)typeStr {
    _typeStr = typeStr;
    if (_typeStr.length) {
        [self.btn1 setTitle:_typeStr forState:UIControlStateNormal];
    }
}

@end
