//
//  IRFNavigationItem.h
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 21/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRFBarButtonItem;

@interface IRFNavigationItem : NSObject

- (id)initWithTitle:(NSString *)title;

@property(nonatomic,copy)   NSString *title; // Title when topmost on the stack. default is nil
                                             //@property(nonatomic,retain) IRFBarButtonItem *backBarButtonItem; // Bar button item to use for the back button in the child navigation item.
                                             //@property(nonatomic,retain) NSView          *titleView;         // Custom view to use in lieu of a title. May be sized horizontally. Only used when item is topmost on the stack.

//@property(nonatomic,copy)   NSString *prompt;

//@property(nonatomic,assign) BOOL hidesBackButton; // If YES, this navigation item will hide the back button when it's on top of the stack.
//- (void)setHidesBackButton:(BOOL)hidesBackButton animated:(BOOL)animated;

//@property(nonatomic) BOOL leftItemsSupplementBackButton NS_AVAILABLE_IOS(5_0);


// Some navigation items want to display a custom left or right item when they're on top of the stack.
// A custom left item replaces the regular back button unless you set leftItemsSupplementBackButton to YES
//@property(nonatomic,retain) IRFBarButtonItem *leftBarButtonItem;
@property(nonatomic,retain) IRFBarButtonItem *rightBarButtonItem;
//- (void)setLeftBarButtonItem:(IRFBarButtonItem *)item animated:(BOOL)animated;
- (void)setRightBarButtonItem:(IRFBarButtonItem *)item animated:(BOOL)animated;

@end
