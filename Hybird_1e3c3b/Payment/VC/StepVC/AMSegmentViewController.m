//
//  AMSegmentViewController.m
//  HybirdApp
//
//  Created by marks.m on 2018/6/16.
//  Copyright © 2018年 AM-DEV. All rights reserved.
//

#import "AMSegmentViewController.h"
#import "Masonry.h"
#import "CNPayWriteModel.h"

@interface AMSegmentViewController ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign) NSInteger displayItemIndex;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, copy) NSArray<UIViewController *> *displayControllers;

@end

@implementation AMSegmentViewController

#pragma mark - 初始化方法
- (instancetype)initWithItems:(NSArray<UIViewController *> *)items {
    
    self = [super init];
    if (self) {
        _displayItemIndex = 0;
        _currentViewController = [items firstObject];
        self.items = items;
        
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _displayItemIndex = 0;
        _currentViewController = nil;
    }
    return self;
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _displayItemIndex = 0;
        _currentViewController = viewController;
    }
    return self;
}

- (void)addOrUpdateDisplayViewController:(UIViewController *)viewController {
    
    _displayItemIndex = 0;
    if (_currentViewController) {
        if ([_currentViewController.view superview]) {
            [_currentViewController.view removeFromSuperview];
        }
        [_currentViewController removeFromParentViewController];
    }
    _currentViewController = viewController;
   
    [self displayServiceController:_currentViewController];
}

#pragma mark - 系统生命周期方法

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.writeModel = [[CNPayWriteModel alloc] init];
}

- (void)setupView {
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    /// 显示默认界面
    if (_currentViewController) {
        [self displayServiceController:_currentViewController];
    }
}

- (void)displayServiceController:(UIViewController *)serviceVC {
    [self addChildViewController:serviceVC];
    [_containerView addSubview:serviceVC.view];
    [serviceVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [serviceVC didMoveToParentViewController:self];
}

- (void)setItems:(NSArray<UIViewController *> *)items {
    _items = items;
    _displayControllers = items;
}

#pragma mark - 与视图切换相关

- (void)transitionItemsToIndex:(NSInteger)to complteBlock:(TransitionFinshBlock)complteHandler {

    if (to == _displayItemIndex) {
        return;
    }
    [self switchChildViewController:_displayControllers[_displayItemIndex] toViewController:_displayControllers[to] iSFromLeft:to > _displayItemIndex block:^{
        if (complteHandler) {
            complteHandler(to);
        }
    }];
    _displayItemIndex = to;
}


- (void)switchChildViewController:(UIViewController *)from toViewController:(UIViewController *)to iSFromLeft:(BOOL)isLeft block:(dispatch_block_t)block {
    to.view.translatesAutoresizingMaskIntoConstraints = YES;
    [from willMoveToParentViewController:nil];
    [self addChildViewController:to];
    
    CGRect fromEndFrame;
    CGRect toEndFrame;
    CGFloat containerWidth = _containerView.bounds.size.width;
    if (!isLeft) {
        to.view.frame = (CGRect){ .origin = {-containerWidth, 0}, .size = _containerView.bounds.size };
        toEndFrame = (CGRect){ .origin = CGPointZero, .size = _containerView.frame.size };
        fromEndFrame = (CGRect){ .origin = {containerWidth, 0}, .size = _containerView.bounds.size };
    } else {
        to.view.frame = (CGRect){ .origin = {containerWidth, 0}, .size = _containerView.bounds.size };
        toEndFrame = (CGRect){ .origin = CGPointZero, .size = _containerView.frame.size };
        fromEndFrame = (CGRect){ .origin = {-containerWidth, 0}, .size = _containerView.bounds.size };
    }
    
    [self transitionFromViewController:from toViewController:to duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
        to.view.frame = toEndFrame;
        from.view.frame = fromEndFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            [from removeFromParentViewController];
            [to didMoveToParentViewController:self];
            if (block) {
                block();
            }
        }
    }];
}

- (NSInteger)getCurrentDisplayItemIndex {
    return _displayItemIndex;
}

@end
