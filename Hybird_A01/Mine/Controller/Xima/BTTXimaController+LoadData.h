//
//  BTTXimaController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTXimaController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTXimaController (LoadData)

@property (nonatomic, strong) NSMutableArray *xms;


- (void)loadMainData;

- (void)loadXimaBillOut;


@end

NS_ASSUME_NONNULL_END
