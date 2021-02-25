//
//  BTTWithdrawRecordController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 05/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTWithdrawRecordController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTWithdrawRecordController (LoadData)
-(void)loadRecords;
-(void)deleteRecords;
-(void)cancelRequest:(NSString *)referenceId;
@end

NS_ASSUME_NONNULL_END
