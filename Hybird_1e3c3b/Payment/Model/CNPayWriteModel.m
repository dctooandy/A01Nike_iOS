//
//  CNPayWriteModel.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/4.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayWriteModel.h"

@implementation CNPayWriteModel
- (NSString*)depositBy
{
    if (_depositBy.length == 1)
    {
        _depositBy = @"*";
    }
    else if (_depositBy.length <= 2)
    {
        _depositBy = [_depositBy stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
    }
    else
    {
        _depositBy = [_depositBy stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"**"];
    }
    return _depositBy;
}
@end
