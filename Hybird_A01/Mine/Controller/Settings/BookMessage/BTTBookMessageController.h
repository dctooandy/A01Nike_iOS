//
//  BTTBookMessageController.h
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

@class BTTSMSEmailModifyModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTBookMessageController : BTTCollectionViewController

@property (nonatomic, strong) BTTSMSEmailModifyModel *smsStatus;

@property (nonatomic, strong) BTTSMSEmailModifyModel *emailStatus;

@property (nonatomic, strong) NSMutableArray *smsArray;

@property (nonatomic, strong) NSMutableArray *emailArray;

@end

NS_ASSUME_NONNULL_END
