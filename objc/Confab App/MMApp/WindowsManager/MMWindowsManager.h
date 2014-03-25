//
//  MMWindowsManager.h
//  Confab App
//
//  Created by Fabio Pelosin on 23/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMMainWindowController.h"

//------------------------------------------------------------------------------
@interface MMWindowsManager : NSObject
//------------------------------------------------------------------------------

- (MMMainWindowController *)currentWindowController;
- (void)showNewMainWindow;
- (void)showMainWindowCreatingOneIfNeeded;
- (void)showPreferencesWindow;


@end
