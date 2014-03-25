//
//  MMTextMessageTableCellView2.m
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMPasteMessageContentView.h"

//------------------------------------------------------------------------------
@interface MMPasteMessageContentView ()
//------------------------------------------------------------------------------
@property (unsafe_unretained) IBOutlet NSTextField *messageTextField;
@end

//------------------------------------------------------------------------------
@implementation MMPasteMessageContentView
//------------------------------------------------------------------------------

- (void)setMessage:(NSAttributedString *)message;
{
  [self.messageTextField setAttributedStringValue:message];
}

- (NSSize)intrinsicContentSize;
{
  [self.messageTextField setPreferredMaxLayoutWidth:self.preferredMaxLayoutWidth - 2 * 2];
  CGSize textFieldSize = [self.messageTextField intrinsicContentSize];
  return CGSizeMake(self.preferredMaxLayoutWidth, textFieldSize.height);
}

@end
