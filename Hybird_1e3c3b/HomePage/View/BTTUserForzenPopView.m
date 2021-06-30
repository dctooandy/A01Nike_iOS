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

- (void)setContentMessage:(NSString *)message{
    _contentLabel.text = message;
}


@end
