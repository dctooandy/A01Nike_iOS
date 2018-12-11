//
//  BTTVideoGamesListController.h
//  Hybird_A01
//
//  Created by Domino on 26/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTPosterModel.h"

typedef void(^BTTSelectValueBlock)(NSString *value);

NS_ASSUME_NONNULL_BEGIN

@interface BTTVideoGamesListController : BTTCollectionViewController

@property (nonatomic, strong) NSMutableArray *banners;

@property (nonatomic, strong) NSMutableArray *imageUrls;

@property (nonatomic, strong) NSMutableArray *favorites;

@property (nonatomic, copy) BTTSelectValueBlock selectValueBlock;

@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, assign) BOOL isShowFooter; ///< 是不是显示页脚

@property (nonatomic, strong) BTTPosterModel *poster; // 广告

@end

NS_ASSUME_NONNULL_END
