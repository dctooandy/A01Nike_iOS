//
//  BTTRegisterQuickCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"


NS_ASSUME_NONNULL_BEGIN
typedef void (^BTTMobileVerifyCodeNotLoginBlock)(NSString *phone);

@interface BTTRegisterQuickAutoCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

@property (nonatomic, copy) BTTMobileVerifyCodeNotLoginBlock verifyCodeBlock;

@end

NS_ASSUME_NONNULL_END
