//
//  CFARoomBackgroundView.m
//  Confab App
//
//  Created by Fabio Pelosin on 09/12/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import "CFARoomBackgroundView.h"

@implementation CFARoomBackgroundView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}


//------------------------------------------------------------------------------
#pragma mark - Drag & Drop
//------------------------------------------------------------------------------

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;

    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];

    if ([pboard.types containsObject:NSTIFFPboardType] || [pboard.types containsObject:NSFilenamesPboardType]) {
        if (sourceDragMask & NSDragOperationGeneric) {
            return NSDragOperationGeneric;
        }
    }
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
    if ( [[pboard types] containsObject:NSTIFFPboardType] ) {
        NSData *zPasteboardData   = [pboard dataForType:NSTIFFPboardType];
        NSImage *image = [[NSImage alloc] initWithData:zPasteboardData];
        [self _didPerformDragOperationWithImage:image];
        return YES;
    } else if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *fileNames = [pboard propertyListForType:NSFilenamesPboardType];
        for (NSString *path in fileNames) {
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
            [self _didPerformDragOperationWithImage:image];
        }
        return YES;
    }
    return YES;
}

- (void)_didPerformDragOperationWithImage:(NSImage*)image {
    if (image) {
        
    }
}

@end
