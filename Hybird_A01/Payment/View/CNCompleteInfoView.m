//
//  CNCompleteInfoView.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/30.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNCompleteInfoView.h"
#import "CNPayNameTF.h"
#import "CNPayRequestManager.h"
#import "MBProgressHUD+Add.h"
#import "CNPayConstant.h"

@interface CNCompleteInfoView ()
@property (weak, nonatomic) IBOutlet CNPayNameTF *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *preSetTF;
@property (nonatomic, copy) dispatch_block_t hander;
@end

@implementation CNCompleteInfoView

+ (void)completeInfoHandler:(dispatch_block_t)handler {
    CNCompleteInfoView *view = [[NSBundle mainBundle] loadNibNamed:@"CNCompleteInfoView" owner:nil options:nil].firstObject;
    view.hander = handler;
    [view show];
}

///显示
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (void)writeInfowithData:(NSDictionary *)data {
//    NSMutableDictionary *userInfo = [[[IVCacheManager sharedInstance] nativeReadDictionaryForKey:cacheKeyUserInfo] mutableCopy];
//    NSString *real_name = data[@"real_name"];
//    NSString *verify_code = data[@"verify_code"];
//    // 先写内存，再写缓存
//    if (real_name.length >0) {
//        [IVNetwork userInfo].real_name = real_name;
//        [userInfo setObject:real_name forKey:@"real_name"];
//    }
//    if (verify_code.length >0) {
//        [IVNetwork userInfo].verify_code = verify_code;
//        [userInfo setObject:verify_code forKey:@"verify_code"];
//    }
    // 将用户信息写入缓存
//    [[IVCacheManager sharedInstance] nativeWriteValue:userInfo forKey:cacheKeyUserInfo];
}

- (IBAction)submitAction:(UIButton *)sender {
    if (self.nameTF.text.length == 0) {
        [MBProgressHUD showError:@"请填写真实姓名" toView:self];
        return;
    }
    if (self.preSetTF.text.length == 0) {
        [MBProgressHUD showError:@"请填写预留信息" toView:self];
        return;
    }
    [MBProgressHUD showLoadingSingleInView:self animated:YES];
    __weak typeof(self) weakSelf = self;
    [CNPayRequestManager paymentCompleteUserName:self.nameTF.text preSet:self.preSetTF.text completeHandler:^(IVRequestResultModel *result, id response) {
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        if (result.status) {
            [weakSelf writeInfowithData:result.data];
            weakSelf.hander();
            [weakSelf giveUp:sender];
        } else {
            [MBProgressHUD showError:result.message toView:self];
        }
    }];
}

- (IBAction)giveUp:(id)sender {
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
