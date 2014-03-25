//
//  MMGeneralPreferencesViewController.m
//  Confab App
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "CFAGeneralPreferencesViewController.h"
#import "CFAPreferencesManager.h"
#import "CFAAuthorizationCredentialsVault.h"

@implementation CFAGeneralPreferencesViewController

//------------------------------------------------------------------------------
#pragma mark - MASPreferencesViewController
//------------------------------------------------------------------------------

- (NSString *)identifier {
  return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage {
  return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel {
  return NSLocalizedString(@"General", @"Toolbar item name for the general preference panel");
}

- (void)viewWillAppear {
}

//------------------------------------------------------------------------------
#pragma mark - Preferences Logic
//------------------------------------------------------------------------------

- (IBAction)_resetAuthDataButtonAction:(id)sender {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[CFAAuthorizationCredentialsVault sharedInstance] clearAuthData];
}

@end
