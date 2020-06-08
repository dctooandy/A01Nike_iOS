//
//  BTTBitollChoseMoneyCell.m
//  Hybird_A01
//
//  Created by Flynn on 2020/6/1.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBitollChoseMoneyCell.h"
#import "CNPayConstant.h"

@interface BTTBitollChoseMoneyCell ()
@property (strong, nonatomic) UIButton *itemButton;
@end

@implementation BTTBitollChoseMoneyCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-90)/4, 36)];
    if (self) {
        UIButton *itemButton = [[UIButton alloc]init];
        itemButton.size = CGSizeMake((SCREEN_WIDTH-90)/4, 36);
        itemButton.imageView.contentMode = UIViewContentModeScaleToFill;
        itemButton.contentHorizontalAlignment = UIViewContentModeScaleToFill;
        itemButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        itemButton.userInteractionEnabled = NO;
        
        [itemButton setBackgroundImage:[self imageWithColor:kBlackBackgroundColor size:itemButton.size] forState:UIControlStateNormal];
        itemButton.layer.cornerRadius = 4.0;
        itemButton.clipsToBounds = YES;
        [itemButton setBackgroundImage:[self imageWithColor:COLOR_RGBA(45, 138, 219, 1) size:itemButton.size] forState:UIControlStateSelected];
        
        [self.contentView addSubview:itemButton];
        _itemButton = itemButton;
        
    }
    return self;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
      
    return img;
}

- (void)setCellWithName:(NSString *)name{
    
    [_itemButton setTitle:name forState:UIControlStateNormal];
}


- (void)setItemSelected:(BOOL)selected{
    if (selected) {
        [_itemButton setSelected:YES];
    }else{
        [_itemButton setSelected:NO];
    }
}

@end
