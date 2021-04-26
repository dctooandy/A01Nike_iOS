//
//  LiveChat.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 14/4/2021.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CSCustomSerVice/CSCustomSerVice.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CSServiceCompleteBlock)(CSServiceCode errCode);

@interface LiveChat : NSObject
+(void)startKeFu:(UIViewController *)vc csServicecompleteBlock:(CSServiceCompleteBlock)csServicecompleteBlock;
@end

NS_ASSUME_NONNULL_END
