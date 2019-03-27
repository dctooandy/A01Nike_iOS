//
//  BTTLoginOrRegisterHeaderCell.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterHeaderCell.h"

@interface BTTLoginOrRegisterHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;


@end

@implementation BTTLoginOrRegisterHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    self.iconImage.userInteractionEnabled = YES;
    tap.numberOfTapsRequired = 6;
    [self.iconImage addGestureRecognizer:tap];
}

- (void)tap {
    [MBProgressHUD showMessagNoActivity:[NSString stringWithFormat:@"当前版本是: %@",app_version] toView:nil];
}

@end
