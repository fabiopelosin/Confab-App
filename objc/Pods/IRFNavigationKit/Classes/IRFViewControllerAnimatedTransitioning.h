//
//  IRFViewControllerAnimatedTransitioning.h
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 16/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRFViewControllerContextTransitioning.h"

@protocol IRFViewControllerAnimatedTransitioning <NSObject>

@required

- (void)animateTransition:(id<IRFViewControllerContextTransitioning>)transitionContext;

- (NSTimeInterval)transitionDuration:(id<IRFViewControllerContextTransitioning>)transitionContext;

@optional

- (void)animationEnded:(BOOL)transitionCompleted;

@end
