//
//  WebConfigModel.m
//  MainHybird
//
//  Created by Key on 2018/6/7.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "WebConfigModel.h"

@implementation WebConfigModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)setGameType:(NSString *)gameType {
    _gameType = gameType;
    if ([gameType isEqualToString:@"AGQJ"]) {
        self.isAGQJ = YES;
    }
}
@end
