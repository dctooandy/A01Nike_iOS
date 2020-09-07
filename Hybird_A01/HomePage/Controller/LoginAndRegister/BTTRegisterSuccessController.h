//
//  BTTRegisterSuccessController.h
//  Hybird_A01
//
//  Created by Domino on 14/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTRegisterSuccessController : BTTCollectionViewController

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *mainAccountName;
@property (nonatomic, copy) NSString *pwd;

@property (nonatomic, assign) BTTRegisterOrLoginType registerOrLoginType;

@end

NS_ASSUME_NONNULL_END
