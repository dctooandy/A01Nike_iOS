//
//  PuzzleVerifyPopoverView.h
//  Hybird_1e3c3b
//
//  Created by Kevin on 2022/4/18.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSInteger const kBTTLoginOrRegisterCaptchaPuzzle;

@class PuzzleVerifyView;
@protocol PuzzleVerifyPopoverViewDelegate <NSObject>

- (void)puzzleViewDidChangePosition:(CGPoint)position;
- (void)puzzleViewCanceled;
- (void)puzzleViewRefresh;

@end

@interface PuzzleVerifyPopoverView : UIView
@property(nonatomic, strong) UIImage *cutoutImage;
@property(nonatomic, strong) UIImage *originImage;
@property(nonatomic, strong) UIImage *shadeImage;
@property(nonatomic, assign) CGPoint position;
@property(nonatomic, weak)id<PuzzleVerifyPopoverViewDelegate> delegate;
- (void)show;
- (void)reset;
- (void)successAndDismiss;

@end

NS_ASSUME_NONNULL_END
