//
//  HAWebViewController.m
//  MainHybird
//
//  Created by Key on 2018/6/7.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "HAWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BridgeModel.h"
#import <objc/message.h>
#import "WebconfigModel.h"
#import "WebViewUserAgaent.h"
#import "BridgeProtocolExternal.h"
#import "NSString+Expand.h"
#import "UIView+FrameCategory.h"

@interface HAWebViewController ()
@property(nonatomic, strong, readwrite) HAWebView *webView;
@property(nonatomic, strong) HAWKWebView *wkWebView;
@property(nonatomic, strong) JSContext *jsContext;
@property (assign, nonatomic) BOOL judgePTGame;
@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, assign) BOOL isHiddenNavBar; //是否已经向上滑动隐藏了navigationBar
@property (nonatomic, copy) NSDictionary *backUrlDic;
@property(nonatomic, strong)BridgeProtocol *protocol;

@end

@implementation HAWebViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.protocol = [BridgeProtocolExternal new];
        self.protocol.controller = self;
    }
    return self;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (![NSString isBlankString:self.webConfigModel.gameType]) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [App_Theme valueForKey:NSBackgroundColorAttributeName];
    //如果不是预加载，则加载webview
    if (![self isPreloading]) {
        [self loadWebView];
    }
    // 监听横竖屏切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //预加载的页面每次通知h5刷新，不是预加载的页面第一次不通知h5刷新(在webview加载完成回调通知)
    if ([self isPreloading] || _loaded) {
        [self loadFinishCallJS];
    }
    _loaded = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat webViewH = self.view.newHeight + [self safeBottomMargin];
    self.webView.frame = CGRectMake(0, 0, self.view.newWidth, webViewH);
    self.wkWebView.frame = CGRectMake(0, 0, self.view.newWidth, webViewH);
}

- (CGFloat)navigationHeight {
    CGRect statusFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat navigationHeight = 0.0f;
    navigationHeight = 44.0 + CGRectGetHeight(statusFrame);
    return navigationHeight;
}

- (CGFloat)safeBottomMargin {
    CGFloat safeBottom = 0.0;
    BOOL isIphoneX = NO;
    if ([[UIDevice iPhoneName] containsString:@"iPhone X"]
        || ([[UIDevice iPhoneName] containsString:@"iOS Simulator"]
            && SCREEN_HEIGHT == 812))
    {
        isIphoneX = YES;
    }
    if (isIphoneX && self.webConfigModel.newView)
    {
        safeBottom = 34.0;
    }
    return safeBottom;
}

- (void)updateSubViewsIsWKWebView:(BOOL)isWKWebView {
    if (isWKWebView) {
        if ([self.view.subviews containsObject:self.webView]) {
            [self.webView removeFromSuperview];
        }
        [self.view addSubview:self.wkWebView];
    } else {
        if ([self.view.subviews containsObject:self.wkWebView]) {
            [self.wkWebView removeFromSuperview];
        }
        [self.view addSubview:self.webView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --------------------加载webview----------------------------------------

- (void)loadWebView {
    NSString *urlStr = self.webConfigModel.url;
    if (![urlStr hasPrefix:@"http"]) {
        urlStr = LocalHtmlPath(self.webConfigModel.url);
    }
    if (!self.webConfigModel.isAGQJ) {
        if ([urlStr hasPrefix:@"/"]) {
            urlStr = [urlStr substringFromIndex:1];
        }
    }
    
//2018.9.18, rea.x说post是前CTO提出的，现在已经废弃
//    if (![urlStr hasPrefix:@"http"]) {
//        urlStr = [NSString getURL:urlStr queryParameters:[self commonH5ArgumentWithUserParameters:@{}]];
//    } else {
//        //对参数中的#号进行urlencode
//        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"#"];
//        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:set.invertedSet];
//    }
//    NSURLRequest *request = nil;
//    if ([urlStr hasPrefix:@"http"]) {
//        if ([_webConfigModel.gameType isEqualToString:@"AGIN"] ||
//            [_webConfigModel.gameType isEqualToString:@"MG"]) {
//            request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//        } else {
//            NSMutableURLRequest *temp = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//            NSString *localDomain = [[HACacheManager sharedInstance] nativeReadDictionaryForKey:kCacheH5Domain];
//            if (![NSString isBlankString:localDomain] && [urlStr hasPrefix:localDomain]) {
//                [temp setHTTPMethod:@"POST"];
//                NSDictionary *bodyDict = [self commonH5ArgumentWithUserParameters:@{}];
//                NSString *bodyString = [NSString handleRequestPostParams:bodyDict];
//                NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
//                [temp setHTTPBody:bodyData];
//            } else {
//                [temp setHTTPMethod:@"GET"];
//            }
//            request = [temp copy];
//        }
//
//    } else {
//        request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    }
    
    urlStr = [NSString getURL:urlStr queryParameters:[self commonH5ArgumentWithUserParameters:@{}]];
    if ([urlStr hasPrefix:@"http"]) {
        //对参数中的#号进行urlencode
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"#"];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:set.invertedSet];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];

    weakSelf(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        strongSelf(strongSelf)
        [strongSelf updateUI];
        if ([strongSelf.view.subviews containsObject:strongSelf.webView]) {
            [strongSelf.webView loadRequest:request];
        } else {
            [strongSelf.wkWebView loadRequest:request];
        }
    });
}

