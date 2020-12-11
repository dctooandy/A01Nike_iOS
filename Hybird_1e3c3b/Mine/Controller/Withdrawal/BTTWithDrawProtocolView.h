//
//  BTTWithDrawProtocolView.h
//  Hybird_1e3c3b
//
//  Created by Levy on 3/10/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTWithDrawProtocolView : UICollectionViewCell
- (void)setTypeData:(NSArray *)types;
@property (nonatomic, copy) void (^tapProtocol)(NSString *protocol);

@end

NS_ASSUME_NONNULL_END
