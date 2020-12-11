//
//  BTTGameModel.m
//  Hybird_1e3c3b
//
//  Created by Domino on 17/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTGameModel.h"

@implementation BTTGameModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"icon":[BTTGameIconModel class]};
}

@end

@implementation BTTGameIconModel

- (NSString *)path {
    if (![_path hasPrefix:@"http"]) {
        return [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain],_path];
    }
    return _path;
}

@end
