//
//  MMChatTextView.m
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMChatTextView.h"

#define kEnterKeyCode 36

@implementation MMChatTextView

//------------------------------------------------------------------------------
#pragma mark - Initialization
//------------------------------------------------------------------------------

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _setUp];
    }
    return self;
}

- (void)_setUp {
    [self registerForDraggedTypes:[NSArray arrayWithObjects: NSTIFFPboardType, nil]];
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
    if ([[pboard types] containsObject:NSTIFFPboardType] ) {
        NSData *data   = [pboard dataForType:NSTIFFPboardType];
        NSURL *url = [NSURL URLFromPasteboard:pboard];
        NSString *fileName = [url lastPathComponent];
        [self _didPerformDragOperationWithFileNamed:fileName data:data];
        return YES;
    } else if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *fileNames = [pboard propertyListForType:NSFilenamesPboardType];
        for (NSString *path in fileNames) {
            NSString *fileName = [path lastPathComponent];
            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
            [self _didPerformDragOperationWithFileNamed:fileName data:data];
        }
        return YES;
    }
    return NO;
}

- (void)_didPerformDragOperationWithFileNamed:(NSString*)fileName data:(NSData*)data {
    [self.dragAndDropDelegate chatTextView:self didReceiveDragForFileWithName:fileName data:data];
}


//------------------------------------------------------------------------------
#pragma mark - Events
//------------------------------------------------------------------------------

- (void)keyDown:(NSEvent *)theEvent
{
    switch ([theEvent keyCode]) {
        case kEnterKeyCode: {
            NSUInteger modifiers = [theEvent modifierFlags];
            if ((modifiers & NSShiftKeyMask) || (modifiers & NSAlternateKeyMask)) {
                [super insertNewline:self];
            } else {
                self.actionBlock();
            }
            break;
        }
        default: {
            [super keyDown:theEvent];
        }
    }
}

- (void)awakeFromNib {
    [super setTextContainerInset:NSMakeSize(20.0f, 20.0f)];
}

// For auto growing see
// http://stackoverflow.com/questions/14107385/getting-a-nstextfield-to-grow-with-the-text-in-auto-layout

//- (NSPoint)textContainerOrigin {
//  NSPoint origin = [super textContainerOrigin];
//  NSPoint newOrigin = NSMakePoint(origin.x + 5.0f, origin.y);
//  return newOrigin;
//}

@end