//更新UI
- (void)updateUI {
    //游戏可以旋转，其他强制竖屏
    if (![NSString isBlankString:self.webConfigModel.gameType]) {
        //添加手势
        UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipDownGesture:)];
        swipDown.direction = UISwipeGestureRecognizerDirectionDown;
        swipDown.delegate = self;
        [self.view addGestureRecognizer:swipDown];
        
        UISwipeGestureRecognizer *swipUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipUpGesture:)];
        swipUp.direction = UISwipeGestureRecognizerDirectionUp;
        swipUp.delegate = self;
        [self.view addGestureRecognizer:swipUp];
    }
    //调整webview的布局
    if ([_webConfigModel.gameType isEqualToString:@"AGIN"] ||
        [_webConfigModel.gameType isEqualToString:@"MG"]) {//AG国际厅和MG游戏用WKWebView展示
        [self updateSubViewsIsWKWebView:YES];
    } else {
        [self updateSubViewsIsWKWebView:NO];
    }
    
    //通知外部项目协议更新UI
    BridgeModel *model = [BridgeModel new];
    model.service = @"outside";
    model.method = @"updateUI";
    [self handBridgeProtocolWithModel:model];
}

- (void)deviceOrientationDidChange:(NSNotification *)noti {
    if (_webConfigModel.gameType) {
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationLandscapeRight:
            case UIDeviceOrientationLandscapeLeft:
                self.navigationController.navigationBarHidden = YES;
                break;
            case UIDeviceOrientationPortrait:
                if (!self.isHiddenNavBar) {
                    self.navigationController.navigationBarHidden = NO;
                }
                break;
            default:
                break;
        }
    }
}
//向上滑动手势隐藏导航栏
- (void)swipUpGesture:(UIGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        self.navigationController.navigationBarHidden = YES;
        self.isHiddenNavBar = YES;
    }
}
//向下滑动手势显示导航栏
- (void)swipDownGesture:(UIGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        self.navigationController.navigationBarHidden = NO;
        self.isHiddenNavBar = NO;
    }
}

/**
 *  H5业务组合公共参数
 *
 *  @param parameters 业务自定义参数
 *
 *  @return 包含公共参数的请求参数
 */
- (NSMutableDictionary *)commonH5ArgumentWithUserParameters:(NSDictionary *)parameters {
    NSMutableDictionary *argument = nil;
    if (parameters) {
        argument = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }else{
        argument = @{}.mutableCopy;
    }
    NSString *appToken = [[IVCacheManager sharedInstance] nativeReadDictionaryForKey:kCacheAppToken];
    argument[@"appToken"] =  appToken ? appToken : @"";
    NSString *udid = @"";
    argument[@"deviceid"] = [NSString isBlankString:udid] ? [UIDevice uuidForDevice] : udid;
    if ([IVNetwork userInfo]) {
        argument[@"userToken"] = [IVNetwork userInfo].userToken;
        argument[@"accountName"] = [IVNetwork userInfo].loginName;
    } 
    return argument;
}

#pragma mark -----------------bridge相关操作-----------------------------------------------

- (BOOL)isPreloading {
    return NO;
}

/**
 jsContext加载成功后通知js可以使用hybird
 */
