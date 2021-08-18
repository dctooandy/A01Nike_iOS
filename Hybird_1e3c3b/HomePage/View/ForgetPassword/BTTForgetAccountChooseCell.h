//
//  BTTForgetAccountChooseCell.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/17/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ChooseBtnClickBlock)(UIButton *button, NSString *str);

@interface BTTForgetAccountChooseCell : BTTBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *correct_s;
@property (nonatomic, copy) NSString *accountNameStr;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) ChooseBtnClickBlock chooseBtnClickBlock;
@end

NS_ASSUME_NONNULL_END
