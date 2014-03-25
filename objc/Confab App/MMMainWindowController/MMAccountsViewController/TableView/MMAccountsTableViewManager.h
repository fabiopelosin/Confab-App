//
//  MMAccountsTableView.h
//  Confab App
//
//  Created by Fabio Pelosin on 26/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IFBKCampground/IFBKCampground.h>


@protocol MMAccountsTableViewManagerDeletage;

@interface MMAccountsTableViewManager : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) id<MMAccountsTableViewManagerDeletage>delegate;

- (void)addAccount:(IFBKCFAccount*)account withRooms:(NSArray *)rooms;

@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@protocol MMAccountsTableViewManagerDeletage <NSObject>

@required

- (void)tableView:(NSTableView*)tableView didClickRoom:(IFBKCFRoom*)room;

@end


