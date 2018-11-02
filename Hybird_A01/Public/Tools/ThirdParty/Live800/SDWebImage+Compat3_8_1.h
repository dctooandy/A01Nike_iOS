//
//  SDWebImage+Compat3_8_1.h
//  testProject
//
//  Created by 朱鹏 on 2018/11/2.
//  Copyright © 2018 peng zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDImageCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDWebImage_Compat3_8_1 : NSObject

@end

@interface UIImage (LIVCompat3_8_1)

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name;

@end

@interface SDImageCache (LIVCompat3_8_1)

- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;

@end


NS_ASSUME_NONNULL_END

