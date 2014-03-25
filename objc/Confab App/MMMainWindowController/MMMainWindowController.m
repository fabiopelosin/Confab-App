//
//  MMMainWindowController.m
//  Confab App
//
//  Created by Fabio Pelosin on 29/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMMainWindowController.h"
#import "MMAccountsViewController.h"
#import "MMRoomViewController.h"
#import "MMRoomInfoViewController.h"

#import <IFBKThirtySeven/IFBKThirtySeven.h>
#import <IFBKCampground/IFBKCampground.h>
#import <IRFNavigationKit/IRFNavigationKit.h>

#import "CFAAuthorizationCredentialsVault.h"

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@interface MMMainWindowController () <MMAccountsViewControllerDelegate>
@property (weak) IBOutlet NSView *navigationBarPlaceHolder;
@property IRFNavigationController *navigationController;
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation MMMainWindowController

- (id)init {
    self = [super initWithWindowNibName:@"MMMainWindowController"];
    if (self) {
        return self;
    }
    return nil;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setDelegate:self];
    NSButton *closeButton = [self.window standardWindowButton:NSWindowCloseButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(closeButtonAction:)];

    MMAccountsViewController *vc = [self _accountsViewController];
    self.navigationController = [[IRFNavigationController alloc] initWithFrame:self.viewContainer.bounds rootViewController:vc];
    [self.viewContainer addSubview: _navigationController.view];

    IRFNavigationBar *navigationBar = [[IRFNavigationBar alloc] initWithFrame:self.navigationBarPlaceHolder.bounds];
    [navigationBar setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [self.navigationBarPlaceHolder addSubview:navigationBar];
    [self.navigationController setNavigationBar:navigationBar];
}

- (NSNumber*)currentRoomID {
    if ([self._currentViewController isKindOfClass:[MMRoomViewController class]]) {
        return [(MMRoomViewController*)self._currentViewController roomID];
    } else {
        return nil;
    }
}

//------------------------------------------------------------------------------
#pragma mark - UI Events
//------------------------------------------------------------------------------

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)infoButtonAction:(id)sender {
    if ([self _isShowingRoom]) {
        [self _pushInfoViewController];
    }
}

- (void)closeButtonAction:(id)sender; {
    // TODO Notify the app delegate
    // Leave the room
    [self.window close];
}

- (void)windowDidResize:(NSNotification *)notification {
    if ([self._currentViewController isKindOfClass:[MMRoomViewController class]]) {
        [(MMRoomViewController*)self._currentViewController windowDidResize];
    }
}

//------------------------------------------------------------------------------
#pragma mark - ViewControllers
//------------------------------------------------------------------------------

- (MMAccountsViewController*)_accountsViewController {
    CFAAuthorizationCredentialsVault *authVault = [CFAAuthorizationCredentialsVault sharedInstance];
    IFBKAccountsController* accountsController = [IFBKAccountsController newWithAccounts:authVault.authData.accounts accessToken:authVault.accessToken];
    MMAccountsViewController *vc = [[MMAccountsViewController alloc] initWithNibName:@"MMAccountsViewController" bundle:nil];
    [vc setAccountsController:accountsController];
    [vc setDelegate:self];
    return vc;
}

- (void)_pushRoomViewControllerWithClient:(IFBKCampfireClient*)client roomID:(NSNumber*)roomID {
    MMRoomViewController *vc = [[MMRoomViewController alloc] initWithNibName:@"MMRoomViewController" bundle:nil];
    [vc setApiClient:client];
    [vc setRoomID:roomID];
    [vc setNavigationController:self.navigationController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_pushInfoViewController {
    MMRoomViewController *roomVC = [self _currentViewController];
    MMRoomInfoViewController *vc = [[MMRoomInfoViewController alloc] initWithNibName:@"MMRoomInfoViewController" bundle:nil];
    [vc setApiClient:roomVC.apiClient];
    [vc setRoomID:roomVC.roomID];
    [vc viewWillAppear];
    [self.navigationController pushViewController:vc animated:YES];
}

//------------------------------------------------------------------------------
#pragma mark - MMAccountsViewControllerDelegate
//------------------------------------------------------------------------------

- (void)accountsViewController:(MMAccountsViewController*)vc didSelectRoom:(IFBKCFRoom *)room {
    IFBKCFAccount *account = [vc.accountsController campfireAccountForRoom:room];
    IFBKCampfireClient *client = [vc.accountsController clientForCampfireAccount:account];
    [self _pushRoomViewControllerWithClient:client roomID:room.identifier];
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (id)_currentViewController {
    return [self.navigationController topViewController];
}

- (BOOL)_isShowingRoom {
    return [self._currentViewController isKindOfClass:[MMRoomViewController class]];
}

@end
