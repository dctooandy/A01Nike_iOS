//
//  BTTBishangStep1VC.m
//  Hybird_1e3c3b
//
//  Created by Domino on 04/07/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBishangStep1VC.h"
#import "BTTLive800ViewController.h"

@interface BTTBishangStep1VC ()

@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;

@property (weak, nonatomic) IBOutlet UIButton *WXbtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation BTTBishangStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)alipayBtnClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    self.WXbtn.selected = NO;
}

- (IBAction)wxBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.alipayBtn.selected = NO;
}

- (IBAction)confirmBtnClick:(UIButton *)sender {
    NSLog(@"confirmBtnClick");
    NSString *url = @"https://www.why918.com/chat/chatClient/chatbox.jsp?companyID=8990&configID=126&skillId=44";
    BTTLive800ViewController *live800 = [[BTTLive800ViewController alloc] init];
    live800.webConfigModel.url = url;
    live800.webConfigModel.newView = YES;
    [self pushViewController:live800];
}


@end
