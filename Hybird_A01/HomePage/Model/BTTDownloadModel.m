//
//  BTTDownloadModel.m
//  Hybird_A01
//
//  Created by Domino on 17/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTDownloadModel.h"

@implementation BTTDownloadModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"icon":[BTTIconModel class]};
}

@end

@implementation BTTIconModel

- (NSString *)path {
    if (![_path hasPrefix:@"http"]) {
        return [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain], _path];
    }
    return _path;
}

@end
