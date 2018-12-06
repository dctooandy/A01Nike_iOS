//
//  BTTPTTransferController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 20/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPTTransferController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTPTTransferController (LoadData)

- (void)loadMainData;

- (void)loadCreditsTransfer:(BOOL)isReverse amount:(NSString *)amount;

@end

NS_ASSUME_NONNULL_END
