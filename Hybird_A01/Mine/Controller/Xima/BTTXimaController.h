//
//  BTTXimaController.h
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

@class BTTXimaTotalModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTXimaController : BTTCollectionViewController

@property (nonatomic, strong) BTTXimaTotalModel *otherModel;

@property (nonatomic, strong) BTTXimaTotalModel *validModel;

@end

NS_ASSUME_NONNULL_END
