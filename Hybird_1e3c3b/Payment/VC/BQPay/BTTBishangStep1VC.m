//
//  BTTBishangStep1VC.m
//  Hybird_1e3c3b
//
//  Created by Domino on 04/07/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBishangStep1VC.h"

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
    [LiveChat startKeFu:self];
}


@end
