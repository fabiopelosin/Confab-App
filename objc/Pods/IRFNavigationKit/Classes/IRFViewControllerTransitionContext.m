//
//  IRFViewControllerTransitionContext.m
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 16/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import "IRFViewControllerTransitionContext.h"


@implementation IRFViewControllerTransitionContext

- (NSViewController *)viewControllerForKey:(NSString *)key {
    if ([key isEqualToString:IRFTransitionContextFromViewControllerKey]) {
        return self.fromVC;
    } else if ([key isEqualToString:IRFTransitionContextToViewControllerKey]) {
        return self.toVC;
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"Unrecognized key %@", key];
        return nil;
    }
}

- (void)completeTransition:(BOOL)didComplete {
    [self.animator animationEnded:didComplete];
}

- (CGRect)initialFrameForViewController:(NSViewController *)vc {
    return self.containerView.bounds;
}

- (CGRect)finalFrameForViewController:(NSViewController *)vc {
    return self.containerView.bounds;
}


@end
