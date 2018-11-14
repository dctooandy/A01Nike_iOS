//
//  BTTProgressHUDInfo.m
//  Hybird_A01
//
//  Created by Domino on 2018/7/27.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import "BTTProgressHUDInfo.h"
#import "BTTProgressHUDConfig.h"


@implementation BTTProgressHUDInfo


- (instancetype)init {
    self = [super init];
    if (self) {
//        [self layoutOnlyHUD];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        [self layoutOnlyHUDWithFrame:frame];
    }
    return self;
}

- (void)layoutOnlyHUDWithFrame:(CGRect)frame {
    self.infoModeType = BTTProgressHUDInfoHUD;
    [self layoutHUDOrCustomWithText:NULL withFrame:frame];
}

- (void)layoutOnlyCustomWithFrame:(CGRect)frame {
    self.infoModeType = BTTProgressHUDInfoCustom;
    [self layoutHUDOrCustomWithText:NULL withFrame:frame];
}


- (void)layoutHUDWithText:(NSString *)text withFrame:(CGRect)frame {
    self.infoModeType = BTTProgressHUDInfoHUD;
    [self layoutHUDOrCustomWithText:text withFrame:frame];
}

- (void)layoutCustomWithText:(NSString *)text withFrame:(CGRect)frame {
    self.infoModeType = BTTProgressHUDInfoCustom;
    [self layoutHUDOrCustomWithText:text withFrame:frame];
}

- (void)layoutHUDOrCustomWithText:(NSString *)text withFrame:(CGRect)frame {
    
    CGSize textSize = [self measureTextSize:text WithFont:kFontSystem(16) constrainedToSize:CGSizeMake(BTTContentMaxWidth, MAXFLOAT)];
    CGFloat contentW = 0.0;
    CGFloat contentH = 0.0;
    if (!text||text.length == 0) {
        contentW = BTTHUDWH + BTTVerticalSpace * 2;
        contentH = contentW;
    } else {
        contentW = textSize.width > BTTContentNormalWidth ? textSize.width : BTTContentNormalWidth;
        contentH = textSize.height + BTTHUDWH + BTTVerticalSpace * 3;
    }
    CGFloat contentX = (SCREEN_WIDTH - contentW) / 2;
    CGFloat contentY = 0.0f;
    if (frame.size.height != SCREEN_HEIGHT) {
        contentY = (frame.size.height - contentH - (KIsiPhoneX ? 88 : 64)) / 2;
    } else {
        contentY = (frame.size.height - contentH) / 2;
    }
    
    
    self.contentViewFrame = CGRectMake(contentX, contentY, contentW, contentH);
    
    CGFloat HUDOrCustomY = BTTVerticalSpace;
    CGFloat HUDOrCustomX = (contentW - BTTHUDWH) / 2;
    CGFloat HUDOrCustomW = BTTHUDWH;
    CGFloat HUDOrCustomH = HUDOrCustomW;
    if (self.infoModeType == BTTProgressHUDInfoCustom) {
        self.imageViewFrame = CGRectMake(HUDOrCustomX, HUDOrCustomY, HUDOrCustomW, HUDOrCustomH);
        self.HUDFrame = CGRectZero;
    } else {
        self.HUDFrame = CGRectMake(HUDOrCustomX, HUDOrCustomY, HUDOrCustomW, HUDOrCustomH);
        self.imageViewFrame = CGRectZero;
    }
    CGFloat textY = BTTHUDWH + BTTVerticalSpace * 2;
    CGFloat textX = 0;
    CGFloat textW = contentW;
    CGFloat textH = textSize.height;
    self.textLabelFrame = CGRectMake(textX, textY, textW, textH);
    
    self.iconFrame = CGRectMake((self.contentViewFrame.size.width - 20) / 2, 30, 20, 20);
}

- (void)layoutOnlyTextWithText:(NSString *)text withFrame:(CGRect)frame {
    
    CGSize textSize = [self measureTextSize:text WithFont:kFontSystem(16) constrainedToSize:CGSizeMake(BTTContentMaxWidth, MAXFLOAT)];
    
    CGFloat contentW = textSize.width < BTTContentNormalWidth ? textSize.width + BTTHorizontalSpace * 2  : BTTContentNormalWidth;
    CGFloat contentH = textSize.height + BTTVerticalSpace * 2;
    CGFloat contentX = (SCREEN_WIDTH - contentW) / 2;
    CGFloat contentY = (frame.size.height - contentH) / 2;
    self.contentViewFrame = CGRectMake(contentX, contentY, contentW, contentH);
    
    self.HUDFrame = CGRectZero;
    
    CGFloat textY = BTTVerticalSpace;
    CGFloat textX = 0;
    CGFloat textW = contentW;
    CGFloat textH = textSize.height;
    self.textLabelFrame = CGRectMake(textX, textY, textW, textH);
    self.imageViewFrame = CGRectZero;
}

