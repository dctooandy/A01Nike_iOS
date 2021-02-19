//
//  BTTLoginOrRegisterViewController+UI.h
//  Hybird_1e3c3b
//
//  Created by Domino on 13/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterViewController.h"
#import "BTTLoginAPIModel.h"

NS_ASSUME_NONNULL_BEGIN

@class BTTCreateAPIModel;

@interface BTTLoginOrRegisterViewController (UI)

- (void)showPopViewWithAccount:(NSString *)account;

- (void)showPopView;

- (void)showRegisterCheckViewWithModel:(BTTCreateAPIModel *)mdoel;

-(void)showAlert:(NSDictionary *)resultDic model:(BTTLoginAPIModel *)model isBack:(BOOL)isback;

@end

NS_ASSUME_NONNULL_END
