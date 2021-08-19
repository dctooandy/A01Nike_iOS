//
//  BTTForgetController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/12/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTForgetController.h"
#import "BTTForgetAccountController.h"
#import "BTTForgetPasswordController.h"
#import "BTTForgetBothController.h"

@interface BTTForgetController ()
@property (nonatomic, assign)NSInteger chooseType;
@end

@implementation BTTForgetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setChooseFindTypeBtn];
}

-(void)setChooseFindTypeBtn {
    [self removeExBtn];
    self.title = @"选择您要找回的资料";
    NSArray * btnTitleArr = @[@"忘记账号？", @"忘记密码？", @"忘记账号, 密码？"];
    for (int i = 0; i < btnTitleArr.count; i++) {
        UIButton * btn = [[UIButton alloc] init];
        btn.tag = i;
        btn.layer.cornerRadius = 4.0;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed: 0.18 green: 0.17 blue: 0.18 alpha: 1.00] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithRed: 0.98 green: 0.85 blue: 0.38 alpha: 1.00];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(SCREEN_WIDTH * 0.85);
            make.height.offset(50);
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(50 + 50*i + 20*(i-1));
        }];
    }
}

-(void)setChooseFindWayBtn:(NSArray *)btnTitleArr {
    [self removeExBtn];
    for (int i = 0; i < btnTitleArr.count; i++) {
        NSString * imgStr = i == 0 ? @"ic_forget_phone_find":@"ic_forget_email_find";
        UIButton * btn = [[UIButton alloc] init];
        btn.tag = i + 1000;
        btn.layer.cornerRadius = 4.0;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed: 0.18 green: 0.17 blue: 0.18 alpha: 1.00] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithRed: 0.98 green: 0.85 blue: 0.38 alpha: 1.00];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(SCREEN_WIDTH * 0.85);
            make.height.offset(50);
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(50 + 50*i + 20*(i-1));
        }];
    }
}

-(void)removeExBtn {
    for (UIView * view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
}

-(void)btnAction:(UIButton *)btn {
    if (btn.tag < 1000) {
        self.chooseType = btn.tag;
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        switch (btn.tag) {
            case BTTForgetAccount:
            {
//                [arr addObject:@"使用绑定手机找回账号"];
//                [arr addObject:@"使用绑定邮箱找回账号"];
//                self.title = @"选择找回账号方式";
                [self findAccount:(NSInteger)BTTFindWithPhone forgetType:BTTForgetAccount];
            }
                break;
            case BTTForgetPassword:
            {
                [arr addObject:@"使用绑定手机找回密码"];
                [arr addObject:@"使用绑定邮箱找回密码"];
                self.title = @"选择找回密码方式";
                [self setChooseFindWayBtn:arr];
            }
                break;
            case BTTForgetBoth:
            {
//                [arr addObject:@"使用绑定手机找回账号, 密码"];
//                [arr addObject:@"使用绑定邮箱找回账号, 密码"];
//                self.title = @"选择找回账号, 密码方式";
                [self findBoth:(NSInteger)BTTFindWithPhone forgetType:BTTForgetBoth];
            }
                break;
                
            default:
                break;
        }
        
    } else {
        switch (self.chooseType) {
            case BTTForgetAccount:
                [self findAccount:btn.tag forgetType:BTTForgetAccount];
                break;
                
            case BTTForgetPassword:
                [self findPassword:btn.tag];
                break;
            case BTTForgetBoth:
                [self findBoth:btn.tag forgetType:BTTForgetBoth];
                break;
        }
    }
}

-(void)findAccount:(NSInteger)type forgetType:(NSInteger)forgetType {
    BTTForgetAccountController * vc = [[BTTForgetAccountController alloc] init];
    vc.findType = (BTTChooseFindWay)type;
    vc.forgetType = (BTTChooseForgetType)forgetType;
    [self.navigationController pushViewController:vc animated:true];
}

-(void)findPassword:(NSInteger)type {
    BTTForgetPasswordController * vc = [[BTTForgetPasswordController alloc] init];
    vc.findType = (BTTChooseFindWay)type;
    [self.navigationController pushViewController:vc animated:true];
}

-(void)findBoth:(NSInteger)type forgetType:(NSInteger)forgetType {
    BTTForgetBothController * vc = [[BTTForgetBothController alloc] init];
    vc.findType = (BTTChooseFindWay)type;
    vc.forgetType = (BTTChooseForgetType)forgetType;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)goToBack {
    NSInteger count = 0;
    for (UIView * view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            count++;
        }
    }
    if (count < 3) {
        [self setChooseFindTypeBtn];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
