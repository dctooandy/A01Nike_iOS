//
//  USDTWalletCollectionCell.m
//  Hybird_A01
//
//  Created by Levy on 12/24/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "USDTWalletCollectionCell.h"

@interface USDTWalletCollectionCell()
@property (weak, nonatomic) IBOutlet UIButton *itemButton;

@end

@implementation USDTWalletCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-60)/3, 36)];
    if (self) {
        UIButton *itemButton = [[UIButton alloc]init];
        itemButton.size = CGSizeMake((SCREEN_WIDTH-60)/3, 36);
        itemButton.imageView.contentMode = UIViewContentModeScaleToFill;
        itemButton.contentHorizontalAlignment = UIViewContentModeScaleToFill;
        itemButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        itemButton.userInteractionEnabled = NO;
        [itemButton setBackgroundImage:[UIImage imageNamed:@"me_usdt_item_unselect"] forState:UIControlStateNormal];
        [itemButton setBackgroundImage:[UIImage imageNamed:@"me_usdt_item_select"] forState:UIControlStateSelected];
        
        [itemButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 6, 0)];
        [itemButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 6, 0)];
        [self.contentView addSubview:itemButton];
        _itemButton = itemButton;
        
    }
    return self;
}

- (void)setCellWithName:(NSString *)name imageName:(NSString *)imageName{
    NSString*resultStr=[name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] capitalizedString]];

    [_itemButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_itemButton setTitle:resultStr forState:UIControlStateNormal];
}


- (void)setItemSelected:(BOOL)selected{
    if (selected) {
        [_itemButton setSelected:YES];
    }else{
        [_itemButton setSelected:NO];
    }
}

@end
