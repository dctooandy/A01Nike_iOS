//
//  BTTWithdrawalSuccessCell.m
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalSuccessCell.h"

@interface BTTWithdrawalSuccessCell ()

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@end

@implementation BTTWithdrawalSuccessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    NSString *name = [[IVNetwork savedUserInfo].loginName containsString:@"usdt"] ? [[IVNetwork savedUserInfo].loginName stringByReplacingOccurrencesOfString:@"usdt" withString:@""] : [IVNetwork savedUserInfo].loginName;
    NSString *noticeStr = [NSString stringWithFormat:@"尊敬的客户%@, 您的取款已经提交成功!",name];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:noticeStr];
    NSRange range = [noticeStr rangeOfString:[IVNetwork savedUserInfo].loginName];
    [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"51abfb"]} range:range];
    self.noticeLabel.attributedText = attstr;
}

@end
