//
//  IRFViewControllerTransitionContext.h
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 16/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRFViewControllerContextTransitioning.h"
#import "IRFViewControllerAnimatedTransitioning.h"

@interface IRFViewControllerTransitionContext : NSObject <IRFViewControllerContextTransitioning>

@property (nonatomic, strong) NSView* containerView;

@property (nonatomic, strong) NSViewController *fromVC;

@property (nonatomic, strong) NSViewController *toVC;

@property BOOL isAnimated;

@property IRFModalPresentationStyle presentationStyle;

@property BOOL transitionWasCancelled;

@property id<IRFViewControllerAnimatedTransitioning> animator;

@end
