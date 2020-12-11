//
//  BTTHomePageAmountsCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/12.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageAmountsCell.h"
#import "UUMarqueeView.h"
#import "BTTAmountModel.h"


@interface BTTHomePageAmountsCell ()<UUMarqueeViewDelegate>

@property (nonatomic, strong) UUMarqueeView *scrollLabelView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;
@end

@implementation BTTHomePageAmountsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    UIBezierPath *topViewMaskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 30, 40)
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *topViewMaskLayer = [CAShapeLayer layer];
    topViewMaskLayer.frame         = self.topView.bounds;
    topViewMaskLayer.path          = topViewMaskPath.CGPath;
    self.topView.layer.mask         = topViewMaskLayer;
    
    self.scrollLabelView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(15, 90, SCREEN_WIDTH - 30, 200)];
    [self.contentView addSubview:self.scrollLabelView];
    self.scrollLabelView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    _scrollLabelView.delegate = self;
    _scrollLabelView.timeIntervalPerScroll = 1.0f;
    _scrollLabelView.timeDurationPerScroll = 0.5f;
    _scrollLabelView.touchEnabled = YES;
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.scrollLabelView.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.scrollLabelView.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.scrollLabelView.layer.mask         = maskLayer;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@高额及高倍盈利",[PublicMethod getCurrentTimesWithFormat:@"yyyy年MM月dd日"]];
}

- (void)setAmounts:(NSMutableArray *)amounts {
    _amounts = amounts;
    [_scrollLabelView reloadData];
    [_scrollLabelView start];
}

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView *)marqueeView {
    return 5;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView *)marqueeView {
    return self.amounts.count;
}

- (void)createItemView:(UIView*)itemView forMarqueeView:(UUMarqueeView*)marqueeView {
    CGFloat itemWidth = (SCREEN_WIDTH - 54) / 4;
    CGFloat itemHeight = itemView.bounds.size.height;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
    [itemView addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:10];
    nameLabel.textColor = [UIColor colorWithHexString:@"66b3ff"];
    nameLabel.tag = 10001;
    
    UILabel *betLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth + 8, 0, itemWidth, itemHeight)];
    [itemView addSubview:betLabel];
    betLabel.textAlignment = NSTextAlignmentCenter;
    betLabel.font = [UIFont systemFontOfSize:10];
    betLabel.tag = 10002;
    betLabel.textColor = [UIColor whiteColor];
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake((itemWidth + 8) * 2, 0, itemWidth, itemHeight)];
    [itemView addSubview:amountLabel];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.font = [UIFont systemFontOfSize:10];
    amountLabel.textColor = COLOR_RGBA(253, 27, 91, 1);
    amountLabel.tag = 10003;
    
    UILabel *gameLabel = [[UILabel alloc] initWithFrame:CGRectMake((itemWidth + 8) * 3, 0, itemWidth, itemHeight)];
    [itemView addSubview:gameLabel];
    gameLabel.textAlignment = NSTextAlignmentCenter;
    gameLabel.font = [UIFont systemFontOfSize:10];
    gameLabel.tag = 10004;
    gameLabel.textColor = [UIColor whiteColor];
    
//    UIView *lineView = [UIView new];
//    [itemView addSubview:lineView];
//    lineView.frame = CGRectMake(0, itemHeight - 0.5, marqueeView.frame.size.width, 0.5);
//    lineView.backgroundColor = [UIColor colorWithHexString:@"4a4d55"];
//    lineView.tag = 10005;
}

- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView  {
    BTTAmountModel *model = _amounts[index];
    UILabel *nameLabel = [itemView viewWithTag:10001];
    nameLabel.text = model.loginName;
    
    UILabel *betLabel = [itemView viewWithTag:10002];
    betLabel.text = model.betAmount;
    
    UILabel *amountLabel = [itemView viewWithTag:10003];
    amountLabel.text = model.cjAmount;
    
    UILabel *gameLabel = [itemView viewWithTag:10004];
    gameLabel.text = model.gameName;
    
//    UIView *lineView = [itemView viewWithTag:10005];
//    lineView.hidden = YES;
}

- (CGFloat)itemViewHeightAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    UILabel *content = [[UILabel alloc] init];
    content.numberOfLines = 0;
    content.font = [UIFont systemFontOfSize:10.0f];
    BTTAmountModel *model = _amounts[index];
    content.text = model.gameName;
    CGSize contentFitSize = [content sizeThatFits:CGSizeMake(CGRectGetWidth(marqueeView.frame) - 5.0f - 16.0f - 5.0f, MAXFLOAT)];
    return contentFitSize.height + 20.0f;
}

@end

