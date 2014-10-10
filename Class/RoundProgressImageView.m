//
//  RoundProgressImageView.m
//  FollowAnalysis
//
//  Created by xiekw on 14-4-10.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import "RoundProgressImageView.h"
#import "SDWebImageDownloaderOperation.h"
#import "SDWebImageManager.h"
#import <QuartzCore/QuartzCore.h>

static inline UIImage *imageWithColor(UIColor *color)
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@interface RoundProgressImageView ()
{
    CGFloat _ringRadius;
}

@property (nonatomic, strong) SDWebImageDownloaderOperation *imageOperation;
@property (nonatomic, strong) CAShapeLayer *ringLayer;
@property (nonatomic, strong) CAShapeLayer *fixedLayer;
@property (nonatomic, strong) NSURL *imageURL;

@end


@implementation RoundProgressImageView

- (id)init
{
    if (self = [super init]) {
        _ringRadius = 30.0f;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _ringRadius = 30.0f;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _ringRadius = 30.0f;
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void)prSetImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.imageURL = url;
    if (!placeholder) {
        placeholder = imageWithColor([UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]);
    }
    self.image = placeholder;
    
    [self updateDownloadProgress:-1];
    SDWebImageManager *sdManager = [SDWebImageManager sharedManager];
    self.imageOperation = [sdManager downloadWithURL:url options:1 progress:^(NSUInteger receivedSize, long long expectedSize) {
        CGFloat prg = (CGFloat)receivedSize/expectedSize;
        [self updateDownloadProgress:prg];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        [self updateDownloadProgress:1.0f];
        [self clearRing];
        if (error == nil) {
            CATransition *animation = [CATransition animation];
            animation.type = kCATransitionFade;
            animation.duration = 0.15f;
            [self.layer addAnimation:animation forKey:nil];
            self.image = image;
        }else {
            if (!self.restartBtn) {
                self.restartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.restartBtn setTitle:NSLocalizedString(@"Oops, load Image failed, tap to reload...", nil) forState:UIControlStateNormal];
                self.restartBtn.titleLabel.numberOfLines = 0;
                [self.restartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.restartBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                self.restartBtn.frame = CGRectMake(0, 0, 200, 40);
            }
            CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
            self.restartBtn.center = center;
            [self addSubview:self.restartBtn];

            [self.restartBtn addTarget:self action:@selector(restartOp:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }];
}

- (void)clearRing
{
    [self.ringLayer removeFromSuperlayer];
    self.ringLayer = nil;
    [self.fixedLayer removeFromSuperlayer];
    self.fixedLayer = nil;
}

- (void)restartOp:(id)sender
{
    [self.restartBtn removeFromSuperview];
    [self prSetImageWithURL:self.imageURL placeholderImage:self.image];
}

- (void)updateDownloadProgress:(CGFloat)prg
{
    self.ringLayer.strokeEnd = prg;
}

#define kRingLineWidth 8.0f

- (CAShapeLayer *)ringLayer
{
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    if (!_fixedLayer) {
        UIColor *color = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1];
        _fixedLayer = [self createRingLayerWithCenter:center radius:_ringRadius lineWidth:kRingLineWidth color:color];
        _fixedLayer.strokeEnd = 1.0f;
        [self.layer addSublayer:_fixedLayer];
    }
    
    if (!_ringLayer) {
        UIColor *color = [UIColor whiteColor];
        _ringLayer = [self createRingLayerWithCenter:center radius:_ringRadius lineWidth:kRingLineWidth color:color];
        [self.layer addSublayer:_ringLayer];
    }
    return _ringLayer;
}

- (CAShapeLayer *)createRingLayerWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    
    UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:-M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
    
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.contentsScale = [[UIScreen mainScreen] scale];
    slice.frame = CGRectMake(center.x-radius, center.y-radius, radius*2, radius*2);
    slice.fillColor = [UIColor clearColor].CGColor;
    slice.strokeColor = color.CGColor;
    slice.lineWidth = lineWidth;
    slice.lineCap = kCALineCapSquare;
    slice.lineJoin = kCALineJoinBevel;
    slice.path = smoothedPath.CGPath;
    return slice;
}

- (void)cancelImageLoadingOperation
{
    [self.restartBtn removeFromSuperview];
    [self clearRing];
    self.imageURL = nil;
    [self.imageOperation cancel];
    self.imageOperation = nil;
}


@end
