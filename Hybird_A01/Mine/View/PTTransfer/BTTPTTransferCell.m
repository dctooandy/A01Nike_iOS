//
//  BTTPTTransferCell.m
//  Hybird_A01
//
//  Created by Domino on 26/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPTTransferCell.h"

@interface BTTPTTransferCell ()

@property (weak, nonatomic) IBOutlet UILabel *usableAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *PTAmountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bg1HeightConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bg2HeightConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowHeightConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowWidthConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bg1LabelBottomConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bg2LabelBottomConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bg2LabelTopConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bg1LabelTopConstants;

@end

@implementation BTTPTTransferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    NSString *amountStr = @"3,456,789.01元";
    NSRange range = [amountStr rangeOfString:@"元"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:amountStr];
    
    if (SCREEN_WIDTH == 414) {
        self.usableAmountLabel.font = kFontSystem(20);
        self.PTAmountLabel.font = kFontSystem(20);
        [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],NSFontAttributeName:kFontSystem(13)} range:range];
    } else if (SCREEN_WIDTH == 320) {
        self.usableAmountLabel.font = kFontSystem(13);
        self.PTAmountLabel.font = kFontSystem(13);
        [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],NSFontAttributeName:kFontSystem(10)} range:range];
        self.bg1HeightConstants.constant *= 0.8;
        self.bg2HeightConstants.constant *= 0.8;
        self.arrowWidthConstants.constant *= 0.8;
        self.arrowHeightConstants.constant *= 0.8;
        self.bg1LabelBottomConstants.constant = -15;
        self.bg2LabelBottomConstants.constant = -15;
        self.bg1LabelTopConstants.constant = -15;
        self.bg2LabelTopConstants.constant = -15;
    }
    self.usableAmountLabel.attributedText = attStr;
    self.PTAmountLabel.attributedText = attStr;
}

@end
