//
//  BTTForgetFinalController.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/18/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetFinalController : BTTCollectionViewController
@property (nonatomic, assign) BTTChooseForgetType forgetType;
@property (nonatomic, assign) BOOL isBothLastStep;
@property (nonatomic, copy) NSString *accountStr;
@property (nonatomic, copy) NSArray *btnTitleArr;
@property (nonatomic, copy) NSString *validateId;
@property (nonatomic, copy) NSString *messageId;
@end

NS_ASSUME_NONNULL_END
