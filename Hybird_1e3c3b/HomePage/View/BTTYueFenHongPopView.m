//
//  BTTYueFenHongPopView.m
//  Hybird_1e3c3b
//
//  Created by JerryHU on 2021/1/6.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTYueFenHongPopView.h"

@interface BTTYueFenHongPopView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *oldMemberSunTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabTopLayout;
@end

@implementation BTTYueFenHongPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(BTTYenFenHongModel *)model {
    _model = model;
    BOOL show = [_model.show boolValue] && [model.needMoney integerValue] != 0;
    NSString * titleStr = @"";
    NSString * contentStr = @"";
    NSString * typeStr = [model.type isEqualToString:@"slot"] ? @"电子游戏":@"真人娱乐";
    if (show) {
        titleStr = @"股东分红月月领~第二季";
        NSString * perStr = [NSString stringWithFormat:@"%@%%", model.per];
        NSString * accountStr = [[IVNetwork savedUserInfo].loginName stringByReplacingOccurrencesOfString:@"usdt" withString:@""];
        contentStr = [NSString stringWithFormat:@"尊敬的%@客户, 您可享%@特别大礼包, %@仅需再投%@有效额, 即可每月领%@分红。", accountStr, perStr, typeStr, model.needMoney, model.amount];
    } else {
        titleStr = @"股东分红月月领~第二季";
        contentStr = [NSString stringWithFormat:@"股东分红月月领第二季已上线, \n有效流水不清零 持续累积领分红, \n月月领分红最高180000¥"];
    }
    self.titleLab.text = titleStr;
    self.oldMemberSunTitleLab.hidden = !show;
    self.contentLabTopLayout.constant = show? 60:40;
    self.btnTopLayout.constant = show? 20:25;
    self.contentLab.text = contentStr;
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)btnAction:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

@end
