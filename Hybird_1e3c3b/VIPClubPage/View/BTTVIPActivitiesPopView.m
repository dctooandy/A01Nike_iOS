//
//  BTTVIPActivitiesPopView.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/6/17.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPActivitiesPopView.h"
#import "SDCycleScrollView.h"
#import "SDCollectionViewCell.h"

@interface BTTVIPActivitiesPopView()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@end
@implementation BTTVIPActivitiesPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupBannerView];
    [self bringSubviewToFront:self.currentLabel];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
//    [_bannerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, (200 * SCREEN_WIDTH/375)) ];
    [_bannerView setCenter:self.center];
    [_bannerView makeScrollViewScrollToIndex:self.currentIndex];
//    [_bannerView ];
    
}
- (void)setupBannerView {
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self placeholderImage:ImageNamed(@"default_4")];
    [_bannerView setCanZoomIn:YES];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    _bannerView.autoScrollTimeInterval = 0.0f;
    [_bannerView setShowPageControl:NO];
    [_bannerView setAutoScroll:NO];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandlerTwice)];
//    tap.numberOfTapsRequired = 2;
//    [_bannerView.mainView addGestureRecognizer:tap];
//    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss)];
//    tap.numberOfTapsRequired = 1;
//    [_bannerView.mainView addGestureRecognizer:tapOne];
weakSelf(weakSelf)
    _bannerView.tapZoomInBlock = ^(NSInteger currentIndex) {
        [weakSelf tapHandlerTwice];
    };
    _bannerView.dismissBlock = ^{
        [weakSelf tapToDismiss];
    };
    [self addSubview:_bannerView];
}
- (void)tapHandlerTwice
{
    SDCollectionViewCell *cell = [_bannerView.mainView visibleCells][0];
    if ([cell.cellScrollView zoomScale] < 2)
    {
        [cell.cellScrollView setZoomScale:2];
    }else if ([cell.cellScrollView zoomScale] < 3)
    {
        [cell.cellScrollView setZoomScale:3];
    }else
    {
        [cell.cellScrollView setZoomScale:1];
    }
}
- (void)tapToDismiss
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
- (IBAction)bgButtonTap:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
- (void)configWithImageUrls:(NSMutableArray *)imageUrls currentImageIndex:(NSInteger)currentIndex
{
    _bannerView.imageURLStringsGroup = [imageUrls copy];
    NSInteger totalCount = imageUrls.count;
    _currentIndex = currentIndex;
    self.currentLabel.text = [NSString stringWithFormat:@"%ld/%ld",(currentIndex = 1),totalCount];
    
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    if (self.clickEventBlock) {
//        self.clickEventBlock(@(index));
//    }
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    NSInteger totalCount = self.bannerView.imageURLStringsGroup.count;
    self.currentLabel.text = [NSString stringWithFormat:@"%ld/%ld",(index + 1),totalCount];
}

@end
