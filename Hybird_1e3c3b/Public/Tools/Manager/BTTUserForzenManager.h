//
//  BTTUserForzenManager.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/1.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^UserForzenCallBack)(NSString * _Nullable response, NSString * _Nullable error);
@interface BTTUserForzenManager : NSObject
SingletonInterface(BTTUserForzenManager);

- (void)checkUserForzen;
-(void)unBindUserForzenAccount:(NSString *)wPassword
                     withMessageID:(NSString *)messageID
                     withSCode:(NSString *)sCode
               completionBlock:(UserForzenCallBack)completionBlock;
@end

NS_ASSUME_NONNULL_END