- (void)layoutCustomWithText:(NSString *)text Width:(CGFloat)width height:(CGFloat)height withFrame:(CGRect)frame {
    CGSize textSize = [self measureTextSize:text WithFont:kFontSystem(16) constrainedToSize:CGSizeMake(BTTContentMaxWidth, MAXFLOAT)];
    CGFloat contentW = 0.0;
    CGFloat contentH = 0.0;
    if (!text) {
        contentW = width + BTTVerticalSpace * 2;
        contentH = height + BTTVerticalSpace * 2;
    } else {
        contentW = textSize.width >  width + BTTVerticalSpace * 2 ? textSize.width : width + BTTVerticalSpace * 2;
        contentH = textSize.height + height + BTTVerticalSpace * 3;
    }
    CGFloat contentX = (SCREEN_WIDTH - contentW) / 2;
    CGFloat contentY = (frame.size.height - contentH) / 2;
    self.contentViewFrame = CGRectMake(contentX, contentY, contentW, contentH);
    
    CGFloat customY = BTTVerticalSpace;
    CGFloat customX = (contentW - width ) / 2;
    CGFloat customW = width;
    CGFloat customH = height;
    self.imageViewFrame = CGRectMake(customX, customY, customW, customH);
    self.HUDFrame = CGRectZero;
    
    CGFloat textY = CGRectGetMaxY(self.imageViewFrame) + BTTVerticalSpace;
    CGFloat textX = 0;
    CGFloat textW = contentW;
    CGFloat textH = textSize.height;
    self.textLabelFrame = CGRectMake(textX, textY, textW, textH);
}

- (void)drawLoadingCircle:(CAShapeLayer *)HUDLayer {
    
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:CGPointMake(HUDLayer.frame.size.width / 2, HUDLayer.frame.size.height / 2) radius:HUDLayer.frame.size.width / 2.5 - BTTStrokeWidth startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    CAShapeLayer *alphLineLayer = [CAShapeLayer layer];
    alphLineLayer.path = circlePath.CGPath;
    alphLineLayer.lineWidth = BTTStrokeWidth;
    alphLineLayer.strokeColor = [[UIColor colorWithCGColor:HUDLayer.strokeColor]colorWithAlphaComponent:0.1].CGColor;
    alphLineLayer.fillColor = [UIColor clearColor].CGColor;
    [HUDLayer addSublayer:alphLineLayer];
    
    CAShapeLayer *rotateLayer = [CAShapeLayer layer];
    rotateLayer.path = circlePath.CGPath;
    rotateLayer.lineWidth = BTTStrokeWidth;
    rotateLayer.strokeColor = [UIColor redColor].CGColor;
    rotateLayer.fillColor = [UIColor clearColor].CGColor;
    [HUDLayer addSublayer:rotateLayer];
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @0;
    strokeEndAnimation.toValue = @1;
    strokeEndAnimation.duration = 2;
    strokeEndAnimation.repeatCount = MAXFLOAT;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.03 :0.18 :0.5 :1.00];
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @0;
    strokeStartAnimation.toValue = @1;
    strokeStartAnimation.duration = 2;
    strokeStartAnimation.repeatCount = MAXFLOAT;
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.62 : 0.1 :1.0 : 0.8];
    
    CABasicAnimation *layerRotateAnimation = [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    layerRotateAnimation.fromValue = @0;
    layerRotateAnimation.toValue = @1;
    layerRotateAnimation.repeatCount = MAXFLOAT;
    layerRotateAnimation.duration = 6;
    
    [rotateLayer addAnimation:strokeEndAnimation forKey: @"strokeEnd"];
    [rotateLayer addAnimation: strokeStartAnimation forKey: @"strokeStart"];
    [HUDLayer addAnimation:layerRotateAnimation forKey: @"transfrom.rotation.z"];
    
}

