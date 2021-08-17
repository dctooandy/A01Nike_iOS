//
//  BTTForgetAccountStepTwoController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/16/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTForgetAccountStepTwoController.h"

@interface BTTForgetAccountStepTwoController ()

@end

@implementation BTTForgetAccountStepTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"完成找回账号";
    self.view.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self setupCollectionView];
}

-(void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    
    NSString * titleStr = @"  恭喜您找回帐号,请选择一个账号登入游戏，选择后其他账号会被禁用";
    UILabel * lab = [[UILabel alloc] init];
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:14];
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    /**
     添加图片到指定的位置
     */
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    // 表情图片
    attchImage.image = [UIImage imageNamed:@"ic_forget_warring_logo"];
    // 设置图片大小
    attchImage.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    [attriStr insertAttributedString:stringImage atIndex:0];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [attriStr addAttribute:NSParagraphStyleAttributeName
        value:style
        range:NSMakeRange(0, titleStr.length)];
    
    lab.attributedText = attriStr;
    
    lab.textColor = [UIColor redColor];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

@end
