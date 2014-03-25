//
//  MMChatTextView.h
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MMChatTextViewDelegate;

/**
 * Text view which provides support for the following features:
 *
 * - The execution of an action block called only when the enter key is pressed
 *   without a modefier key (alt or shift).
 */
@interface MMChatTextView : NSTextView

@property (nonatomic, weak) id<MMChatTextViewDelegate> dragAndDropDelegate;

@property (nonatomic, copy) void(^actionBlock)(void);

@end


/**
 *
 */
@protocol MMChatTextViewDelegate <NSObject>

- (void)chatTextView:(MMChatTextView*)chatTextView didReceiveDragForFileWithName:(NSString*)fileName data:(NSData*)fileData;

@end
