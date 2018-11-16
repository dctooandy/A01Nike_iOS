//
//  BTTMineViewController.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTBindStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTMineViewController : BTTCollectionViewController

@property (nonatomic, assign) BOOL isShowHidden;

@property (nonatomic, strong) BTTBindStatusModel *statusModel;

- (void)setupElements;

@end

NS_ASSUME_NONNULL_END
