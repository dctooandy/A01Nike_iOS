//
//  BTTLoginOrRegisterViewController+UI.h
//  Hybird_A01
//
//  Created by Domino on 13/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class BTTCreateAPIModel;

@interface BTTLoginOrRegisterViewController (UI)

- (void)showPopViewWithAccount:(NSString *)account;

- (void)showPopView;

- (void)showRegisterCheckViewWithModel:(BTTCreateAPIModel *)mdoel;



@end

NS_ASSUME_NONNULL_END
