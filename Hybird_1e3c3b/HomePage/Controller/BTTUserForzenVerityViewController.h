//
//  BTTUserForzenVerityViewController.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/6/30.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTBindingMobileTwoCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTTUserForzenVerityViewController : BTTCollectionViewController
@property (nonatomic, copy) NSString *messageId;
-(UITextField *)getCodeTF;
-(BTTBindingMobileTwoCell *)getVerifyCell;
@end

NS_ASSUME_NONNULL_END
