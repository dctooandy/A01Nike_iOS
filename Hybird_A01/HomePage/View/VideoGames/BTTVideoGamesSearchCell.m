//
//  BTTVideoGamesSearchCell.m
//  Hybird_A01
//
//  Created by Domino on 28/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGamesSearchCell.h"

@implementation BTTVideoGamesSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    [[[_searchBar.subviews.firstObject subviews] firstObject] removeFromSuperview];
    [_searchBar setBackgroundColor:COLOR_RGBA(50, 55, 66, 1)];
    _searchBar.barTintColor = COLOR_RGBA(50, 55, 66, 1);
    [_searchBar setTintColor:[UIColor colorWithHexString:@"818791"]];
    if (@available(iOS 13.0, *)) {
        UITextField *searchField = (UITextField*)[self findViewWithClassName:NSStringFromClass([UITextField class]) inView:_searchBar];
        [searchField setBackgroundColor:[UIColor colorWithHexString:@"292d36"]];
        searchField.textColor = [UIColor whiteColor];
        
        [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
    }else{
        [_searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
        UITextField*searchField = [self.searchBar valueForKey:@"_searchField"]; // 先取出textfield
        [searchField setBackgroundColor:[UIColor colorWithHexString:@"292d36"]];
        searchField.textColor = [UIColor whiteColor];
    }
    
}


- (UIView *)findViewWithClassName:(NSString *)className inView:(UIView *)view{
    Class specificView = NSClassFromString(className);
    if ([view isKindOfClass:specificView]) {
        return view;
    }

    if (view.subviews.count > 0) {
        for (UIView *subView in view.subviews) {
            UIView *targetView = [self findViewWithClassName:className inView:subView];
            if (targetView != nil) {
                return targetView;
            }
        }
    }
    return nil;
}


@end
