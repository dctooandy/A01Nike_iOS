//
//  HAWebView.m
//  MainHybird
//
//  Created by Key on 2018/6/7.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "HAWebView.h"


@interface HAWebView()
@end
@implementation HAWebView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setOpaque:NO];//使网页透明
        self.scalesPageToFit = YES;
        self.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
        self.scrollView.bounces = NO;
    }
    return self;
}
@end
