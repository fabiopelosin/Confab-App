//
//  IRFNavigationBarProtocol.h
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 21/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRFNavigationItem;
@protocol IRFNavigationBarDelegate;

/**
 *
 */
@protocol IRFNavigationBarProtocol <NSObject>

@required

///-----------------------------------------------------------------------------
/// @name - Assigning the Delegate
///-----------------------------------------------------------------------------

@property(nonatomic, assign) id <IRFNavigationBarDelegate> delegate;

///-----------------------------------------------------------------------------
/// @name Pushing and Popping Items
///-----------------------------------------------------------------------------

- (void)pushNavigationItem:(IRFNavigationItem *)item animated:(BOOL)animated;

- (IRFNavigationItem *)popNavigationItemAnimated:(BOOL)animated;

//- (void)setItems:(NSArray *)items animated:(BOOL)animated;

@property(nonatomic, copy) NSArray *items;

@property(nonatomic, readonly, retain) IRFNavigationItem *topItem;

@property(nonatomic, readonly, retain) IRFNavigationItem *backItem;

@end
