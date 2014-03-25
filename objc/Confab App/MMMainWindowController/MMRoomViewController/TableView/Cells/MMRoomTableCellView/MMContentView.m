//
//  MMContentView.m
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMContentView.h"

@implementation MMContentView

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth
{
  _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [self invalidateIntrinsicContentSize];
}

- (NSSize)intrinsicContentSize
{
  // subviews + margins
  return CGSizeMake(self.preferredMaxLayoutWidth, NSViewNoInstrinsicMetric);
}

//- (void)drawRect:(NSRect)dirtyRect {
//  [[NSColor cyanColor] setFill];
//  NSRectFill(dirtyRect);
//  [super drawRect:dirtyRect];
//}

@end
