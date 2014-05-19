//
//  DSNSNavigationBar.m
//  Confab App
//
//  Created by Fabio Pelosin on 02/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "IRFNavigationBar.h"
#import "IRFNavigationItem.h"
#import "IRFBarButtonItem.h"
#import "IRFNavigationBarDelegate.h"

@interface IRFNavigationBar ()
@property NSMutableArray *navigationItems;
@property NSTextField *titleTextField;
@property NSButton *leftButton;
@property NSButton *rightButton;
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation IRFNavigationBar

@synthesize delegate;
@synthesize items;
@synthesize topItem;
@synthesize backItem;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [self _setUp];
}

- (void)_setUp {
    _navigationItems = [NSMutableArray new];
    _tintColor = [NSColor blackColor];
    _barTintColor = [NSColor whiteColor];
    _titleTextAttributes = @{};

    NSRect titleTextField = CGRectMake(60, 10, CGRectGetWidth(self.frame) - 120, CGRectGetHeight(self.frame) - 20);
    _titleTextField = [[NSTextField alloc] initWithFrame:titleTextField];
    [_titleTextField setTextColor:[NSColor blackColor]];
    [_titleTextField setFont:[NSFont boldSystemFontOfSize:12]];
    [_titleTextField setEditable:NO];
    [_titleTextField setAlignment:NSCenterTextAlignment];
    [_titleTextField setBezeled:NO];
    [_titleTextField setBordered:NO];
    [_titleTextField setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [self addSubview:_titleTextField];

    NSRect leftButtonFrame = CGRectMake(10, 10, 100, CGRectGetHeight(self.frame) - 20);
    _leftButton = [[NSButton alloc] initWithFrame:leftButtonFrame];
    [_leftButton setFont:[NSFont systemFontOfSize:12]];
    [_leftButton setAlignment:NSLeftTextAlignment];
    [_leftButton setBordered:NO];
    [_leftButton setAutoresizingMask: NSViewMinXMargin | NSViewWidthSizable | NSViewHeightSizable];
    [_leftButton setHidden:YES];
    [_leftButton setTarget:self];
    [_leftButton setAction:@selector(_leftButtonClick:)];
    [self addSubview:_leftButton];

    NSRect rigthButtonFrame = CGRectMake(CGRectGetWidth(self.frame) - 110, 10, 100, CGRectGetHeight(self.frame) - 20);
    _rightButton = [[NSButton alloc] initWithFrame:rigthButtonFrame];
    [_rightButton setFont:[NSFont systemFontOfSize:12]];
    [_rightButton setAlignment:NSLeftTextAlignment];
    [_rightButton setBordered:NO];
    [_rightButton setAutoresizingMask: NSViewMinXMargin | NSViewWidthSizable | NSViewHeightSizable];
    [_rightButton setHidden:YES];
    [_rightButton setTarget:self];
    [_rightButton setAction:@selector(_rigthButtonClick:)];
    [self addSubview:_rightButton];
}

- (void)setTintColor:(NSColor *)tintColor {
    _tintColor = tintColor;
    [self setNeedsDisplay:TRUE];
}

//------------------------------------------------------------------------------
#pragma mark - Pop and pushing
//------------------------------------------------------------------------------

- (void)pushNavigationItem:(IRFNavigationItem *)item animated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(navigationBar:shouldPushItem:)]) {
        if (![self.delegate navigationBar:self shouldPushItem:item]) {
            return;
        }
    }
    [self.navigationItems addObject:item];
    [self _navigateToItem:item animated:animated pushAnimation:YES];
    [self.delegate navigationBar:self didPushItem:item];
}

- (IRFNavigationItem *)popNavigationItemAnimated:(BOOL)animated {
    IRFNavigationItem *previousItem = [self.navigationItems lastObject];

    if ([self.delegate respondsToSelector:@selector(navigationBar:shouldPopItem:)]) {
        if (![self.delegate navigationBar:self shouldPopItem:previousItem]) {
            return nil;
        }
    }

    [self.navigationItems removeLastObject];
    [self _navigateToItem:[self.navigationItems lastObject] animated:animated pushAnimation:NO];
    [self.delegate navigationBar:self didPopItem:previousItem];
    return previousItem;
}

//------------------------------------------------------------------------------
#pragma mark - Drawing
//------------------------------------------------------------------------------

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
    CGRect slice;
    CGRect remainder;
    CGRectDivide(self.bounds, &slice, &remainder, 1.0, CGRectMinYEdge);
    [[NSColor colorWithCalibratedWhite:0.715 alpha:1.000] setFill];
    NSRectFill(slice);
    [self.barTintColor setFill];
    NSRectFill(remainder);
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (void)_leftButtonClick:(NSButton*)sender {
    [self popNavigationItemAnimated:YES];
}

- (void)_rigthButtonClick:(NSButton*)sender {
    NSLog(@"rightButton");
}

- (void)_setTitle:(NSString*)title button:(NSButton*)button {
    NSDictionary *attributes = @{ NSForegroundColorAttributeName: self.tintColor };
    if (title) {
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
        [button setAttributedTitle:attributedTitle];
    } else {
        [button setTitle:@""];
    }
}

- (void)_navigateToItem:(IRFNavigationItem *)item animated:(BOOL)animated pushAnimation:(BOOL)pushAnimation {
    if (item.title) {
        [self.titleTextField setStringValue:item.title];
    } else {
        [self.titleTextField setStringValue:@"No Title"];
    }

    IRFNavigationItem *previousItem;
    NSUInteger itemsCount = [self.navigationItems count];
    if (itemsCount > 1) {
        previousItem = [self.navigationItems objectAtIndex:itemsCount-2];
    }

    if (previousItem) {
        [self _setTitle:previousItem.title button:self.leftButton];
        [self.leftButton setHidden:NO];
    } else {
        [self.leftButton setHidden:YES];
    }

    if (item.rightBarButtonItem) {
        [self _setTitle:[[item.rightBarButtonItem possibleTitles] anyObject] button:self.rightButton];
        [self.rightButton setHidden:NO];
    } else {
        [self.rightButton setHidden:YES];
    }
}

@end

//------------------------------------------------------------------------------



