//
//  MMAccountsViewController.m
//  Confab App
//
//  Created by Fabio Pelosin on 26/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMAccountsViewController.h"
#import "MMAccountsTableViewManager.h"
#import "IRFNavigationKit.h"

//------------------------------------------------------------------------------

@interface MMAccountsViewController () <MMAccountsTableViewManagerDeletage, IRFNavigationKit, IFBKAccountsControllerDeletage>
@property MMAccountsTableViewManager* tableManager;
@end

//------------------------------------------------------------------------------
@implementation MMAccountsViewController
//------------------------------------------------------------------------------

- (NSString *)title {
    return @"Accounts";
}

- (void)setAccountsController:(IFBKAccountsController *)accountsController {
    [_accountsController setDelegate:nil];
    _accountsController = accountsController;
    [_accountsController setDelegate:self];
}

//------------------------------------------------------------------------------
#pragma mark - View lifecycle
//------------------------------------------------------------------------------

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectAll:self];
}

- (void)loadView {
    [super loadView];
    [self setTableManager:[MMAccountsTableViewManager new]];
    [self.tableManager setDelegate:self];
    [self.tableView setBackgroundColor:[NSColor colorWithCalibratedWhite:0.946 alpha:1.000]];
    [self.tableView setDelegate: self.tableManager];
    [self.tableView setDataSource: self.tableManager];
    [self.accountsController fetchInformation];
}

//------------------------------------------------------------------------------
#pragma mark - IFBKAccountsControllerDeletage
//------------------------------------------------------------------------------

- (void)accountsControllerWillStartFetch:(IFBKAccountsController*)controller {
    // TODO: show loading view
}

- (void)accountsControllerDidCompleteFetch:(IFBKAccountsController*)controller {
    // TODO: hide loading view
    for (IFBKCFAccount *account in [controller campfireAccounts]) {
        NSArray *rooms = [controller roomsForcampfireAccount:account];
        [self.tableManager addAccount:account withRooms:rooms];
    }
    [self.tableView reloadData];
}

- (void)accountsController:(IFBKAccountsController*)controller didEncouterFetchError:(NSError*)error {
    [[NSAlert alertWithError:error] runModal];
}

//------------------------------------------------------------------------------
#pragma mark - MMAccountsTableViewManagerDeletage
//------------------------------------------------------------------------------

- (void)tableView:(NSTableView*)tableView didClickRoom:(IFBKCFRoom*)room {
    [self.delegate accountsViewController:self didSelectRoom:room];
}

@end
