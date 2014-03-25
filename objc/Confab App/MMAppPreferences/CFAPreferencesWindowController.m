//
//  CFAPreferencesWindowController.m
//  Confab App
//
//  Created by Fabio Pelosin on 07/12/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import "CFAPreferencesWindowController.h"
#import "CFAGeneralPreferencesViewController.h"
#import "CFARoomPreferencesViewController.h"

@interface CFAPreferencesWindowController ()

@end

@implementation CFAPreferencesWindowController

- (id)init {
    NSViewController *generalVC = [[CFAGeneralPreferencesViewController alloc] initWithNibName:NSStringFromClass([CFAGeneralPreferencesViewController class]) bundle:nil];
    NSViewController *RoomVC = [[CFARoomPreferencesViewController alloc] initWithNibName:NSStringFromClass([CFARoomPreferencesViewController class]) bundle:nil];
    NSArray *controllers = @[generalVC, RoomVC];
    NSString *title = NSLocalizedString(@"Preferences", @"Title for Preferences window");

    self = [super initWithViewControllers:controllers title:title];
    return self;
}

@end
