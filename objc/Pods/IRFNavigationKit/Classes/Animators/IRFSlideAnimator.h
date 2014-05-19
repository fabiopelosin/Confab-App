//
//  IRFSlideAnimator.h
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 16/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRFViewControllerAnimatedTransitioning.h"

/**
 * Provides a slide animation similar to the one found on the 
 * UIViewControllerBuiltinTransitionViewAnimator.h
 */
@interface IRFSlideAnimator : NSObject <IRFViewControllerAnimatedTransitioning>

/**
 * The duration of the animation. Defaults to 0.25.
 */
@property (nonatomic, assign) NSTimeInterval transitionDuration;

/**
 * Whether the animation should be performed left to right (i.e. moving
 * back). Defaults to false.
 */
@property (nonatomic, assign) BOOL reversed;


@end
