//
//  BTTBookMessageController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Domino on 22/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBookMessageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTBookMessageController (LoadData)


- (void)loadMainData;

- (void)updateBookStatus;

- (void)updateSmsStatusModelWithStats:(BOOL)isON indexPath:(NSIndexPath *)indexPath;

- (void)updateEmailStatusModelWithStats:(BOOL)isON indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
