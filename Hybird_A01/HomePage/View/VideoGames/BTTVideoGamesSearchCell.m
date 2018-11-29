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
    [_searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    [_searchBar setTintColor:[UIColor colorWithHexString:@"818791"]];
    
    UITextField*searchField = [self.searchBar valueForKey:@"_searchField"]; // 先取出textfield
    [searchField setBackgroundColor:[UIColor colorWithHexString:@"292d36"]];
}

@end
