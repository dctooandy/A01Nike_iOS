//
//  CNPayDashedLineView.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/27.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayDashedLineView.h"

@implementation CNPayDashedLineView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.9 alpha:1].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0.5);
    CGFloat lengths[] = {5,3};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextAddLineToPoint(context, self.frame.size.width, 0.5);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}

@end
