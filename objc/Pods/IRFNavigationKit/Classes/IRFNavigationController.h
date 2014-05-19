//
//  IRFNavigationController.h
//  Confab App
//
//  Created by Fabio Pelosin on 02/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IRFNavigationControllerDelegate.h"

//UIKIT_EXTERN const CGFloat UINavigationControllerHideShowBarDuration;

@protocol IRFNavigationBarProtocol;
@class IRFNavigationItem;

/**
 * Mirrors UINavigationController with the following adaptations for a desktop
 * interface:
 *
 * - Takes a frame on initialization.
 * - I doesn't creates the navifation bar and allows to set one automatically.
 *   The navigation bar is notified about the events but its view is not 
 *   handled.
 * - No toolbar facilities are provided.
 * - No support for iterative transitions.
 */
@interface IRFNavigationController : NSViewController

///-----------------------------------------------------------------------------
/// @name Creating Navigation Controllers
///-----------------------------------------------------------------------------

/**
 * The designated initializer.
 */
- (id)initWithFrame:(NSRect)frame rootViewController:(NSViewController *)rootViewController;

///-----------------------------------------------------------------------------
/// @name Accessing Items on the Navigation Stack
///-----------------------------------------------------------------------------

@property(nonatomic, readonly, retain) NSViewController *topViewController;

@property(nonatomic, readonly, retain) NSViewController *visibleViewController;

@property(nonatomic, copy) NSArray *viewControllers;

//- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

///-----------------------------------------------------------------------------
/// @name Pushing and Popping Stack Items
///-----------------------------------------------------------------------------

- (void)pushViewController:(NSViewController *)viewController animated:(BOOL)animated;

- (NSViewController *)popViewControllerAnimated:(BOOL)animated;

//- (NSArray *)popToViewController:(NSViewController *)viewController animated:(BOOL)animated;

//- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

///-----------------------------------------------------------------------------
/// @name Configuring Navigation Bars
///-----------------------------------------------------------------------------

@property (nonatomic) id<IRFNavigationBarProtocol> navigationBar;

///-----------------------------------------------------------------------------
/// @name Accessing the Delegate
///-----------------------------------------------------------------------------

@property(nonatomic, assign) id<IRFNavigationControllerDelegate> delegate;

@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@interface NSViewController (IRFNavigationControllerItem)

//@property(nonatomic,readonly,retain) NSNavigationItem *navigationItem;

//@property(nonatomic,readonly,retain) DSNavigationController *navigationController;

@end

