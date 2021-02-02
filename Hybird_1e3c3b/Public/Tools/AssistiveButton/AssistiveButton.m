//
//  AssistiveButton.m
//  Hybird_A01
//
//  Created by JerryHU on 2020/10/28.
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
        UIImage * closeImage = [UIImage imageNamed:@"ic_assistive_close_btn"];
        self.mainFrame = CGRectMake(position.x, position.y, backgroundImage.size.width, backgroundImage.size.height+closeImage.size.height);
        self.superViewRelativePosition = position;
        
        UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(backgroundImage.size.width-closeImage.size.width, 0, closeImage.size.width, closeImage.size.height)];
        [closeBtn setBackgroundImage:closeImage forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.tag = 1;
        closeBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:closeBtn];
        
        //main Button
        self.powerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, closeImage.size.height, backgroundImage.size.width, backgroundImage.size.height)];
        [self.powerButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        self.powerButton.tag = 0;
        self.powerButton.adjustsImageWhenHighlighted = NO;
        [self.powerButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_powerButton];
        
        //configuration
        [self configureDefaultValue];
        [self setFrame:_mainFrame];
        self.center = position;
        [self configureGesture];
        [self configureCover];
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
    //    self.animationDuring = ANIMATION_DURING_DEFAULT;
    self.coverAlpha = COVER_ALPHA_DEFAULT;
    self.coverColor = COVER_COLOR_DEFAULT;
    self.radius = SPREAD_RADIUS_DEFAULT;
    self.touchBorderMargin = TOUCHBORDER_MARGIN_DEFAULT;
    self.spreadAngle = FLOWER_SPREAD_ANGLE_DEFAULT;
    self.direction = SPREAD_DIRECTION_DEFAULT;
}

- (void)configureGesture {
    UIPanGestureRecognizer *panGestureRecongnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSpreadButton:)];
    [self addGestureRecognizer:panGestureRecongnizer];
}

- (void)configureCover {
    self.cover = [[UIView alloc] initWithFrame:self.bounds];
    self.cover.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.cover.userInteractionEnabled = YES;
    self.cover.backgroundColor = self.coverColor;
    self.cover.alpha = 0;
    //    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover)];
    //    [self.cover addGestureRecognizer:tapGestureRecognizer];
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
                    } else if (location.y > superViewSize.height - magneticDistance) {//下面
                        destinationLocation = CGPointMake(location.x, superViewSize.height - self.bounds.size.height/2 - _touchBorderMargin - kTabbarHeight);
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

- (void)powerButtonRotationAnimate {
    _powerButton.transform = CGAffineTransformMakeRotation(-0.75f * π);
}

- (void)powerButtonCloseAnimation {
    _powerButton.transform = CGAffineTransformMakeRotation(0.0f);
}

- (CGPoint)calculatePointWithAngle:(CGFloat)angle radius:(CGFloat)radius {
    //根据弧度和半径计算点的位置
    //center => powerButton
    CGFloat x = _powerButton.center.x + cos(angle / 180.0 * π) * radius;
    CGFloat y = _powerButton.center.y - sin(angle / 180.0 * π) * radius;
    return CGPointMake(x, y);
}

- (UIBezierPath *)movingPathWithStartPoint:(CGPoint)startPoint keyPointCount:(int)keyPointCount keyPoints:(CGPoint)keyPoints, ...NS_REQUIRES_NIL_TERMINATION {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:startPoint];
    [path addLineToPoint:keyPoints];
    
    va_list varList;
    va_start(varList, keyPoints);
    for (int i = 0; i < keyPointCount - 1; i++) {
        CGPoint point = va_arg(varList, CGPoint);
        [path addLineToPoint:point];
    }
    va_end(varList);
    return path;
}

- (UIBezierPath *)movingPathWithStartPoint:(CGPoint)startPoint
                                  endPoint:(CGPoint)endPoint
                                startAngle:(CGFloat)startAngle
                                  endAngle:(CGFloat)endAngle
                                    center:(CGPoint)center
                                     shock:(BOOL)shock {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    //arc
    if (shock) {
        [path addArcWithCenter:center radius:_radius startAngle:-startAngle/180*π endAngle:(-endAngle - 3)/180*π clockwise:NO];
        [path addArcWithCenter:center radius:_radius startAngle:(-endAngle - 3)/180*π endAngle:(-endAngle + 1)/180*π clockwise:YES];
        [path addArcWithCenter:center radius:_radius startAngle:(-endAngle + 1)/180*π endAngle:-endAngle/180*π clockwise:NO];
    } else  {
        [path addArcWithCenter:center radius:_radius startAngle:-startAngle/180*π endAngle:-endAngle/180*π clockwise:NO];
    }
    return path;
}

- (void)changeSpreadDirection {
    CGFloat superviewWidth = self.superview.bounds.size.width;
    CGFloat superviewHeight = self.superview.bounds.size.height;
    CGFloat centerAreaWidth = superviewWidth - 2*_radius;
    CGPoint location = self.center;
    
    //改变下次Spreading的位置
    self.superViewRelativePosition = location;
    
    if (location.x < (superviewWidth - centerAreaWidth)/2) {//左边区域
        if (0 <= location.y && location.y < _radius) {//上
            self.direction = SpreadDirectionRightDown;
        } else if (_radius <= location.y && location.y < (superviewHeight - _radius)) {//中
            self.direction = SpreadDirectionRight;
        } else {//下
            self.direction = SpreadDirectionRightUp;
        }
    } else if (location.x > superviewWidth/2 + centerAreaWidth/2) {//右边区域
        if (0 <= location.y && location.y < _radius) {
            self.direction = SpreadDirectionLeftDown;
        } else if (_radius <= location.y && location.y < (superviewHeight - _radius)) {
            self.direction = SpreadDirectionLeft;
        } else {
            self.direction = SpreadDirectionLeftUp;
        }
    } else {//中间区域
        if (location.y < superviewHeight/2) {
            self.direction = SpreadDirectionBottom;
        } else {
            self.direction = SpreadDirectionTop;
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    _cover.frame = newSuperview.bounds;
}

- (void)didMoveToSuperview {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CAAnimation *touchBorderAnim = [self.layer animationForKey:@"touchBorder"];
    if (touchBorderAnim == anim) {
        [self changeSpreadDirection];
    }
}

- (void)setDirection:(SpreadDirection)direction {
    _direction = direction;
    if (direction == SpreadDirectionTop || direction == SpreadDirectionBottom || direction == SpreadDirectionLeft || direction == SpreadDirectionRight) {
        _spreadAngle = FLOWER_SPREAD_ANGLE_DEFAULT;
    } else {
        _spreadAngle = SICKLE_SPREAD_ANGLE_DEFAULT;
    }
}

@end

