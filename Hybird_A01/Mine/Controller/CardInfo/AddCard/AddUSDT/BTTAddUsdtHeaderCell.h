//
//  BTTAddUsdtHeaderCell.h
//  Hybird_A01
//
//  Created by Levy on 1/31/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTAddUsdtHeaderCell : UICollectionViewCell
- (void)setTypeData:(NSArray *)types;
@property (nonatomic, copy) void (^tapProtocol)(NSString *protocol);
@end

NS_ASSUME_NONNULL_END
