//
//  BTTMeBigSaveMoneyCell.h
//  Hybird_A01
//
//  Created by Domino on 26/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface BTTMeBigSaveMoneyCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BTTMeSaveMoneyShowType saveMoneyShowType;

@property (nonatomic, copy) void(^assistantTap)(void);

@end

NS_ASSUME_NONNULL_END
