//
//  BTTLockButtonView.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/7.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLockButtonView.h"
#import "BTTUserForzenManager.h"
@interface BTTLockButtonView()
@property (weak, nonatomic) IBOutlet UIButton *lockButton;

@end
@implementation BTTLockButtonView
+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI
{
}
- (IBAction)lockBtn_click:(id)sender {
    if (self.tapLock)
    {
        self.tapLock();
    }
}

@end
