//
//  BTTPromotionDetailController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 17/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPromotionDetailController.h"

@interface BTTPromotionDetailController ()

@end

@implementation BTTPromotionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.allowsInlineMediaPlayback = true;
    self.webView.mediaPlaybackRequiresUserAction = false;
    [self loadWebView];
}

@end
