//
//  BTTPosterModel.m
//  Hybird_A01
//
//  Created by Domino on 16/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPosterModel.h"

@implementation BTTPosterModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"logo":[BTTPosterLogoModel class]};
}

- (NSString *)link {
    if (![_link hasPrefix:@"http"]) {
        return [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain], _link];
    }
    return _link;
}

@end

@implementation BTTPosterLogoModel

- (NSString *)path {
    if (![_path hasPrefix:@"http"]) {
        return [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain], _path];
    }
    return _path;
}

@end
