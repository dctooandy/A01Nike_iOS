//
//  BTTVIPHistoryImageCell.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/9/7.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPHistoryImageCell.h"
#import "GradientImage.h"
@interface BTTVIPHistoryImageCell()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *topYearLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelWidth;

@property (nonatomic, assign) BOOL isFirstLuanchBtn;
@property (weak, nonatomic) NSString *urlString;

@end
@implementation BTTVIPHistoryImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    _isFirstLuanchBtn = YES;
    [self setCorners];
}
- (void)imageConfigForCell:(VIPHistoryImageModel *)model
{
//    _topView.hidden = !model.isFirstData;// 0929 原本:依照年份出现cell,现改为全部都不要有年份
    _topView.hidden  = YES;
    _topYearLabel.text = model.yearString;
    _bottomYearLabel.text = [NSString stringWithFormat:@"%@年%@月",model.yearString,model.monthString];
    _topTitleLabel.text = model.topTitleString;
    _subTitleLabel.text = model.subTitleString;
    [_detailBtn setHidden:!model.details];
    _topLabelWidth.constant = (model.details == YES ? SCREEN_WIDTH * 0.55 : SCREEN_WIDTH * 0.76);
    _urlString = model.url;
    
    if (![model.imageName containsString:@".jpg"] && ![model.imageName containsString:@".png"])
    {
        [_imageView setImage:ImageNamed(model.imageName)];
    }else
    {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURLString] placeholderImage:ImageNamed(@"default_4")];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.detailBtn setBackgroundImage:[GradiImage layerImage:LeftToRight
                                                       colors:@[[UIColor colorWithHexString:@"4C90DE"],
                                                                [UIColor colorWithHexString:@"1473D8"]]
                                                       bounds:self.detailBtn.bounds] forState:UIControlStateNormal];
}
- (void)setCorners
{
    _topView.layer.cornerRadius = 5;
    _topView.layer.masksToBounds = YES;
    
    _bottomView.layer.shadowOffset = CGSizeMake(0, 5);
    _bottomView.layer.shadowOpacity = 0.7;
    _bottomView.layer.shadowRadius = 5 ;
    _bottomView.layer.shadowColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1].CGColor;
    _bottomView.layer.cornerRadius = 5;
//    _bottomView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 5;
    if (@available(iOS 11.0, *)) {
        _imageView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    } else {
        // Fallback on earlier versions
    }
    _imageView.layer.masksToBounds = YES;
}
- (void)pushToNewWebView
{
    UIViewController *topVC = [self currentViewController];
    BTTBaseWebViewController  *webController = [[BTTBaseWebViewController alloc] init];
    webController.webConfigModel.url = self.urlString;
    webController.webConfigModel.newView = YES;
    [webController loadWebView];
    [topVC.navigationController pushViewController:webController animated:YES];
}
- (UIButton *)detailBtn
{
    if (_isFirstLuanchBtn) {
        [_detailBtn addTarget:self action:@selector(pushToNewWebView) forControlEvents:UIControlEventTouchUpInside];
        _detailBtn.layer.cornerRadius = 5;
        _detailBtn.layer.masksToBounds = YES;
        _isFirstLuanchBtn = NO;
    }
    return _detailBtn;
}
- (UIViewController*)topMostWindowController
{
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    UIViewController *topController = [win rootViewController];
    if ([topController isKindOfClass:[UITabBarController class]]) {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    while ([topController presentedViewController])  topController = [topController presentedViewController];
    return topController;
}
- (UIViewController*)currentViewController;
{
    UIViewController *currentViewController = [self topMostWindowController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}
@end
