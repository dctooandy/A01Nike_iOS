//
//  BTTForgetPasswordController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetPasswordController : BTTCollectionViewController

@property (nonatomic, strong) UIImage *codeImage;

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, assign) BTTChooseFindWay findType;

@end

NS_ASSUME_NONNULL_END
