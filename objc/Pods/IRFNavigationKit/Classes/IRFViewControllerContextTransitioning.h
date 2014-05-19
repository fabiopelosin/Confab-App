//
//  IRFViewControllerContextTransitioning.h
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 16/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSViewController+IRFNavigationKit.h"

FOUNDATION_EXTERN NSString *const IRFTransitionContextFromViewControllerKey;
FOUNDATION_EXTERN NSString *const IRFTransitionContextToViewControllerKey;

@protocol IRFViewControllerContextTransitioning <NSObject>

@required

///-----------------------------------------------------------------------------
/// @name Accessing the Transition Objects
///-----------------------------------------------------------------------------

- (NSView*)containerView;

- (NSViewController *)viewControllerForKey:(NSString *)key;

///-----------------------------------------------------------------------------
/// @name Defining the Transition Behaviors
///-----------------------------------------------------------------------------

- (BOOL)isAnimated;

- (IRFModalPresentationStyle)presentationStyle;

///-----------------------------------------------------------------------------
/// @name Reporting the Transition Progress
///-----------------------------------------------------------------------------

- (BOOL)transitionWasCancelled;

- (void)completeTransition:(BOOL)didComplete;

///-----------------------------------------------------------------------------
/// @name Getting the Transition Frame Rectangles
///-----------------------------------------------------------------------------

- (CGRect)initialFrameForViewController:(NSViewController *)vc;

- (CGRect)finalFrameForViewController:(NSViewController *)vc;

@end
