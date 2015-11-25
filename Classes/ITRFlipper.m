//
//  ITRFlipper.m
//  ITRFlipView
//
//  Created by kiruthika selvavinayagam on 10/15/15.
//  Copyright © 2015 kiruthika selvavinayagam. All rights reserved.
//

#import "ITRFlipper.h"

@interface ITRFlipper()
{
    NSInteger currentPage;
    NSInteger numberOfPages;
    
    CALayer *backgroundLayer;
    CALayer *flipLayer;
    
    ITRFlipDirection flipDirection;
    float startFlipAngle;
    float endFlipAngle;
    float currentAngle;
    
    BOOL setNextViewOnCompletion;
    BOOL animating;
    
    UITapGestureRecognizer *_tapRecognizer;
    UIPanGestureRecognizer *_panRecognizer;
    
    UIView *_currentView;
    UIView *_nextView;
}

@end

@implementation ITRFlipper

#pragma init method

- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        
        [self addGestureRecognizer:_panRecognizer];
        [self addGestureRecognizer:_tapRecognizer];
    }
    return self;
}

- (void) initFlip {
    
    //create image from UIView
    UIImage *currentImage = [self imageByRenderingView:_currentView];
    UIImage *newImage = [self imageByRenderingView:_nextView];
    
    _currentView.alpha = 0;
    _nextView.alpha = 0;
    
    backgroundLayer = [CALayer layer];
    backgroundLayer.frame = self.bounds;
    backgroundLayer.zPosition = -300000;
    
    //create top & bottom layer
    CGRect rect = self.bounds;
    rect.size.height /= 2;
    
    CALayer *topLayer = [CALayer layer];
    topLayer.frame = rect;
    topLayer.masksToBounds = YES;
    topLayer.contentsGravity = kCAGravityBottom;
    
    [backgroundLayer addSublayer:topLayer];
    
    rect.origin.y = rect.size.height;
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = rect;
    bottomLayer.masksToBounds = YES;
    bottomLayer.contentsGravity = kCAGravityTop;
    
    [backgroundLayer addSublayer:bottomLayer];
    
    if (flipDirection == ITRFlipDirectionBottom) {// flip from top to bottom
        topLayer.contents = (id) [newImage CGImage];
        bottomLayer.contents = (id) [currentImage CGImage];
    } else {//flip from bottom to top
        topLayer.contents = (id) [currentImage CGImage];
        bottomLayer.contents = (id) [newImage CGImage];
    }
    
    [self.layer addSublayer:backgroundLayer];
    
    rect.origin.y = 0;
    
    flipLayer = [CATransformLayer layer];
    flipLayer.anchorPoint = CGPointMake(0.5, 1.0);
    flipLayer.frame = rect;
    
    [self.layer addSublayer:flipLayer];
    
    CALayer *backLayer = [CALayer layer];
    backLayer.frame = flipLayer.bounds;
    backLayer.doubleSided = NO;
    backLayer.masksToBounds = YES;
    
    [flipLayer addSublayer:backLayer];
    
    CALayer *frontLayer = [CALayer layer];
    frontLayer.frame = flipLayer.bounds;
    frontLayer.doubleSided = NO;
    frontLayer.masksToBounds = YES;
    frontLayer.transform = CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0);
    
    [flipLayer addSublayer:frontLayer];
    
    if (flipDirection == ITRFlipDirectionBottom) {
        backLayer.contents = (id) [currentImage CGImage];
        backLayer.contentsGravity = kCAGravityBottom;
        
        frontLayer.contents = (id) [newImage CGImage];
        frontLayer.contentsGravity = kCAGravityTop;
        
        CATransform3D transform = CATransform3DMakeRotation(0.0, 1.0, 0.0, 0.0);
        transform.m34 = -1.0f / 1500.0f;
        
        flipLayer.transform = transform;
        
        currentAngle = startFlipAngle = 0;
        endFlipAngle = M_PI;
    } else {
        backLayer.contentsGravity = kCAGravityBottom;
        backLayer.contents = (id) [newImage CGImage];
        
        frontLayer.contents = (id) [currentImage CGImage];
        frontLayer.contentsGravity = kCAGravityTop;
        
        CATransform3D transform = CATransform3DMakeRotation(M_PI / 1.0, 1.0, 0.0, 0.0);
        transform.m34 = 1.0f / 1500.0f;
        
        flipLayer.transform = transform;
        
        currentAngle = startFlipAngle = M_PI;
        endFlipAngle = 0;
    }
}

#pragma flip

- (void) flipPage {
    [self setFlipProgress:1.0 setDelegate:YES animate:YES];
}

- (void) setFlipProgress:(float) progress setDelegate:(BOOL) setDelegate animate:(BOOL) animate {
    if (animate) {
        animating = YES;
    }
    
    float angle = startFlipAngle + progress * (endFlipAngle - startFlipAngle);
    
    float duration = animate ? 0.5 * fabs((angle - currentAngle) / (endFlipAngle - startFlipAngle)) : 0;
    
    currentAngle = angle;
    
    CATransform3D finalTransform = CATransform3DIdentity;
    finalTransform.m34 = 1.0f / 2500.0f;
    finalTransform = CATransform3DRotate(finalTransform, angle, 1.0, 0.0, 0.0);
    
    [flipLayer removeAllAnimations];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    
    flipLayer.transform = finalTransform;
    
    [CATransaction commit];
    
    if (setDelegate) {
        [self performSelector:@selector(cleanupFlip) withObject:Nil afterDelay:duration];
    }
}

