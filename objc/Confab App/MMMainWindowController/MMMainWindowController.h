//
//  MMMainWindowController.h
//  Confab App
//
//  Created by Fabio Pelosin on 29/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Cocoa/Cocoa.h>

@interface MMMainWindowController : NSWindowController <NSWindowDelegate>

- (NSString*)currentRoomID;

- (void)backButtonAction:(id)sender;

@property (weak) IBOutlet NSView *viewContainer;

@end
