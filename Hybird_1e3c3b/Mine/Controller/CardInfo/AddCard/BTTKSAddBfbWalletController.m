//
//  BTTKSAddBfbWalletController.m
//  Hybird_1e3c3b
//
//  Created by Levy on 3/31/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTKSAddBfbWalletController.h"
#import "CNPayConstant.h"
#import "IVRsaEncryptWrapper.h"

@interface BTTKSAddBfbWalletController ()
@property (weak, nonatomic) IBOutlet UIView *bindView;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *activeAndBindBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@end

@implementation BTTKSAddBfbWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册小金库钱包";
    [self setupViews];
}

- (void)contactService {
    [LiveChat startKeFu:self];
//    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
//        if (errCode != CSServiceCode_Request_Suc) {//异常处理
//            [[CLive800Manager sharedInstance] startLive800Chat:self];
//        }
//    }];
}

-(void)setupViews {
    UIButton * rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(contactService) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.view.backgroundColor = kBlackBackgroundColor;
    _bindView.backgroundColor = kBlackBackgroundColor;
    [_selectedBtn setSelected:YES];
    _activeAndBindBtn.layer.cornerRadius = 4.0;
    _activeAndBindBtn.clipsToBounds = YES;
}

- (IBAction)selectedBtn_click:(id)sender {
//    [_selectedBtn setSelected:!_selectedBtn.selected];
//    if (_selectedBtn.selected) {
//        [_activeAndBindBtn setTitle:@"激活并绑定" forState:UIControlStateNormal];
//    }else{
//        [_activeAndBindBtn setTitle:@"绑定" forState:UIControlStateNormal];
//    }
}

- (IBAction)activeAndBindBtn_click:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"use"] = @"8";
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCreateBfbAccount paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (self.success) {
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:result.body[@"accountNo"] options:0];
                NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            
                self.success(decodedString);
                
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
        
    }];
}

- (IBAction)downLoadBtn_click:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.dcusdt.com/downloadapp.php"]];
}

@end
