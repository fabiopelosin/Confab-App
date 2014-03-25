//
//  CFARoomPreferencesViewController.m
//  Confab App
//
//  Created by Fabio Pelosin on 07/12/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import "CFARoomPreferencesViewController.h"
#import "CFAPreferencesManager.h"

@implementation CFARoomPreferencesViewController

//------------------------------------------------------------------------------
#pragma mark - MASPreferencesWindowController
//------------------------------------------------------------------------------

- (NSString *)identifier {
    return @"RoomsPreferences";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNameListViewTemplate];
}

- (NSString *)toolbarItemLabel {
    return NSLocalizedString(@"Rooms", @"Toolbar item name for the rooms preference panel");
}

- (void)viewWillAppear {
    if ([CFAPreferencesManager sharedInstance].notifyOnlyForMentions) {
        self.postNotificationsOnlyForMentionsCheckBox.state = NSOnState;
    } else {
        self.postNotificationsOnlyForMentionsCheckBox.state = NSOffState;
    }
}

//------------------------------------------------------------------------------
#pragma mark - Preferences Logic
//------------------------------------------------------------------------------

- (IBAction)postNotificationsOnlyForMentionsCheckBoxAction:(NSButton *)sender {
    if (sender.state == NSOnState) {
        [CFAPreferencesManager sharedInstance].notifyOnlyForMentions = TRUE;
    } else {
        [CFAPreferencesManager sharedInstance].notifyOnlyForMentions = FALSE;
    }
}

@end
