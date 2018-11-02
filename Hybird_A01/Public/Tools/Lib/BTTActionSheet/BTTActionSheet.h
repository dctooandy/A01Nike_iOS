//
//  BTTActionSheet.h
//  BTTActionSheetDemo
//
//  Created by Domino on 18/10/1.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTTActionSheetDelegate;

typedef void(^BTTActionSheetBlock)(NSInteger buttonIndex);

@interface BTTActionSheet : UIView

/**
 *  type delegate
 *
 *  @param title                  title            (可以为空)
 *  @param delegate               delegate
 *  @param cancelButtonTitle      "取消"按钮         (默认有)
 *  @param destructiveButtonTitle "警示性"(红字)按钮  (可以为空)
 *  @param otherButtonTitles      otherButtonTitles
 */
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<BTTActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  type block
 *
 *  @param title                  title            (可以为空)
 *  @param cancelButtonTitle      "取消"按钮         (默认有)
 *  @param destructiveButtonTitle "警示性"(红字)按钮  (可以为空)
 *  @param otherButtonTitles      otherButtonTitles
 */
- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
             actionSheetBlock:(BTTActionSheetBlock) actionSheetBlock;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id<BTTActionSheetDelegate> delegate;

- (void)show;

@end


#pragma mark - BTTActionSheet delegate

@protocol BTTActionSheetDelegate <NSObject>

@optional

- (void)actionSheet:(BTTActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end
