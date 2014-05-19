//
//  IRFNavigationController.m
//  Confab App
//
//  Created by Fabio Pelosin on 02/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "IRFNavigationController.h"
#import "IRFNavigationBar.h"
#import "NSViewController+IRFNavigationKit.h"
#import "IRFViewControllerTransitionContext.h"
#import "IRFSlideAnimator.h"
#import "IRFNavigationItem.h"
#import "IRFNavigationBarDelegate.h"

static const CGFloat kPushPopAnimationDuration = 0.2;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@interface IRFNavigationController () <IRFNavigationBarDelegate>
@property NSMutableArray *mutableViewControllers;
@property BOOL navigationBarInitiatedAction;
@property BOOL transitioning;
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation IRFNavigationController

//------------------------------------------------------------------------------
#pragma mark - Creating Navigation Controllers
//------------------------------------------------------------------------------

- (id)initWithFrame:(NSRect)frame rootViewController:(NSViewController *)rootViewController {
    if(self = [super initWithNibName: nil bundle: nil]) {
        self.view = [[NSView alloc] initWithFrame:frame];
        self.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

        if (!rootViewController) {
            rootViewController = [[NSViewController alloc] init];
            rootViewController.view = [[NSView alloc] initWithFrame:frame];
        }

        _mutableViewControllers = [NSMutableArray array];

        [self pushViewController:rootViewController animated:NO];

        if ([rootViewController respondsToSelector: @selector(viewWillAppear:)]) {
            [(id<IRFNavigationKit>)rootViewController viewWillAppear:NO];
        }
    }
    return self;
}

- (void)setNavigationBar:(IRFNavigationBar *)navigationBar {
    [_navigationBar setDelegate:nil];
    _navigationBar = navigationBar;
    [_navigationBar setDelegate:self];

    // TODO
    IRFNavigationItem *navigationItem = [[IRFNavigationItem alloc] initWithTitle:self.topViewController.title];
    [self.navigationBar pushNavigationItem:navigationItem animated:NO];
}

//------------------------------------------------------------------------------
#pragma mark - Accessing Items on the Navigation Stack
//------------------------------------------------------------------------------

- (void)pushViewController:(NSViewController *)viewController animated:(BOOL)animated {
    NSViewController *visibleController = self.visibleViewController;
    [_mutableViewControllers addObject:viewController];
    [self _navigateFromViewController:visibleController toViewController:viewController animated:animated operation:IRFNavigationControllerOperationPush];

    IRFNavigationItem *navigationItem = [[IRFNavigationItem alloc] initWithTitle:viewController.title];
    [self.navigationBar pushNavigationItem:navigationItem animated:animated];
}

- (NSViewController *)popViewControllerAnimated:(BOOL)animated {
    if([_mutableViewControllers count] == 1) {
        return nil;
    }

    NSViewController *controller = [self topViewController];
    [_mutableViewControllers removeLastObject];
    [self _navigateFromViewController:controller toViewController:[self topViewController] animated:animated operation:IRFNavigationControllerOperationPop];
    // [self.navigationBar popNavigationItemAnimated:animated];
    return controller;
}

- (NSViewController *)visibleViewController {
    return [_mutableViewControllers lastObject];
}

- (NSViewController *)topViewController {
    return [_mutableViewControllers lastObject];
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

/*
 * It is important to load the view before calling view will appear
 */
-(void)_navigateFromViewController:(NSViewController *)fromVC toViewController:(NSViewController *)toVC animated:(BOOL)animated operation:(IRFNavigationControllerOperation)operation {
    if (self.transitioning) {
        [NSException raise:NSInternalInconsistencyException format:@"Attempt to start a transition with one in progress"];
    } else {
        [self setTransitioning:YES];
    }

    // TODO: Not sure about where this should go.
    [toVC.view setAutoresizingMask:self.view.autoresizingMask];
    [toVC.view setFrame:[self.view bounds]];

    if (toVC.view) {
        if([toVC respondsToSelector:@selector(viewWillAppear:)]) {
            [(id<IRFNavigationKit>)toVC viewWillAppear:animated];
            if ([self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
                [self.delegate navigationController:self willShowViewController:toVC animated:animated];
            }
        }
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"Attempt to push view controller without view: %@", [toVC debugDescription]];
    }

    if([fromVC respondsToSelector:@selector(viewWillDisappear:)]) {
        [(id<IRFNavigationKit>)fromVC viewWillDisappear:animated];
    }

    if(animated) {
        id<IRFViewControllerAnimatedTransitioning> animator;
        if ([self.delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
            animator = [self.delegate navigationController:self animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
        }

        if (!animator) {
            IRFSlideAnimator *slideAnimator = [IRFSlideAnimator new];
            [slideAnimator setReversed:operation == IRFNavigationControllerOperationPop];
            animator = slideAnimator;
        }

        IRFViewControllerTransitionContext *context = [IRFViewControllerTransitionContext new];
        [context setContainerView:self.view];
        [context setFromVC:fromVC];
        [context setToVC:toVC];
        [context setIsAnimated:TRUE];
        [context setPresentationStyle:IRFModalPresentationCurrentContext];
        [context setTransitionWasCancelled:NO];
        [context setAnimator:animator];

        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *animationContext) {
            [animationContext setDuration:[animator transitionDuration:context]];
            [animator animateTransition:context];
        } completionHandler:^{
            [fromVC.view removeFromSuperview];
            [self _completeTransitionFromViewController:fromVC toViewController:toVC animated:animated];
        }];
    }
    else {
        [fromVC.view removeFromSuperview];
        [self.view addSubview:toVC.view];
        [self _completeTransitionFromViewController:fromVC toViewController:toVC animated:animated];
    }
}

- (void)_completeTransitionFromViewController:(NSViewController *)fromVC toViewController:(NSViewController *)toVC animated:(BOOL)animated {
    [self setTransitioning:NO];
    
    if([toVC respondsToSelector:@selector(viewDidAppear:)]) {
        [(id<IRFNavigationKit>)toVC viewDidAppear:animated];
    }

    if([fromVC respondsToSelector:@selector(viewDidDisappear:)]) {
        [(id<IRFNavigationKit>)fromVC viewDidDisappear:animated];
    }
}

//------------------------------------------------------------------------------
#pragma mark - IRFNavigationBarDelegate
//------------------------------------------------------------------------------

- (BOOL)navigationBar:(IRFNavigationBar *)navigationBar shouldPushItem:(IRFNavigationItem *)item {
    return TRUE;
}

- (void)navigationBar:(IRFNavigationBar *)navigationBar didPushItem:(IRFNavigationItem *)item {

}

- (BOOL)navigationBar:(IRFNavigationBar *)navigationBar shouldPopItem:(IRFNavigationItem *)item {
    [self popViewControllerAnimated:TRUE];
    return TRUE;
}

- (void)navigationBar:(IRFNavigationBar *)navigationBar didPopItem:(IRFNavigationItem *)item {

}

@end
