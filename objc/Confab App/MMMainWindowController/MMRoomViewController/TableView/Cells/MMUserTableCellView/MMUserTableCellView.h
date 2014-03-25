//
//  MMUserTableCellView.h
//  Confab App
//
//  Created by Fabio Pelosin on 30/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Cocoa/Cocoa.h>

@interface MMUserTableCellView : NSTableCellView

@property (assign) IBOutlet NSTextField *authorTextField;
@property (assign) IBOutlet NSTextField *dateTextField;
@property (weak) IBOutlet NSImageView *backgroundImageView;

@end
