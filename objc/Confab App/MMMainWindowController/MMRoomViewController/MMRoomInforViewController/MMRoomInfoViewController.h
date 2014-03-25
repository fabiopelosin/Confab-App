//
//  MMRoomInfoViewController.h
//  Confab App
//
//  Created by Fabio Pelosin on 02/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IFBKThirtySeven/IFBKThirtySeven.h>

@interface MMRoomInfoViewController : NSViewController
@property NSNumber *roomID;
@property IFBKCampfireClient *apiClient;

- (void)viewWillAppear;
@property (weak) IBOutlet NSTableView *tableView;

@end