//clear flip & background layer
- (void) cleanupFlip {
    
    [backgroundLayer removeFromSuperlayer];
    [flipLayer removeFromSuperlayer];
    
    backgroundLayer = Nil;
    flipLayer = Nil;
    
    animating = NO;
    
    if (setNextViewOnCompletion && _nextView) {
        [_currentView removeFromSuperview];
        _currentView = _nextView;
        _nextView = Nil;
    }
    
    _currentView.alpha = 1;
}

#pragma selector

- (void)animationDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
    [self cleanupFlip];
}


#pragma setter

- (void) setCurrentPage:(NSInteger) page {
   
    if (![self canSetCurrentPage:page]) {
        return;
    }
    
    setNextViewOnCompletion = YES;
    animating = YES;
    
    _nextView.alpha = 0;
    
    [UIView beginAnimations:@"" context:Nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    _nextView.alpha = 1;
    
    [UIView commitAnimations];
}

- (void) setCurrentPage:(NSInteger) page animated:(BOOL) animated {
    if (![self canSetCurrentPage:page]) {
        return;
    }
    
    setNextViewOnCompletion = YES;
    animating = YES;
    
    if (animated) {
        [self initFlip];
        [self performSelector:@selector(flipPage) withObject:Nil afterDelay:0.001];
    } else {
        [self animationDidStop:Nil finished:[NSNumber numberWithBool:NO] context:Nil];
    }
    
}

- (void) setDataSource:(NSObject <ITRFlipperDataSource>*) dataSource {
    
    _dataSource = dataSource;
    numberOfPages = [_dataSource numberOfPagesinFlipper:self];
    currentPage = 0;
    
    //pagecontrol current page
    self.currentPage = 1;
}


- (BOOL) canSetCurrentPage:(NSInteger) page {
    
    if (page == currentPage) {
        return NO;
    }
    
    flipDirection = page < currentPage ? ITRFlipDirectionBottom : ITRFlipDirectionTop;
    currentPage= page;
    
    _nextView = [self.dataSource viewForPage:page inFlipper:self];
    [self addSubview:_nextView];
    
    return YES;
}

#pragma Gesture recognizer handler

- (void) tapped:(UITapGestureRecognizer *) recognizer {
    
    if (!animating) {
        if (recognizer.state == UIGestureRecognizerStateRecognized) {
            NSInteger newPage;
            
            if ([recognizer locationInView:self].y < (self.bounds.size.height - self.bounds.origin.y) / 2) {
                newPage = MAX(1, currentPage - 1);
            } else {
                newPage = MIN(currentPage + 1, numberOfPages);
            }
            
            [self setCurrentPage:newPage animated:YES];
        }
    }
}


- (void) panned:(UIPanGestureRecognizer *) recognizer {
    
    if (!animating) {
        
        static BOOL hasFailed;
        static BOOL initialized;
        static NSInteger lastPage;
        
        float translation = [recognizer translationInView:self].y;
        
        float progress = translation / self.bounds.size.height;
        
        if (flipDirection == ITRFlipDirectionTop) {
            progress = MIN(progress, 0);
        } else {
            progress = MAX(progress, 0);
        }
        
        switch (recognizer.state) {
                
            case UIGestureRecognizerStateBegan:
                hasFailed = FALSE;
                initialized = FALSE;
                animating = NO;
                setNextViewOnCompletion = NO;
                break;
                
            case UIGestureRecognizerStateChanged:
                
                if (!hasFailed) {
                    if (!initialized) {
                        
                        lastPage = currentPage;
                        if (translation > 0) {
                            if (currentPage > 1) {
                                [self canSetCurrentPage:currentPage - 1];
                            } else {
                                hasFailed = TRUE;
                                return;
                            }
                        } else {
                            if (currentPage < numberOfPages) {
                                [self canSetCurrentPage:currentPage + 1];
                            } else {
                                hasFailed = TRUE;
                                return;
                            }
                        }
                        hasFailed = NO;
                        initialized = TRUE;
                        setNextViewOnCompletion = NO;
                        
                        [self initFlip];
                    }
                    [self setFlipProgress:fabs(progress) setDelegate:NO animate:NO];
                }
                break;
            
            case UIGestureRecognizerStateFailed:
                [self setFlipProgress:0.0 setDelegate:YES animate:YES];
                currentPage = lastPage;
                break;
                
            case UIGestureRecognizerStateRecognized:
                if (hasFailed) {
                    [self setFlipProgress:0.0 setDelegate:YES animate:YES];
                    currentPage = lastPage;
                    return;
                }
                
                if (fabs((translation + [recognizer velocityInView:self].y / 4) / self.bounds.size.height) > 0.5) {
                    setNextViewOnCompletion = YES;
                    [self setFlipProgress:1.0 setDelegate:YES animate:YES];
                } else {
                    [self setFlipProgress:0.0 setDelegate:YES animate:YES];
                    currentPage = lastPage;
                }
                break;
                
            default:
                break;
        }
    }
}

//return UIView as UIImage by rendering view
- (UIImage *) imageByRenderingView:(UIView *)view {
    
    CGFloat viewAlpha = view.alpha;
    view.alpha = 1;
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.alpha = viewAlpha;
    return resultingImage;
}

@end
