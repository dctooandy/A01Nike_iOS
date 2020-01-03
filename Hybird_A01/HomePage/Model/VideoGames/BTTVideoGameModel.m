//
//  BTTVideoGameModel.m
//  Hybird_A01
//
//  Created by Domino on 28/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGameModel.h"
#import <IVCacheLibrary/IVCacheWrapper.h>
#import "HAInitConfig.h"

@implementation BTTVideoGameModel

- (NSString *)gameImage {
    NSString *gameImage = @"";
    if ([_gameImage hasPrefix:@"http"]) {
        return _gameImage;
    }
    NSString *h5Domain = [IVCacheWrapper objectForKey:IVCacheH5DomainKey] ? : [HAInitConfig defaultH5Domain];
    gameImage = [NSString stringWithFormat:@"%@%@%@",h5Domain,@"static/A01M/_default/__static/_wms/_l/electronicgames/",_gameImage];
    return gameImage;
}

@end
