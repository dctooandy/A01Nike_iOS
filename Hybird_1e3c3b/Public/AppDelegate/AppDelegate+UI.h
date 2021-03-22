//
//  AppDelegate+UI.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 16/3/2021.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "AppDelegate.h"
#import <TXScrollLabelView/TXScrollLabelView.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (UI)<TXScrollLabelViewDelegate>
@property (nonatomic, strong) TXScrollLabelView * __nullable scrollLabelView;
-(void)setUp918ScrollTextView:(NSString *)str;
- (void)appearCountDown:(NSInteger)num;
@end

NS_ASSUME_NONNULL_END
