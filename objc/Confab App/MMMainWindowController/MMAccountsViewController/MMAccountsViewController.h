//
//  MMAccountsViewController.h
//  Confab App
//
//  Created by Fabio Pelosin on 26/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IFBKCampground/IFBKCampground.h>

@protocol MMAccountsViewControllerDelegate;

@interface MMAccountsViewController : NSViewController

@property (weak) id<MMAccountsViewControllerDelegate>delegate;

@property (weak) IBOutlet NSTableView *tableView;

@property (strong, nonatomic) IFBKAccountsController *accountsController;

@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@protocol MMAccountsViewControllerDelegate <NSObject>

@required

- (void)accountsViewController:(MMAccountsViewController*)vc didSelectRoom:(IFBKCFRoom*)room;

@end
