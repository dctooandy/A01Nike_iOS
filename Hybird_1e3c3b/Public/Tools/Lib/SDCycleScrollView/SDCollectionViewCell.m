//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */


#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"

@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupScrollView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}
- (void)setupScrollView
{
    _canZoomIn = NO;
    UIScrollView * cellScrollView = [[UIScrollView alloc] init];
    cellScrollView.frame = self.contentView.bounds;
    _cellScrollView = cellScrollView;
    [self.contentView addSubview:_cellScrollView];
    
    cellScrollView.delegate = self;
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [_cellScrollView addSubview:imageView];
    cellScrollView.contentSize = imageView.image.size;

    [_imageView setUserInteractionEnabled:YES];
}
- (void)tapHandlerTwice
{
    if (self.tapForZoomIn)
    {
        self.tapForZoomIn();
    }
}
- (void)tapToDismiss
{
    if (self.dismissTap)
    {
        self.dismissTap();
    }
}
- (void)setTapActions
{
//    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandlerTwice)];
//    [_imageView addGestureRecognizer:longpress];
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss)];
    tapOne.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:tapOne];

}
- (void)resetImageView
{
    [_imageView removeFromSuperview];
    [_cellScrollView removeFromSuperview];
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [_imageView setUserInteractionEnabled:YES];
    [self.contentView addSubview:_imageView];
}
- (void)setCanZoomIn:(BOOL)canZoomIn
{
    _canZoomIn = canZoomIn;
    if (canZoomIn == YES)
    {
        [self setTapActions];
        [_cellScrollView setBackgroundColor:[UIColor blackColor]];
        _cellScrollView.minimumZoomScale = 0.3;
        _cellScrollView.maximumZoomScale = 3;
    }else
    {
        [self resetImageView];
        [_cellScrollView setBackgroundColor:[UIColor clearColor]];
        _cellScrollView.minimumZoomScale = 1;
        _cellScrollView.maximumZoomScale = 1;
    }
}
//- (void)setupImageView
//{
//    UIImageView *imageView = [[UIImageView alloc] init];
//    _imageView = imageView;
//    [self.contentView addSubview:imageView];
//}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return  _imageView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scrollView.zoomScale != 1)
    {
//        _imageView.center = CGPointMake(scrollView.contentSize.width / 2, scrollView.contentSize.height / 2);
        [UIView animateWithDuration:0.3 animations:^{
            scrollView.zoomScale = 1;
        }];
    }
}
- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}

-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment
{
    _titleLabelTextAlignment = titleLabelTextAlignment;
    _titleLabel.textAlignment = titleLabelTextAlignment;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        _cellScrollView.frame = self.bounds;
        _imageView.frame = self.bounds;
        CGFloat titleLabelW = self.sd_width;
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = 0;//self.sd_height - titleLabelH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
}

@end
