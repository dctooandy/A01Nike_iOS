//
//  VIPActivitiesImageCell.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/6/16.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "VIPActivitiesImageCell.h"
@interface VIPActivitiesImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *acImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

@end
@implementation VIPActivitiesImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    // Initialization code
}
-(void)configForTitle:(NSString *)title withImageUrl:(NSString *)imgUrl
{
    if (![title isEqualToString:@"empty"])
    {
        [_cellLabel setHidden:NO];
        [_cellLabel setText:title];
    }else
    {
        [_cellLabel setHidden:YES];
    }
    [self.acImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
}
@end
