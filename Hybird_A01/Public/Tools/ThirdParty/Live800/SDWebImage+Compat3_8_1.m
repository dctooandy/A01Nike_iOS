//
//  SDWebImage+Compat3_8_1.m
//  testProject
//
//  Created by 朱鹏 on 2018/11/2.
//  Copyright © 2018 peng zhu. All rights reserved.
//

#import "SDWebImage+Compat3_8_1.h"
#import "UIImage+GIF.h"

@implementation SDWebImage_Compat3_8_1



@end

@implementation UIImage (LIVCompat3_8_1)

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (scale > 1.0f) {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        
        if (data) {
            return [UIImage sd_animatedGIFWithData:data];
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            return [UIImage sd_animatedGIFWithData:data];
        }
        
        return [UIImage imageNamed:name];
    }
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            return [UIImage sd_animatedGIFWithData:data];
        }
        
        return [UIImage imageNamed:name];
    }
}

@end

@implementation SDImageCache (LIVCompat3_8_1)

- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    [self storeImage:image forKey:key toDisk:toDisk completion:^{
        
    }];
}

@end
