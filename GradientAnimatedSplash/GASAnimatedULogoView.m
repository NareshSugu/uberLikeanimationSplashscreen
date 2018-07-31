//
//  GASAnimatedULogoView.m
//  GradientAnimatedSplash
//
//  Created by nsugu on 18/07/18.
//  Copyright © 2018 NSK. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "GASAnimatedULogoView.h"

@interface GASAnimatedULogoView ()

@property (nonnull,nonatomic) CAShapeLayer* circleLayer;
@property (nonnull,nonatomic) CAShapeLayer* squareLayer;
@property (nonnull,nonatomic) CAShapeLayer* lineLayer;
@property (nonnull,nonatomic) CAShapeLayer* maskLayer;

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat squareLayerLength;
@property (nonatomic) CGFloat startTimeOffset;
@property (nonatomic) CFTimeInterval beginTime;
@property (nonatomic) NSTimeInterval kAnimationDurationDelay;
@property (nonatomic) NSTimeInterval kAnimationDuration;
@property (nonatomic) CAMediaTimingFunction* circleLayerTimingFunction;
@property (nonatomic) CAMediaTimingFunction* strokeEndTimingFunction;
@property (nonatomic) CAMediaTimingFunction* fadeInSquareTimingFunction;
@property (nonatomic) CAMediaTimingFunction* squareLayerTimingFunction;

@end

@implementation GASAnimatedULogoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // do nothing
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _radius = 37.5;
        _beginTime = 0;
        _squareLayerLength = 21.0;
        _kAnimationDurationDelay = 0.5;
        _kAnimationDuration = 3.0;
        _startTimeOffset = 0.7 * _kAnimationDuration;
        _circleLayerTimingFunction = [CAMediaTimingFunction functionWithControlPoints:0.65 :0.0 :0.40 :1.0 - 1.0];
        _strokeEndTimingFunction = [CAMediaTimingFunction functionWithControlPoints:1.00 :0.0 :0.35 :1.0];
        _fadeInSquareTimingFunction = [CAMediaTimingFunction functionWithControlPoints:0.15 :0.0 :0.85 :1.0];
        _squareLayerTimingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.0 :0.20 :1.0];
        
        [self setupLayers];
    }
    return self;
}
-(void) setupLayers {
    _circleLayer = self.generateCircleLayer;
    _lineLayer = self.generateLineLayer;
    _squareLayer = self.generateSquareLayer;
    _maskLayer = self.generateMaskLayer;
    
    [self.layer setMask:_maskLayer];
    [self.layer addSublayer:_circleLayer];
    [self.layer addSublayer:_lineLayer];
    [self.layer addSublayer:_squareLayer];
}
-(CAShapeLayer*) generateCircleLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = _radius;
    layer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointZero
                                                 radius:_radius/2
                                             startAngle: - (CGFloat)M_PI_2
                                               endAngle:(CGFloat) (3 *M_PI_2)
                                              clockwise:YES] CGPath];
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    return layer;
}
-(CAShapeLayer*) generateLineLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.position = CGPointZero;
    layer.frame = CGRectZero;
    layer.allowsGroupOpacity = true;
    layer.lineWidth = 5.0;
    layer.strokeColor =[UIColor blueColor].CGColor;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(0.0, - _radius)];
    layer.path = [bezierPath CGPath];
    return layer;
}
-(CAShapeLayer*) generateSquareLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.position = CGPointZero;
    layer.frame = CGRectMake( -_squareLayerLength / 2.0, -_squareLayerLength / 2.0, _squareLayerLength, _squareLayerLength);
    layer.cornerRadius = 1.5;
    layer.allowsGroupOpacity = true;
    layer.backgroundColor = [UIColor blueColor].CGColor;
    return layer;
}
-(CAShapeLayer*) generateMaskLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake( -_radius, -_radius, _radius * 2.0, _radius * 2.0);
    layer.allowsGroupOpacity = true;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    return layer;
}

-(void) startAnimating {
    _beginTime= CACurrentMediaTime();
    [self.layer setAnchorPoint:CGPointZero];
    
    [self animateMaskLayer];
    [self animateCircleLayer];
    [self animateLineLayer];
    [self animateSquareLayer];
}

