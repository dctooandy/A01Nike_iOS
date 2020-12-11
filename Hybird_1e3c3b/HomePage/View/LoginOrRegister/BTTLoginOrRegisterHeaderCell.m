//
//  BTTLoginOrRegisterHeaderCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterHeaderCell.h"
#import "AppInitializeConfig.h"

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
    NSString *type = @"";
    switch (EnvirmentType) {
        case 0:
        {
            type = @"本地版本";
        }
            break;
        case 1:
        {
            type = @"运测版本";
        }
            break;
        case 2:
        {
            type = @"运营版本";
        }
            break;
        default:
            break;
    }
    [MBProgressHUD showMessagNoActivity:[NSString stringWithFormat:@"当前版本是: %@ %@",app_version,type] toView:nil];
}

@end
