//
//  BTTUserForzenPopView.m
//  Hybird_1e3c3b
//
//  Created by Levy on 1/18/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTUserForzenPopView.h"

@interface BTTUserForzenPopView()

@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@end

@implementation BTTUserForzenPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _dismissButton.layer.cornerRadius = 4.0;
    _dismissButton.clipsToBounds = YES;
}

- (IBAction)activityBtn_click:(id)sender {
    if (self.tapActivity) {
        self.tapActivity();
    }
}
- (IBAction)serviceBtn_click:(id)sender {
    if (self.tapService) {
        self.tapService();
    }
}
- (IBAction)dismissBtn_click:(id)sender {
    if (self.tapDismiss) {
        self.tapDismiss();
    }
}

- (void)setuUserForzenContentMessage:(NSNumber *)message{
    NSString *correctString = (message.intValue <= 183 ? [NSString stringWithFormat:@"您距离上次登录已经过了%@天",message]:[NSString stringWithFormat:@"您已经超过%@天没有登录网站了",message]);
    
    
    _contentLabel.text = [NSString stringWithFormat:@"%@\n为了您的资金安全，我们已经将您的余额暂时锁定\n锁定期间，您的以下操作已经被限制：",correctString];
    
}


@end
