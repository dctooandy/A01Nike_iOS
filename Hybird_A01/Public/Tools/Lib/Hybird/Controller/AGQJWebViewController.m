//
//  AGQJWebViewController.m
//  MainHybird
//
//  Created by Key on 2018/7/2.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "AGQJWebViewController.h"
#import "NSString+Expand.h"
@interface AGQJWebViewController ()

@end

@implementation AGQJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didEnterBackgroundNotification {
    [self.webView removeFromSuperview];
}

- (void)willEnterForegroundNotification {
    [self.view addSubview:self.webView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshBalance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateUI {
    [super updateUI];
    //游戏导航栏添加刷新按钮
    if (![NSString isBlankString:self.webConfigModel.gameType]) {
        UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        refreshBtn.frame = CGRectMake(0, 0, 30, 30);
        [refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        [refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
        self.navigationItem.rightBarButtonItems = @[refreshItem];
    }
}

- (void)refreshBtnClick {
    IVActionHandler handler = ^(UIAlertAction *action) {};
    weakSelf(weakSelf)
    IVActionHandler handler1 = ^(UIAlertAction *action) {
        strongSelf(strongSelf)
        [strongSelf loadWebView];
        [strongSelf refreshBalance];
    };
    [IVUtility showAlertWithActionTitles:@[@"继续游戏",@"立即刷新"] handlers:@[handler,handler1] title:@"提示" message:@"刷新后游戏将会重新开始，您确定要刷新当前的游戏状态吗？"];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *absoluteString = request.URL.absoluteString;
    NSString *domain = [IVNetwork h5Domain];
    NSRange linkRange = [absoluteString rangeOfString:@"link.htm?id"];
    if (linkRange.location != NSNotFound) {
        NSString *tmpURL = [absoluteString substringFromIndex:linkRange.location];
        NSString *tmpDomain = [NSString stringWithFormat:@"%@/%@",domain,tmpURL];
        [self refreshAGQJGameDepositURL:tmpDomain];
        return NO;
    }
    NSRange forwardRange = [absoluteString rangeOfString:@"forwardPage.do?"];
    //如果跳转连接包含空格
    if (forwardRange.location != NSNotFound && [absoluteString containsString:@"%20"]) {
        IVActionHandler handler = ^(UIAlertAction *action) {};
        [IVUtility showAlertWithActionTitles:@[@"我知道了"] handlers:@[handler] title:@"连接失败了!" message:@"您可以点击右上角的刷新按钮重试。"];
        return NO;
    }
    return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

// 刷新AGQJ旗舰厅中的充值，存款页面，拼接accountName,appToken,userToken
- (void)refreshAGQJGameDepositURL:(NSString *)absoluteString {
    NSString *depositURL = @"";
    if ([absoluteString containsString:@"?"]) {
        depositURL = [NSString stringWithFormat:@"%@&accountName=%@&appToken=%@&userToken=%@",absoluteString,[IVNetwork userInfo].loginName,[[IVCacheManager sharedInstance] nativeReadDictionaryForKey:kCacheAppToken],[IVNetwork userInfo].userToken];
    }
    
    else {
        depositURL = [NSString stringWithFormat:@"%@?&accountName=%@&appToken=%@&userToken=%@",absoluteString,[IVNetwork userInfo].loginName,[[IVCacheManager sharedInstance] nativeReadDictionaryForKey:kCacheAppToken],[IVNetwork userInfo].userToken];
    }
    HAWebViewController *vc = [HAWebViewController new];
    vc.webConfigModel.url = depositURL;
    vc.webConfigModel.newView = YES;
    weakSelf(weakSelf)
    dispatch_main_async_safe(^{
        strongSelf(strongSelf)
        [strongSelf.navigationController pushViewController:vc animated:YES];
    });
}

- (void)refreshBalance {
    if (![IVNetwork userInfo]) {
        return;
    }
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setValue:self.webConfigModel.gameCode forKey:@"game_id"];
    [IVNetwork sendRequestWithSubURL:@"game/transfer" paramters:paramters.copy completionBlock:^(IVRequestResultModel *result, id response) {
        if (result.status) {
            NSLog(@"额度刷新成功");
        } else {
            NSLog(@"额度刷新失败");
        }
    }];
}

@end
