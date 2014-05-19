//
//  IRFSlideAnimator.m
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 16/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import "IRFSlideAnimator.h"

@implementation IRFSlideAnimator

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
    NSViewController* fromVC = [transitionContext viewControllerForKey:IRFTransitionContextFromViewControllerKey];
    NSRect toVCStartFrame = [transitionContext finalFrameForViewController:toVC];
    NSRect fromVCFinalFrame = [transitionContext finalFrameForViewController:fromVC];
    if (self.reversed) {
        fromVCFinalFrame.origin.x += toVCStartFrame.size.width;
        [toVC.view setFrame:toVCStartFrame];
        [[transitionContext containerView] addSubview:toVC.view positioned:NSWindowBelow relativeTo:fromVC.view];
    } else {
        toVCStartFrame.origin.x += toVCStartFrame.size.width;
        [toVC.view setFrame:toVCStartFrame];
        [[transitionContext containerView] addSubview:toVC.view];
    }

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect toVCFinalFrame = [transitionContext finalFrameForViewController:toVC];
        [[toVC.view animator] setFrame:toVCFinalFrame];
        [[fromVC.view animator] setFrame:fromVCFinalFrame];
    } completionHandler:^{
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)animationEnded:(BOOL)transitionCompleted {

}

@end
