//
//  MMAppDelegate.m
//  Confab App
//
//  Created by Fabio Pelosin on 18/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMAppDelegate.h"
#import "MMDataStackManager.h"
#import "MMNetworkStackManager.h"
#import "MMWindowsManager.h"

#import <IFBKCampground/IFBKCampground.h>
#import "CFAAuthWindowController.h"
#import "CFAAuthorizationCredentialsVault.h"

#define DEBUG_AUTH false

@interface MMAppDelegate () <CFAAuthWindowControllerDelegate>
@property MMDataStackManager *dataStackManager;
@property MMNetworkStackManager *networkStackManager;
@property MMWindowsManager *windowsManager;
@property CFAAuthWindowController *authWindowController;
@property IFBKAuthController *authController;
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation MMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self _setupDebugEnvironment];
    _dataStackManager = [MMDataStackManager new];
    _networkStackManager = [MMNetworkStackManager new];
    _windowsManager = [MMWindowsManager new];

    [self.dataStackManager setUp];
    [self.networkStackManager setUp];
    [self setAuthController:[self _makeAuthController]];
    [self _authorizeAndPresentAccountsWindow];

}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return NO;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self.windowsManager showMainWindowCreatingOneIfNeeded];
    return YES;
}

//------------------------------------------------------------------------------
#pragma mark - Authorization
//------------------------------------------------------------------------------

- (void)_authorizeAndPresentAccountsWindow {
    IFBKAuthController* authController = self.authController;
    [authController authorizeWithSuccess:^(IFBKLPAuthorizationData *authData) {
        CFAAuthorizationCredentialsVault *authVault = [CFAAuthorizationCredentialsVault sharedInstance];
        [authVault storeAccessToken:authController.accessToken refresToken:authController.refreshToken expirationDate:authController.expirationDate];
        [self _authorizationDidComplete:authData];
    } failure:^(NSError *error) {
        [self _handleError:error];
    }];
}

- (void)_presentAuthSheet {
    self.authWindowController = [[CFAAuthWindowController alloc] initWithWindowNibName:@"CFAAuthWindowController"];
    [self.authWindowController setDelegate:self];
    [self.authWindowController setRequestURL:[IFBKLaunchpadClient launchpadURL]];
    [self.authWindowController showWindow:self];
}

- (IFBKAuthController*)_makeAuthController {
    CFAAuthorizationCredentialsVault *authVault = [CFAAuthorizationCredentialsVault sharedInstance];
    IFBKAuthController *authController = [IFBKAuthController newWithClientID:authVault.clientID clientSecret:authVault.clientSecret redirectURI:authVault.redirectUri];
    [authController setAccessToken:authVault.accessToken];
    [authController setRefreshToken:authVault.refreshToken];
    [authController setExpirationDate:authVault.expirationDate];
    return authController;
}

- (void)_handleError:(NSError*)error {
    NSLog(@"ERROR: %@", error);
    NSLog(@"UNDERLYING_ERROR: %@", error.userInfo[NSUnderlyingErrorKey]);
    
    if ([error isIFBKCampgroundError]) {
        if ([error shouldRecoverByReauthorizing]) {
            [self _presentAuthSheet];
        } else {
            [[NSAlert alertWithError:error] runModal];
//            NSMutableDictionary *userInfo = [NSMutableDictionary new];
//            userInfo[NSLocalizedDescriptionKey] = @"Unable to connect to the server.";
//            userInfo[NSLocalizedRecoverySuggestionErrorKey] = @"Check your internet connection.";
//            userInfo[NSUnderlyingErrorKey] = error;
//            NSError *userError = [NSError errorWithDomain:@"ConfabAppErrorDomain" code:0 userInfo:userInfo];
//            [[NSAlert alertWithError:userError] runModal];
        }
    } else {
        [[NSAlert alertWithError:error] runModal];
    }
}

#pragma mark CFAAuthWindowControllerDelegate

- (void)authWindowController:(CFAAuthWindowController *)vc didAuthorizeWithTemporaryCode:(NSString *)temporaryCode {
    [self.authWindowController.window close];
    [self setAuthWindowController:nil];
    IFBKAuthController* authController = self.authController;
    [authController authorizeWithTemporaryCode:temporaryCode success:^(IFBKLPAuthorizationData *authData) {
        CFAAuthorizationCredentialsVault *authVault = [CFAAuthorizationCredentialsVault sharedInstance];
        [authVault storeAccessToken:authController.accessToken refresToken:authController.refreshToken expirationDate:authController.expirationDate];
        [self _authorizationDidComplete:authData];
    } failure:^(NSError *error) {
        [self _handleError:error];
    }];
}

//------------------------------------------------------------------------------
#pragma mark - IBActions
//------------------------------------------------------------------------------

- (IBAction)newWindow:(id)sender {
    [self.windowsManager showNewMainWindow];
}

- (IBAction)openPreferences:(id)sender {
    [self.windowsManager showPreferencesWindow];
}

- (IBAction)reloadData:(id)sender {
    id controller = [self.windowsManager currentWindowController];
    if ([controller respondsToSelector:@selector(reloadData:)]) {
        [controller reloadData:sender];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Menu Validation
//------------------------------------------------------------------------------

- (BOOL)validateMenuItem:(NSMenuItem*)theMenuItem {
    BOOL enable = [self respondsToSelector:[theMenuItem action]];
	if ([theMenuItem action] == @selector(newDocument:)) {
        enable = NO;
	}
	return enable;
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (void)_setupDebugEnvironment {

#if DEBUG
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"WebKitDeveloperExtras": @YES }];
#if DEBUG_AUTH
    NSLog(@"[!] Testing OAuth");
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[CFAAuthorizationCredentialsVault sharedInstance] clearAuthData];
#endif
#endif
}

- (void)_authorizationDidComplete:(IFBKLPAuthorizationData *)authData {
    CFAAuthorizationCredentialsVault *authVault = [CFAAuthorizationCredentialsVault sharedInstance];
    [authVault setAuthData:authData];
    [self.windowsManager showNewMainWindow];
}

@end