-(void) animateMaskLayer {
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, _radius * 2.0, _radius * 2.0)];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 2.0/3.0 * _squareLayerLength, 2.0/3.0 * _squareLayerLength)];
    boundsAnimation.duration = _kAnimationDurationDelay;
    boundsAnimation.beginTime = _kAnimationDuration - _kAnimationDurationDelay;
    boundsAnimation.timingFunction = _circleLayerTimingFunction;
    
    // cornerRadius
    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    
    cornerRadiusAnimation.beginTime = _kAnimationDuration - _kAnimationDurationDelay;
    cornerRadiusAnimation.duration = _kAnimationDurationDelay;
    cornerRadiusAnimation.fromValue = [NSNumber numberWithDouble:_radius];
    cornerRadiusAnimation.toValue = [NSNumber numberWithDouble:2];
    cornerRadiusAnimation.timingFunction = _circleLayerTimingFunction;
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setRemovedOnCompletion:false];
    groupAnimation.fillMode = kCAFillModeBoth;
    groupAnimation.beginTime = _beginTime;
    groupAnimation.repeatCount = INFINITY;
    groupAnimation.duration = _kAnimationDuration;
    groupAnimation.animations = @[boundsAnimation, cornerRadiusAnimation];
    groupAnimation.timeOffset = _startTimeOffset;
    [_maskLayer addAnimation:groupAnimation forKey:@"looping"];
    
}
-(void) animateCircleLayer {
    CAKeyframeAnimation *strokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.timingFunction = _strokeEndTimingFunction;
    strokeEndAnimation.duration = _kAnimationDuration - _kAnimationDurationDelay;
    strokeEndAnimation.values = @[@0.0, @1.0];
    strokeEndAnimation.keyTimes = @[@0.0, @1.0];
    
    
    // transform
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.timingFunction = _strokeEndTimingFunction;
    transformAnimation.duration = _kAnimationDuration - _kAnimationDurationDelay;
    CATransform3D startingTransform = CATransform3DMakeRotation (-(CGFloat)M_PI_4, 0, 0, 1);
    startingTransform = CATransform3DScale(startingTransform, 0.25, 0.25, 1);
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:startingTransform];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[strokeEndAnimation, transformAnimation];
    groupAnimation.repeatCount = INFINITY;
    groupAnimation.duration = _kAnimationDuration;
    groupAnimation.beginTime = _beginTime;
    groupAnimation.timeOffset = _startTimeOffset;
    [_circleLayer addAnimation:groupAnimation forKey:@"looping"];
}
-(void) animateLineLayer {
    
    CAKeyframeAnimation *lineWidthAnimation = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.values = @[@0.0, @5.0, @0.0];
    lineWidthAnimation.timingFunctions = @[_strokeEndTimingFunction, _circleLayerTimingFunction];
    lineWidthAnimation.duration = _kAnimationDuration;
    lineWidthAnimation.keyTimes = @[@0.0, @((_kAnimationDuration - _kAnimationDurationDelay) / _kAnimationDuration), @1.0];
    
    // transform
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformAnimation.timingFunctions = @[_strokeEndTimingFunction, _circleLayerTimingFunction];
    transformAnimation.duration = _kAnimationDuration;
    transformAnimation.keyTimes = @[@0.0, @((_kAnimationDuration - _kAnimationDurationDelay) / _kAnimationDuration), @1.0];
    CATransform3D transform = CATransform3DMakeRotation (-(CGFloat) (7.0 * M_PI_4), 0.0, 0.0, 1.0);
    transform = CATransform3DScale(transform, 0.25, 0.25, 1.0);
    transformAnimation.values =  @[[NSValue valueWithCATransform3D:transform],
                                   [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.15, 0.15, 1.0)]];
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.repeatCount = INFINITY;
    [groupAnimation setRemovedOnCompletion:false];
    groupAnimation.duration = _kAnimationDuration;
    groupAnimation.beginTime = _beginTime;
    groupAnimation.timeOffset = _startTimeOffset;
    groupAnimation.animations = @[lineWidthAnimation, transformAnimation];
    
    [_lineLayer addAnimation:groupAnimation forKey:@"looping"];
}
-(void) animateSquareLayer {
    
    // bounds
    id b1 = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 2.0/3.0 * _squareLayerLength, 2.0/3.0 * _squareLayerLength)];
    id b2 = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, _squareLayerLength, _squareLayerLength)];
    id b3 = [NSValue valueWithCGRect:CGRectZero];
    
    CAKeyframeAnimation *boundsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.values = @[b1, b2, b3];
    boundsAnimation.timingFunctions = @[_fadeInSquareTimingFunction, _circleLayerTimingFunction];
    boundsAnimation.duration = _kAnimationDuration;
    boundsAnimation.keyTimes = @[@0.0,@((_kAnimationDuration - _kAnimationDurationDelay) / _kAnimationDuration), @1.0];
    
    // backgroundColor
    CABasicAnimation *backgroundColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColorAnimation.fromValue = (__bridge id _Nullable)([UIColor whiteColor].CGColor);
    backgroundColorAnimation.toValue = (__bridge id _Nullable)([UIColor blueColor].CGColor);
    backgroundColorAnimation.timingFunction = _squareLayerTimingFunction;
    backgroundColorAnimation.fillMode = kCAFillModeBoth;
    backgroundColorAnimation.duration = _kAnimationDuration / (_kAnimationDuration - _kAnimationDurationDelay);
    backgroundColorAnimation.beginTime = _kAnimationDurationDelay * 2.0 / _kAnimationDuration;
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[boundsAnimation, backgroundColorAnimation];
    groupAnimation.repeatCount = INFINITY;
    groupAnimation.duration = _kAnimationDuration;
    [groupAnimation setRemovedOnCompletion:false];
    groupAnimation.beginTime = _beginTime;
    groupAnimation.timeOffset = _startTimeOffset;
    
    [_squareLayer addAnimation:groupAnimation forKey:@"looping"];
}


@end
