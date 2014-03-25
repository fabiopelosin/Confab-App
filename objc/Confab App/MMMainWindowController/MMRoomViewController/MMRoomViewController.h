//
//  MMRoomViewController.h
//  Confab App
//
//  Created by Fabio Pelosin on 29/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Cocoa/Cocoa.h>
#import "MMChatTextView.h"
#import <IFBKThirtySeven/IFBKThirtySeven.h>
#import <IRFNavigationKit/IRFNavigationKit.h>

@interface MMRoomViewController : NSViewController

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (assign) IBOutlet MMChatTextView *textView;
@property IRFNavigationController *navigationController;

@property NSNumber *roomID;
@property IFBKCampfireClient *apiClient;

- (IBAction)reloadData:(id)sender;
- (void)windowDidResize;

@end
