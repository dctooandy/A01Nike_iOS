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

@property (weak, nonatomic) NSString *urlString;

@end
@implementation BTTVIPHistoryImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    // Initialization code
}
- (void)imageConfigForCell:(VIPHistoryImageModel *)model
{
    _topView.hidden = !model.isFirstData;
    _topYearLabel.text = model.yearString;
    _bottomYearLabel.text = [NSString stringWithFormat:@"%@年%@月",model.yearString,model.monthString];
    _topTitleLabel.text = model.topTitleString;
    _subTitleLabel.text = model.subTitleString;
    [_detailBtn addTarget:self action:@selector(pushToNewWebView) forControlEvents:UIControlEventTouchUpInside];
    _urlString = model.url;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _topView.layer.cornerRadius = 5;
    _topView.layer.masksToBounds = YES;
    
    _bottomView.layer.cornerRadius = 5;
    _bottomView.layer.masksToBounds = YES;
    
    _detailBtn.layer.cornerRadius = 5;
    _detailBtn.layer.masksToBounds = YES;
    [self.detailBtn setBackgroundImage:[GradiImage layerImage:LeftToRight
                                                       colors:@[[UIColor colorWithHexString:@"4C90DE"],
                                                                [UIColor colorWithHexString:@"1473D8"]]
                                                       bounds:self.detailBtn.bounds] forState:UIControlStateNormal];
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
