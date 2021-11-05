//
//  BTTVIPClubPageViewController.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/4/16.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTYenFenHongModel.h"
#import "AssistiveButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTVIPClubPageViewController : BTTBaseViewController
@property (nonatomic, assign) BTTVIPPageType selectedType;

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, assign) BOOL isVIP;

@property (nonatomic, assign) BOOL idDisable;
-(void)setupElements;
//- (void)setupElements;
@end

NS_ASSUME_NONNULL_END
