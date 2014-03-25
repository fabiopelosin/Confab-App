//
//  MMWindowsManager.m
//  Confab App
//
//  Created by Fabio Pelosin on 23/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMWindowsManager.h"
#import "CFAPreferencesWindowController.h"

//------------------------------------------------------------------------------

@interface MMWindowsManager ()
@property NSMutableArray *windowControllers;
@property (nonatomic, strong) NSWindowController *preferencesWindowController;
@end

//------------------------------------------------------------------------------
@implementation MMWindowsManager
//------------------------------------------------------------------------------

- (id)init {
  self = [super init];
  if (self) {
    _windowControllers = [NSMutableArray new];
  }
  return self;
}

- (id)currentWindowController {
  return [[NSApp keyWindow] windowController];
}

- (MMMainWindowController *)newMainWindowController {
  MMMainWindowController *controller = [MMMainWindowController new];
  [self.windowControllers addObject:controller];
  return controller;
}

- (void)showNewMainWindow {
  MMMainWindowController *controller = [self newMainWindowController];
  [controller showWindow:self];
}

- (void)showMainWindowCreatingOneIfNeeded {
  NSWindowController *controller = [self.windowControllers lastObject];
  if (controller) {
    [controller showWindow:self];
  } else {
    [self showNewMainWindow];
  }
}

- (void)showPreferencesWindow {
  [self.preferencesWindowController showWindow:self];
}


//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (NSWindowController *)preferencesWindowController {
    if (_preferencesWindowController == nil) {
        _preferencesWindowController = [CFAPreferencesWindowController new];
    }
    return _preferencesWindowController;
}

@end
