//
//  BTTBindingMobileTwoCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
@class BTTMeMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTBindingMobileTwoCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTMeMainModel *model;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

- (void)countDown;
- (void)cancelCountDown;
@end

NS_ASSUME_NONNULL_END