- (void)loadFinishCallJS {
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"requestId"] = @"0";
    dic[@"method"] = @"loadFinish";
    dic[@"data"] = @"1";
    [self nativeCallJSFunctionName:@"JSCallback" arguments:dic];
}

- (id)nativeCallJSFunctionName:(NSString *)functionName arguments:(NSDictionary *)arguments {
    arguments = arguments?arguments:@{};
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@)",functionName,[IVUtility dictionaryToJSONString:arguments]]];
    return nil;;
}

#pragma mark ------------------------------getter、setter----------------------------------------------
- (HAWebView *)webView {
    if (!_webView) {
        _webView = [[HAWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
    }
    return _webView;
}
- (HAWKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[HAWKWebView alloc] initWithFrame:self.view.bounds];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
    }
    return _wkWebView;
}

- (NSDictionary *)backUrlDic {
    if (!_backUrlDic) {
        NSString *configUrl = [NSString stringWithFormat:@"%@/__config/config.json",WebAppPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:configUrl]) {
            NSData *data = [NSData dataWithContentsOfFile:configUrl];
            _backUrlDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        }
    }
    return _backUrlDic;
}

- (WebConfigModel *)webConfigModel {
    if (!_webConfigModel) {
        _webConfigModel = [WebConfigModel new];
    }
    return _webConfigModel;
}
#pragma mark --------------------uiwebview delegate-----------------------------------------

- (void)showLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.webView.frame.origin.y) {
            self.hud = [BTTProgressHUD showOnlyHUDOrCustom:BTTProgressHUDCustom images:@[@"dropdown_loading_01",@"dropdown_loading_02",@"dropdown_loading_03"] toView:self.view];
        } else {
            self.hud = [BTTProgressHUD showOnlyHUDOrCustom:BTTProgressHUDCustom images:@[@"dropdown_loading_01",@"dropdown_loading_02",@"dropdown_loading_03"] toView:self.webView];
        }
    });
}

- (void)hideLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud dismiss];
    });
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (!self.isLoaded) {
        [self showLoading];
        self.isLoaded = YES;
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //隐藏800的退出按钮
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('exitChat').style.display='none';"];
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue){
        context.exception = exceptionValue;
    };
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.querySelector('#proTitle').innerHTML"];
    if (![NSString isBlankString:title]) {
        self.navigationItem.title = [title stringByRemovingPercentEncoding];
    } else if(![NSString isBlankString:self.webConfigModel.title]) {
        self.navigationItem.title = self.webConfigModel.title;
    }
    //注册js调用native的通用函数appInvoke
    weakSelf(weakSelf)
    self.jsContext[@"appInvoke"] = ^(id jsParam){
        strongSelf(strongSelf)
        //通知外部项目，只供调试使用
#if DEBUG
        BridgeModel *model = [BridgeModel new];
        model.service = @"outside";
        model.method = @"debug";
        model.data = @{@"jsParam" : jsParam};
        [strongSelf handBridgeProtocolWithModel:model];
#else
        
#endif
        
        BridgeModel *model1 = [[BridgeModel alloc] initWithString:jsParam usingEncoding:NSUTF8StringEncoding error:nil];
        return [strongSelf handBridgeProtocolWithModel:model1];
    };
    //如果是预加载的界面，则在viewWillAppear方法中通知h5刷新;
    if (![self isPreloading]) {
        [self loadFinishCallJS];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *absoluteString = request.URL.absoluteString;
    NSLog(@"absoluteString:%@ | navigationType: %d",absoluteString, (int)navigationType);
    if (navigationType == UIWebViewNavigationTypeOther) {
        if (![absoluteString hasPrefix:@"http"] &&
            ![absoluteString hasPrefix:@"file"]) {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
    }
    
    BOOL shouldStartLoad = [self webViewForwardWithAbsoluteString:absoluteString];
    if (!shouldStartLoad) {
        return NO;
    }
    if (!self.judgePTGame) {
        if ([absoluteString containsString:@"loginToPTGame.htm"] || [absoluteString containsString:@"toGamePt.htm"]) {
            [WebViewUserAgaent writePTIOSUserAgent];
            [self.webView loadRequest:request];
            self.judgePTGame = YES;
            return NO;
        }
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoading];
    if (error) {
        NSLog(@"加载页面错误：%@",error);
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(error.code == NSURLErrorCancelled){
        return;
    }
}
#pragma mark --------------------WKNavigationDelegate-----------------------------------------
// 请求开始前，会先调用此代理方法
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [self showLoading];
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 在响应完成时，会回调此方法
// 如果设置为不允许响应，web内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    [self hideLoading];
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 开始导航跳转时会回调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
    NSString *absoluteString = webView.URL.absoluteString;
    [self webViewForwardWithAbsoluteString:absoluteString];
}

// 接收到重定向时会回调
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

// 页面内容到达main frame时回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
}
// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}
#ifdef  __IPHONE_9_0
// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}
#endif

