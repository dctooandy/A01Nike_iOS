//
//  BTTVideoGameModel.m
//  Hybird_1e3c3b
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
    gameImage = [NSString stringWithFormat:@"%@%@",h5Domain,_gameImage];
    return gameImage;
}

@end
