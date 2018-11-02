//
//  BTTCollectionViewController.h
//  A01_Sports
//
//  Created by Domino on 2018/9/27.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseViewController.h"
#import "BTTCollectionViewFlowlayout.h"
#import <MJRefresh/MJRefresh.h>
#import "BTTRefreshGIFHeader.h"


typedef void (^BTTRefreshBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@class BTTCollectionViewController;
@protocol BTTCollectionViewControllerDataSource <NSObject>

@required
// 需要返回对应的布局
- (UICollectionViewLayout *)collectionViewController:(BTTCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView;

@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface BTTCollectionViewController : BTTBaseViewController

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<NSValue *> *elementsHight;

- (void)setupCollectionView;

/**
 下拉刷新
 
 @param refreshBlock 实现Block
 */
- (void)pulldownRefreshWithRefreshBlock:(BTTRefreshBlock)refreshBlock;


/**
 加载更多
 
 @param loadMoreBlock 实现Block
 */
- (void)loadmoreWithBlock:(BTTRefreshBlock)loadMoreBlock;


/**
 停止刷新(footer, header)
 */
- (void)endRefreshing;

- (void)setupElements;

@end

NS_ASSUME_NONNULL_END
