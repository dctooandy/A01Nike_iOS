//
//  CNUIWebVC.m
//  HybirdApp
//
//  Created by cean.q on 2018/11/12.
//  Copyright © 2018 harden-imac. All rights reserved.
//

#import "CNUIWebVC.h"
#import "CNPayRequestManager.h"

@interface CNUIWebVC ()
@property (nonatomic, strong) CNPayOrderModel *order;
@end

@implementation CNUIWebVC

- (instancetype)initWithOrder:(CNPayOrderModel *)order title:(NSString *)title {
    if (self = [super init]) {
        self.order = order;
        WebConfigModel *webConfig = [[WebConfigModel alloc] init];
        webConfig.url = [CNPayRequestManager submitPayFormWithOrderModel:order];
        webConfig.newView = YES;
        self.webConfigModel = webConfig;
        self.title = title;
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title {
    if (self = [super init]) {
        WebConfigModel *webConfig = [[WebConfigModel alloc] init];
        webConfig.url = url;
        webConfig.newView = YES;
        self.webConfigModel = webConfig;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadWebView {
    if ([self.webConfigModel.url hasPrefix:@"<form"]) {
        [self.webView loadHTMLString:self.webConfigModel.url baseURL:nil];
        return;
    }
    [super loadWebView];
}

- (void)goToBack {
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
