//
//  NSDictionary+Log.m
//  Hybird_1e3c3b
//
//  Created by Levy on 12/20/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)


#ifdef DEBUG

- (NSString *)description {
    return [self btt_descriptionWithLevel:1];
}

- (NSString *)descriptionWithLocale:(nullable id)locale {
    return [self btt_descriptionWithLevel:1];
}
- (NSString *)descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [self btt_descriptionWithLevel:(int)level];
}

/**
 * 非字典时，会引发崩溃
 */
- (NSString *)btt_getUTF8String {
    if ([self isKindOfClass:[NSDictionary class]] == NO) {
        return @"";
    }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return @"";
    }
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}


/**
 将字典转化成字符串，文字格式UTF8,并且格式化
 
 @param level 当前字典的层级，最少为 1，代表最外层字典
 @return 格式化的字符串
 */
- (NSString *)btt_descriptionWithLevel:(int)level {
    NSString *subSpace = [self btt_getSpaceWithLevel:level];
    NSString *space = [self btt_getSpaceWithLevel:level - 1];
    NSMutableString *retString = [[NSMutableString alloc] init];
    // 1、添加 {
    [retString appendString:[NSString stringWithFormat:@"{"]];
    // 2、添加 key : value;
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *value = (NSString *)obj;
            value = [value stringByRemovingPercentEncoding];
            NSString *subString = [NSString stringWithFormat:@"\n%@\"%@\" : \"%@\",", subSpace, key, value];
            [retString appendString:subString];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)obj;
            NSString *str = [dic btt_descriptionWithLevel:level + 1];
            str = [NSString stringWithFormat:@"\n%@\"%@\" : %@,", subSpace, key, str];
            [retString appendString:str];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)obj;
            NSString *str = [arr descriptionWithLocale:nil indent:level + 1];
            str = [NSString stringWithFormat:@"\n%@\"%@\" : %@,", subSpace, key, str];
            [retString appendString:str];
        } else {
            NSString *subString = [NSString stringWithFormat:@"\n%@\"%@\" : %@,", subSpace, key, obj];
            [retString appendString:subString];
        }
    }];
    if ([retString hasSuffix:@","]) {
        [retString deleteCharactersInRange:NSMakeRange(retString.length-1, 1)];
    }
    // 3、添加 }
    [retString appendString:[NSString stringWithFormat:@"\n%@}", space]];
    return retString;
}


/**
 根据层级，返回前面的空格占位符
 
 @param level 字典的层级
 @return 占位空格
 */
- (NSString *)btt_getSpaceWithLevel:(int)level {
    NSMutableString *mustr = [[NSMutableString alloc] init];
    for (int i=0; i<level; i++) {
        [mustr appendString:@"\t"];
    }
    return mustr;
}

#endif


@end
