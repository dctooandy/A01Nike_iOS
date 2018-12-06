//
//  BTTVideoGameModel.m
//  Hybird_A01
//
//  Created by Domino on 28/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGameModel.h"

@implementation BTTVideoGameModel

- (NSString *)gameImage {
    NSString *gameImage = @"";
    if ([_gameImage hasPrefix:@"http"]) {
        return _gameImage;
    } 
    gameImage = [NSString stringWithFormat:@"%@%@%@",[IVNetwork h5Domain],@"static/A01M/_default/__static/_wms/_l/electronicgames/",_gameImage];
    return gameImage;
}

@end