- (void)drawStatusSuccess:(CAShapeLayer *)HUDLayer {
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:CGPointMake(HUDLayer.frame.size.width / 2, HUDLayer.frame.size.height / 2) radius:HUDLayer.frame.size.width / 2 - BTTStrokeWidth startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    CAShapeLayer *alphLineLayer = [CAShapeLayer layer];
    alphLineLayer.path = circlePath.CGPath;
    alphLineLayer.lineWidth = BTTStrokeWidth;
    alphLineLayer.strokeColor = [UIColor colorWithCGColor:HUDLayer.strokeColor].CGColor;
    alphLineLayer.fillColor = [UIColor clearColor].CGColor;
    [HUDLayer addSublayer:alphLineLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(HUDLayer.frame.size.width * 0.25, HUDLayer.frame.size.width * 0.48)];
    [path addLineToPoint:CGPointMake(HUDLayer.frame.size.width * 0.42, HUDLayer.frame.size.width * 0.68)];
    [path addLineToPoint: CGPointMake(HUDLayer.frame.size.width * 0.75, HUDLayer.frame.size.width * 0.35)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = BTTStrokeWidth;
    layer.strokeColor = [UIColor colorWithCGColor:HUDLayer.strokeColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [HUDLayer addSublayer:layer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.3;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [layer addAnimation:animation forKey:@"strokeEnd"];
    
}

- (void)drawStatusFail:(CAShapeLayer *)HUDLayer {
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:CGPointMake(HUDLayer.frame.size.width / 2, HUDLayer.frame.size.height / 2) radius:HUDLayer.frame.size.width / 2 - BTTStrokeWidth startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    CAShapeLayer *alphLineLayer = [CAShapeLayer layer];
    alphLineLayer.path = circlePath.CGPath;
    alphLineLayer.lineWidth = BTTStrokeWidth;
    alphLineLayer.strokeColor = [UIColor colorWithCGColor:HUDLayer.strokeColor].CGColor;
    alphLineLayer.fillColor = [UIColor clearColor].CGColor;
    [HUDLayer addSublayer:alphLineLayer];
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    
    [path1 moveToPoint:CGPointMake(HUDLayer.frame.size.width * 0.25, HUDLayer.frame.size.width * 0.25)];
    [path1 addLineToPoint:CGPointMake(HUDLayer.frame.size.width * 0.75, HUDLayer.frame.size.width * 0.75)];
    
    CAShapeLayer *Layer1 = [CAShapeLayer layer];
    Layer1.path = path1.CGPath;
    Layer1.lineWidth = BTTStrokeWidth;
    Layer1.strokeColor = [UIColor colorWithCGColor:HUDLayer.strokeColor].CGColor;
    Layer1.fillColor = [UIColor clearColor].CGColor;
    [HUDLayer addSublayer:Layer1];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    
    [path2 moveToPoint:CGPointMake(HUDLayer.frame.size.width * 0.75, HUDLayer.frame.size.width * 0.25)];
    [path2 addLineToPoint:CGPointMake(HUDLayer.frame.size.width * 0.25, HUDLayer.frame.size.width * 0.75)];
    
    
    CAShapeLayer *Layer2 = [CAShapeLayer layer];
    Layer2.path = path2.CGPath;
    Layer2.lineWidth = BTTStrokeWidth;
    Layer2.strokeColor = [UIColor colorWithCGColor:HUDLayer.strokeColor].CGColor;
    Layer2.fillColor = [UIColor clearColor].CGColor;
    [HUDLayer addSublayer:Layer2];
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.duration = 0.3;
    animation1.fromValue = @0;
    animation1.toValue = @1;
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [Layer1 addAnimation:animation1 forKey:@"strokeEnd"];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation2.duration = 0.3;
    animation2.fromValue = @0;
    animation2.toValue = @1;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [Layer2 addAnimation:animation2 forKey:@"strokeEnd"];
}

- (void)drawProgressCircle:(CAShapeLayer *)HUDLayer progress:(CGFloat)progress {
    UIBezierPath *circleOutPath = [UIBezierPath bezierPath];
    [circleOutPath addArcWithCenter:CGPointMake(HUDLayer.frame.size.width / 2, HUDLayer.frame.size.height / 2) radius:HUDLayer.frame.size.width / 2 - BTTStrokeWidth startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    CAShapeLayer *outLayer = [CAShapeLayer layer];
    outLayer.path = circleOutPath.CGPath;
    outLayer.lineWidth = BTTStrokeWidth;
    outLayer.strokeColor = [UIColor colorWithCGColor:HUDLayer.strokeColor].CGColor;
    outLayer.fillColor = [UIColor colorWithCGColor:HUDLayer.strokeColor].CGColor;
    [HUDLayer addSublayer:outLayer];
    
    UIBezierPath *circleInsidePath = [UIBezierPath bezierPath];
    [circleInsidePath addArcWithCenter:CGPointMake(HUDLayer.frame.size.width / 2, HUDLayer.frame.size.height / 2) radius:HUDLayer.frame.size.width / 2 - BTTStrokeWidth startAngle:3 * M_PI_2 endAngle:3 * M_PI_2 + 2 * M_PI * progress clockwise:YES];
    
    [circleInsidePath addLineToPoint:CGPointMake(HUDLayer.frame.size.width / 2, HUDLayer.frame.size.height / 2)];
    [circleInsidePath closePath];
    
    CAShapeLayer *insideLayer = [CAShapeLayer layer];
    insideLayer.path = circleInsidePath.CGPath;
    [HUDLayer addSublayer:insideLayer];
    
    if ([[UIColor colorWithCGColor:HUDLayer.strokeColor]isEqual:[UIColor whiteColor]]) {
        insideLayer.fillColor = [UIColor blackColor].CGColor;
    }else{
        insideLayer.fillColor = [UIColor whiteColor].CGColor;
    }
    
}

//根据限定宽度计算文本宽高
- (CGSize)measureTextSize:(NSString *)text WithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize textSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

@end

