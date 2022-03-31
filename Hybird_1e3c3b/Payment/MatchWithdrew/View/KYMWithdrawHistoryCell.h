//
//  KYMWithdrawHistoryCell.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/3/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYMWithdrawHistoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KYMWithdrawHistoryCell : UICollectionViewCell
@property (nonatomic, strong) KYMWithdrawHistoryView *historyView;
@property (nonatomic, assign) BOOL isManualStatus; //是否人工挂起
@end

NS_ASSUME_NONNULL_END
