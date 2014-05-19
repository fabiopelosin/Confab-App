//
//  IRFFadeAnimator.h
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 16/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRFViewControllerAnimatedTransitioning.h"

/**
 * Provides a cross fade animation.
 */
@interface IRFFadeAnimator : NSObject <IRFViewControllerAnimatedTransitioning>

/**
 * The duration of the animation. Defaults to 0.25.
 */
@property (nonatomic, assign) NSTimeInterval transitionDuration;

@end
