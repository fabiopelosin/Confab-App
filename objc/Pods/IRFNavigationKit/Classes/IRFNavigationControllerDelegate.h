//
//  IRFNavigationControllerDelegate.h
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 16/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRFViewControllerAnimatedTransitioning.h"

@class IRFNavigationController;

typedef NS_ENUM(NSUInteger, IRFNavigationControllerOperation) {
    IRFNavigationControllerOperationNone,
    IRFNavigationControllerOperationPush,
    IRFNavigationControllerOperationPop
};

@protocol IRFNavigationControllerDelegate <NSObject>

@optional

///-----------------------------------------------------------------------------
/// @name Responding to a View Controller Being Shown
///-----------------------------------------------------------------------------

- (void)navigationController:(IRFNavigationController *)navigationController willShowViewController:(NSViewController *)viewController animated:(BOOL)animated;

///-----------------------------------------------------------------------------
/// @name Supporting Custom Transition Animations
///-----------------------------------------------------------------------------

- (id<IRFViewControllerAnimatedTransitioning>)navigationController:(IRFNavigationController *)navigationController animationControllerForOperation:(IRFNavigationControllerOperation)operation fromViewController:(NSViewController*)fromVC toViewController:(NSViewController*)toVC;

@end
