//
//  BTTIntroductoryPagesView.m
//  Hybird_A01
//
//  Created by domino on 2018/10/01.
//  Copyright © 2018年 domino. All rights reserved.
//

#import "BTTIntroductoryPagesView.h"
#import <YYAnimatedImageView.h>
#import <YYImage.h>

@interface BTTIntroductoryPagesView ()<UIScrollViewDelegate>
/** <#digest#> */
@property (nonatomic, strong) NSArray<NSString *> *imagesArray;

@property (nonatomic,strong) UIPageControl *pageControl;

/** <#digest#> */
@property (weak, nonatomic) UIScrollView *scrollView;

@end

@implementation BTTIntroductoryPagesView

+ (instancetype)pagesViewWithFrame:(CGRect)frame images:(NSArray<NSString *> *)images {
    BTTIntroductoryPagesView *pagesView = [[self alloc] initWithFrame:frame];
    pagesView.imagesArray = images;
    return pagesView;
}



- (void)setupUIOnce {
    self.backgroundColor = [UIColor clearColor];
    
    //添加手势
    UITapGestureRecognizer *singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:singleRecognizer];
}

- (void)setImagesArray:(NSArray<NSString *> *)imagesArray {
    _imagesArray = imagesArray;
    [self loadPageView];
}

- (void)loadPageView {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView.contentSize = CGSizeMake((self.imagesArray.count + 1) * SCREEN_WIDTH, SCREEN_HEIGHT);
    self.pageControl.numberOfPages = self.imagesArray.count;
    
    [self.imagesArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc]init];
        
        imageView.frame = CGRectMake(idx * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        YYImage *image = [YYImage imageNamed:obj];
        
        [imageView setImage:image];
        
        [self.scrollView addSubview:imageView];
    }];
}

- (void)handleSingleTapFrom {
    if (_pageControl.currentPage == self.imagesArray.count-1) {
        [self removeFromSuperview];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    NSInteger page = (offSet.x / (self.bounds.size.width) + 0.5);
    self.pageControl.currentPage = page;//计算当前的页码
    self.pageControl.hidden = (page > self.imagesArray.count - 1);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= (_imagesArray.count) * SCREEN_WIDTH) {
        [self removeFromSuperview];
    }
}


- (UIScrollView *)scrollView {
    if(!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollView];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;//设置分页
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if(!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 60, 0, 40)];
        pageControl.backgroundColor = [UIColor whiteColor];
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUIOnce];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


@end