- (BOOL)webViewForwardWithAbsoluteString:(NSString *)absoluteString {
    BOOL isEqual = NO;
    
    if ([absoluteString containsString:@"Error"]) {
        isEqual = YES;
    }
    
    for (NSString *gateway in [IVNetwork gateways]) {
        //比对跳转的url除去sheme和所有网关列表除去sheme
        NSURL *gatewayUrl = [NSURL URLWithString:gateway];
        NSURL *absoluteStringUrl = [NSURL URLWithString:absoluteString];
        absoluteString = [absoluteString substringFromIndex:absoluteStringUrl.scheme.length];
        NSString *gatewayString = [gateway substringFromIndex:gatewayUrl.scheme.length];
        //如果跳转的url和所有网关列表中的一条相同
        if ([absoluteString isEqualToString:gatewayString]) {
            isEqual = YES;
            break;
        }
        //如果跳转的url包含网关，且host不是网关
        if ([absoluteString containsString:gatewayUrl.host] &&
            ![absoluteStringUrl.host isEqualToString:gatewayUrl.host])
        {
            isEqual = YES;
            break;
        }
    }
    if (isEqual) {
        [self.webView stopLoading];
        [self.wkWebView stopLoading];
        dispatch_main_async_safe((^{
            NSDictionary *tabBarDict = @{@"index" : @"0", @"url" : @""};
            [[NSNotificationCenter defaultCenter] postNotificationName:BackTabBarRootViewNotification object:tabBarDict];
        }));
        return NO;
    }
    return YES;
}

#pragma mark ------------------others----------------------------------------------

- (id)handBridgeProtocolWithModel:(BridgeModel *)model {
    NSString *separateStr = [NSString isBlankString:model.method] ? @"" : @"_";
    NSString *method = [NSString stringWithFormat:@"%@%@%@:",model.service,separateStr,model.method];
    SEL selector = NSSelectorFromString(method);
    if ([self.protocol respondsToSelector:selector]) {
        id (*action)(id, SEL, BridgeModel *) = (id (*)(id, SEL, BridgeModel *)) objc_msgSend;
        return action(self.protocol,selector,model);
    } else {
        //没有实现协议处理
        //运营环境打印提示
        printf("bridge方法%s没有实现\n",[method cStringUsingEncoding:NSUTF8StringEncoding]);
        //不是运营环境直接崩溃提示
#if DEBUG
        abort();
#endif
    }
    return @(YES);
}

//点击返回
- (void)goToBack {
    NSDictionary *dic = self.backUrlDic;
    NSString *urlIndex = self.webConfigModel.url;
    if ([self.webConfigModel.url containsString:@"?"]) {
        NSRange range = [self.webConfigModel.url rangeOfString:@"?"];
        urlIndex = [self.webConfigModel.url substringToIndex:range.location];
    }
    if (isDictWithCountMoreThan0(dic) && [dic objectForKey:urlIndex]) {
        WebConfigModel *configModel = [WebConfigModel new];
        configModel.url = [dic objectForKey:urlIndex];
        configModel.newView = NO;
        self.webConfigModel = configModel;
        [self loadWebView];
        
    } else {
        if (self.webConfigModel.gameType != nil && ![self isPreloading]) {
            weakSelf(weakSelf)
            NSArray *titles = @[@"继续游戏",@"确定退出"];
            IVActionHandler handler = ^(UIAlertAction *action){};
            IVActionHandler handler1 = ^(UIAlertAction *action){
                strongSelf(strongSelf)
                [strongSelf.navigationController popViewControllerAnimated:YES];
            };
            NSArray *handlers = @[handler,handler1];
            [IVUtility showAlertWithActionTitles:titles handlers:handlers title:@"提示" message:@"确定要退出游戏吗?"];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
