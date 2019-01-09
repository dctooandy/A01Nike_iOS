//
//  CNPayQRCell.h
//  Hybird_A01
//
//  Created by cean.q on 2018/11/26.
//  Copyright © 2018 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNPayQRCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *channelIconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;

@property (weak, nonatomic) IBOutlet UIImageView *tuijianIcon;


@end

NS_ASSUME_NONNULL_END
