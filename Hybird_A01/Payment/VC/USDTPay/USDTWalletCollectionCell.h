//
//  USDTWalletCollectionCell.h
//  Hybird_A01
//
//  Created by Levy on 12/24/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface USDTWalletCollectionCell : UICollectionViewCell

- (void)setCellWithName:(NSString *)name imageName:(NSString *)imageName;

- (void)setItemSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
