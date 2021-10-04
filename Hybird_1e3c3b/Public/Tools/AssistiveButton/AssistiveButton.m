//
//  AssistiveButton.m
//  Hybird_A01
//
//  Created by Jairo on 10/28/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "AssistiveButton.h"

@interface AssistiveButton () <CAAnimationDelegate>
@property (strong, nonatomic) UIDynamicAnimator *animator;
@end

@implementation AssistiveButton

-(instancetype)initMainBtnWithBackgroundImage:(UIImage *)backgroundImage highlightImage:(UIImage *)highlightImage position:(CGPoint)position {
    self = [super init];
    if (self) {
        UIImage * closeImage = [UIImage imageNamed:@"ic_918_assistive_close_btn"];
//        self.mainFrame = CGRectMake(position.x, position.y, backgroundImage.size.width, backgroundImage.size.height);
        self.mainFrame = CGRectMake(position.x, position.y, 132, 132);
        self.superViewRelativePosition = position;
        
        //main Button
//        self.powerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
        self.powerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 132, 132)];
        [self.powerButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        self.powerButton.tag = 0;
        self.powerButton.adjustsImageWhenHighlighted = NO;
        [self.powerButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_powerButton];
        
//        UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(backgroundImage.size.width-closeImage.size.width, 0, closeImage.size.width, closeImage.size.height)];
        UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(132-closeImage.size.width, 0, closeImage.size.width, closeImage.size.height)];
        [closeBtn setBackgroundImage:closeImage forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.tag = 1;
        closeBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:closeBtn];
        
        //configuration
        [self configureDefaultValue];
        [self setFrame:_mainFrame];
        self.center = position;
//        [self configureGesture];
    }
    return self;
}

-(void)btnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            if (self.mainButtonClickActionBlock) {
                self.mainButtonClickActionBlock();
            }
        }
            break;
        case 1:
        {
            if (self.closeBtnActionBlock) {
                self.closeBtnActionBlock();
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)configureDefaultValue {
    self.radius = SPREAD_RADIUS_DEFAULT;
    self.touchBorderMargin = TOUCHBORDER_MARGIN_DEFAULT;
}

- (void)configureGesture {
    UIPanGestureRecognizer *panGestureRecongnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSpreadButton:)];
    [self addGestureRecognizer:panGestureRecongnizer];
}

- (void)panSpreadButton:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [_animator removeAllBehaviors];
            break;
        case UIGestureRecognizerStateEnded:
            switch (_positionMode) {
                case SpreadPositionModeFixed:
                {
                    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:self snapToPoint:_superViewRelativePosition];
                    snapBehavior.damping = 0.5;
                    [_animator addBehavior:snapBehavior];
                    break;
                }
                case SpreadPositionModeTouchBorder:
                {
                    CGPoint location = [gesture locationInView:self.superview];
                    if (![self.superview.layer containsPoint:location]) {
                        //outside superView
                        location = self.center;
                    }
                    CGSize superViewSize = self.superview.bounds.size;
                    CGFloat magneticDistance = superViewSize.height * MAGNETIC_SCOPE_RATIO_VERTICAL;
                    CGPoint destinationLocation;
                    if (location.y < magneticDistance) {//上面区域
                        destinationLocation = CGPointMake(location.x, self.bounds.size.width/2 + _touchBorderMargin);
                        if (location.x < self.bounds.size.width/2 + _touchBorderMargin) {
                            destinationLocation.x = self.bounds.size.width/2 + _touchBorderMargin;
                        } else if (location.x > superViewSize.width - (self.bounds.size.width/2 + _touchBorderMargin)) {
                            destinationLocation.x = superViewSize.width - (self.bounds.size.width/2 + _touchBorderMargin);
                        }
                    } else if (location.y > superViewSize.height - magneticDistance) {//下面
                        destinationLocation = CGPointMake(location.x, superViewSize.height - self.bounds.size.height/2 - _touchBorderMargin - kTabbarHeight);
                        if (location.x < self.bounds.size.width/2 + _touchBorderMargin) {
                            destinationLocation.x = self.bounds.size.width/2 + _touchBorderMargin;
                        } else if (location.x > superViewSize.width - (self.bounds.size.width/2 + _touchBorderMargin)) {
                            destinationLocation.x = superViewSize.width - (self.bounds.size.width/2 + _touchBorderMargin);
                        }
                    } else if (location.x > superViewSize.width/2) {//右边
                        destinationLocation = CGPointMake(superViewSize.width - (self.bounds.size.width/2 + _touchBorderMargin), location.y);
                    } else {//左边
                        destinationLocation = CGPointMake(self.bounds.size.width/2 + _touchBorderMargin, location.y);
                    }
                    
                    CABasicAnimation *touchBorderAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
                    touchBorderAnimation.delegate = self;
                    touchBorderAnimation.removedOnCompletion = NO;//动画完成后不去除Animation
                    touchBorderAnimation.fromValue = [NSValue valueWithCGPoint:location];
                    touchBorderAnimation.toValue = [NSValue valueWithCGPoint:destinationLocation];
                    touchBorderAnimation.duration = ANIMATION_DURING_TOUCHBORDER_DEFAULT;
                    touchBorderAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    [self.layer addAnimation:touchBorderAnimation forKey:@"touchBorder"];
                    
                    [CATransaction begin];
                    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                    self.layer.position = destinationLocation;
                    [CATransaction commit];
                    break;
                }
            }
            break;
        default:
        {
            CGPoint location = [gesture locationInView:self.superview];
            if ([self.superview.layer containsPoint:location]) {
                self.center = location;
            }
            break;
        }
    }
}
- (void)setPositionMode:(SpreadPositionMode)positionMode
{
    _positionMode = positionMode;
    if (positionMode != SpreadPositionModeNone)
    {
        [self configureGesture];
    }
}
- (void)didMoveToSuperview {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
}

@end

