//
//  AppDelegate+UI.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 16/3/2021.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "AppDelegate+UI.h"

static const char *BTTScrollLabelView = "BTTScrollLabelView";

@implementation AppDelegate (UI)

-(void)setUp918ScrollTextView:(NSString *)str {
    UIImage * cancelImage = [UIImage imageNamed:@"pay_wechatX"];
    UIImage * labaImage = [UIImage imageNamed:@"homepage_speaker"];
    
    NSInteger height = KIsiPhoneX ? 88:64;
    NSInteger space = 5;
    NSInteger labaLeftSpace = 10;
    CGSize btnSize = cancelImage.size;
    CGSize labSize = CGSizeMake(25, 25);
    CGSize scrollLabelViewSize = CGSizeMake(SCREEN_WIDTH - btnSize.width - 2 * space - labSize.width - 2 * labaLeftSpace, 50);
    
    self.winningTextView = [[UIView alloc] init];
    self.winningTextView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    self.winningTextView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.window addSubview:self.winningTextView];
    
    UIImageView * labaImgView = [[UIImageView alloc] init];
    labaImgView.image = labaImage;
    labaImgView.frame = CGRectMake(labaLeftSpace, (height - scrollLabelViewSize.height + height - labSize.height) / 2, labSize.width, labSize.height);
    [self.winningTextView addSubview:labaImgView];
    
    UIButton * cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(SCREEN_WIDTH - btnSize.width - space, (height - scrollLabelViewSize.height + height - btnSize.height) / 2, btnSize.width, btnSize.height);
    [cancelBtn setImage:cancelImage forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.winningTextView addSubview:cancelBtn];
    
    
    if (!self.scrollLabelView) {
        self.scrollLabelView = [TXScrollLabelView scrollWithTitle:str type:TXScrollLabelViewNoRepeatTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut];
        self.scrollLabelView.frame = CGRectMake(labSize.width + 2 * labaLeftSpace, height - scrollLabelViewSize.height, scrollLabelViewSize.width, scrollLabelViewSize.height);
        self.scrollLabelView.scrollLabelViewDelegate = self;
        self.scrollLabelView.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 15);
        self.scrollLabelView.font = [UIFont systemFontOfSize:14];
        self.scrollLabelView.scrollTitleColor = [UIColor whiteColor];
        self.scrollLabelView.textAlignment = NSTextAlignmentCenter;
        self.scrollLabelView.backgroundColor = [UIColor clearColor];
        weakSelf(weakSelf);
        [self.scrollLabelView setEndScrollBlock:^{
            [weakSelf cancelBtnAction];
        }];
        [self.winningTextView addSubview:self.scrollLabelView];
        [self.scrollLabelView beginScrolling];
    }
}

-(void)cancelBtnAction {
    [self.scrollLabelView endScrolling];
    self.scrollLabelView = nil;
    [self.winningTextView removeFromSuperview];
    [self appearCountDown:reload918Sec];
}

- (void)appearCountDown:(NSInteger)num {
    __block int timeout = (int)num; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self load918FirstWinningList];
            });
        } else {
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];;
            if (seconds < 10) {
                strTime = [NSString stringWithFormat:@"%.1d", seconds];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(void)setScrollLabelView:(TXScrollLabelView *)scrollLabelView {
    objc_setAssociatedObject(self, &BTTScrollLabelView, scrollLabelView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(TXScrollLabelView *)scrollLabelView {
    return objc_getAssociatedObject(self, &BTTScrollLabelView);
}

@end
