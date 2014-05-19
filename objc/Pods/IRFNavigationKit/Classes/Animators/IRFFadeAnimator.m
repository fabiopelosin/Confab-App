//
//  IRFFadeAnimator.m
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 16/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import "IRFFadeAnimator.h"

@implementation IRFFadeAnimator

- (id)init
{
    self = [super init];
    if (self) {
        _transitionDuration = 0.25f;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<IRFViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

- (void)animateTransition:(id<IRFViewControllerContextTransitioning>)transitionContext {
    NSViewController* toVC = [transitionContext viewControllerForKey:IRFTransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toVC.view];
    [toVC.view setAlphaValue:0.0];

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [[toVC.view animator] setAlphaValue:0.f];
        [[toVC.view animator] setAlphaValue:1.f];
    } completionHandler:^{
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)animationEnded:(BOOL)transitionCompleted {
    
}

@end
