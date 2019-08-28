//
//  BTTRegisterCheckPopView.m
//  Hybird_A01
//
//  Created by Domino on 21/08/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTRegisterCheckPopView.h"

@interface BTTRegisterCheckPopView ()

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;



@end

@implementation BTTRegisterCheckPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.logoutBtn.layer.cornerRadius = 20;
    
    // 多属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"继续注册 (不推荐)"];
    
    //设置下划线...
    /*
     NSUnderlineStyleNone                                    = 0x00, 无下划线
     NSUnderlineStyleSingle                                  = 0x01, 单行下划线
     NSUnderlineStyleThick NS_ENUM_AVAILABLE(10_0, 7_0)      = 0x02, 粗的下划线
     NSUnderlineStyleDouble NS_ENUM_AVAILABLE(10_0, 7_0)     = 0x09, 双下划线
     */
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:@(NSUnderlineStyleSingle)
                            range:(NSRange){0,[attributeString length]}];
    //此时如果设置字体颜色要这样
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4d90de"] range:NSMakeRange(0,[attributeString length])];
    
    //设置下划线颜色...
    [attributeString addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithHexString:@"4d90de"] range:(NSRange){0,[attributeString length]}];
    [self.registerBtn setAttributedTitle:attributeString forState:UIControlStateNormal];
    
}

- (IBAction)cancelClick:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)logoutClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

- (IBAction)registerClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

@end
