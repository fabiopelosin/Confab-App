//
//  MMRoomViewControllerDataSource.h
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFBKCFMessage;
@class MMUser;
@class IFBKRoomMessagesTracker;
@protocol MMRoomTableManagerDelegate;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@interface MMRoomTableManager : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) id<MMRoomTableManagerDelegate> delegate;
@property (nonatomic) NSTableView *tableView;
@property IFBKRoomMessagesTracker *roomMessagesTracker;

- (void)clearMessagesList;
- (void)appendMessage:(IFBKCFMessage*)message;
- (void)getTwitterImageForMessageIfNeeded:(IFBKCFMessage*)message;
- (void)getUploadInformationForMessage:(IFBKCFMessage*)message;

@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@protocol MMRoomTableManagerDelegate <NSObject>

- (void)tableManager:(MMRoomTableManager*)manager didClickRowForUser:(MMUser*)user;
- (void)tableManager:(MMRoomTableManager*)manager didClickMessage:(IFBKCFMessage*)message;

@end


