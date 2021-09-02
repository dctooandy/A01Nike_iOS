//
//  BTTVIPClubHistoryCell.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/4.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPClubHistoryCell.h"
#import "BTTVIPClubWebViewController.h"

@interface BTTVIPClubHistoryCell ()

@property (nonatomic,copy)BTTVIPClubWebViewController *vipWebViewController;



@end
@implementation BTTVIPClubHistoryCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self config];
    
}
-(void)setupWebView
{
    if (!_vipWebViewController)
    {
        _vipWebViewController = [[BTTVIPClubWebViewController alloc] init];
        CGRect frame = self.frame;
        frame.origin.y += 48.0;
        frame.size.height -= 48.0;
        [[_vipWebViewController view] setFrame:frame];
        _vipWebViewController.webConfigModel.newView = YES;
        _vipWebViewController.webConfigModel.url = @"history";
        
        self.vipWebViewController.clickEventBlock = ^(id  _Nonnull value){ // 接收gotoBack事件
            //                        strongSelf(strongSelf)
            //                        [weakSelf.buttonCell vipRightBtnClick:weakSelf.buttonCell.vipRightBtn]; // 返回之後去選擇左邊第一個頁籤
        };
        [self.contentView addSubview:self.vipWebViewController.view];
    }

}
- (void)config{
    [self setupWebView];
}
- (IBAction)moreBtnClick{
    if (self.moreBlock) {
        self.moreBlock();
    }
}
//- (BTTVIPClubWebViewController *)vipWebViewController
//{
//    if (!self.vipWebViewController)
//    {
//        self.vipWebViewController = [[BTTVIPClubWebViewController alloc] init];
//        self.vipWebViewController.webConfigModel.newView = YES;
//        self.vipWebViewController.webConfigModel.url = @"history";
//        self.vipWebViewController.webConfigModel.theme = @"inside";
//    }
//    return self.vipWebViewController;
//}
//- (void)setVipWebViewController:(BTTVIPClubWebViewController *)vipWebViewController
//{
//    self.vipWebViewController = vipWebViewController;
//}
@end
