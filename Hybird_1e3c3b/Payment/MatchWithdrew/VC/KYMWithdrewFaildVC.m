//
//  KYMWithdrewFaildVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/21.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewFaildVC.h"

@interface KYMWithdrewFaildVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameWidth;
@property (weak, nonatomic) IBOutlet UILabel *amountLB;
@property (weak, nonatomic) IBOutlet UILabel *usernameLB;
@end

@implementation KYMWithdrewFaildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.amountLB.text = self.amountStr;
    self.usernameLB.text = self.userName;
    self.usernameWidth.constant = [self.usernameLB.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.usernameLB.font} context:nil].size.width + 2;
}
- (IBAction)submitBtnClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goToBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
