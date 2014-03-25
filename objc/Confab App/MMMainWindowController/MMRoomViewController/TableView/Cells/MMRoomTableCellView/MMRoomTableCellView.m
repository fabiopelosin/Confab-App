//
//  MMRoomTableCellView.m
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMRoomTableCellView.h"
#import "ConfabAppTypography.h"

//------------------------------------------------------------------------------
@interface MMRoomTableCellView ()
//------------------------------------------------------------------------------
@property (unsafe_unretained) IBOutlet NSTextField *dateTextField;
@property (unsafe_unretained) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSView *contentViewContainer;
@end

//------------------------------------------------------------------------------
@implementation MMRoomTableCellView
//------------------------------------------------------------------------------

- (void)awakeFromNib {
  [self.progressIndicator stopAnimation:nil];
}

- (BOOL)isOpaque;
{
  return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
  if (self.highlighted) {
    [[NSColor colorWithCalibratedHue:0.3 saturation:1 brightness:0.9 alpha:1.0] setFill];
  } else {
    [[NSColor whiteColor] setFill];
//    [[NSColor yellowColor] setFill];
  }
  NSRectFill(dirtyRect);
  [super drawRect:dirtyRect];
}

- (void)prepareForReuse
{
  self.unread = FALSE;
  self.highlighted = FALSE;
  self.pending = FALSE;
}

- (void)setContentView:(MMContentView *)contentView
{
  if (contentView) {
    [[self.contentViewContainer subviews] enumerateObjectsUsingBlock:^(NSView *subview, NSUInteger idx, BOOL *stop) {
      [subview removeFromSuperview];
    }];

    [contentView setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [contentView setFrame:self.contentViewContainer.bounds];

    [self.contentViewContainer addSubview:contentView];
  }
  _contentView = contentView;
}

//------------------------------------------------------------------------------
#pragma mark - Properties
//------------------------------------------------------------------------------

- (void)setDate:(NSDate *)date
{
  _date = date;
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterNoStyle];
  [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  [dateFormatter setLocale:[NSLocale currentLocale]];
  NSString *stringValue = [dateFormatter stringFromDate:date];
  [self.dateTextField setStringValue:stringValue];
}

- (void)setUnread:(BOOL)unread
{
  _unread = unread;
  if (unread) {
    [self.dateTextField setTextColor:[NSColor colorWithCalibratedRed:0.264 green:0.399 blue:0.550 alpha:1.000]];
  } else
  {
    [self.dateTextField setTextColor:[ConfabAppTypography lightTextColor]];
  }
}

- (void)setHighlighted:(BOOL)highlighted;
{
  _highlighted = highlighted;
  [self setNeedsDisplay:TRUE];
}

- (void)setPending:(BOOL)pending;
{
  _pending = pending;
  if (pending) {
    [self.progressIndicator startAnimation:nil];
  }
  else {
    [self.progressIndicator stopAnimation:nil];

  }
}

//------------------------------------------------------------------------------
#pragma mark - Exposed Interface
//------------------------------------------------------------------------------

- (CGFloat)preferredHeightWithWitdth:(CGFloat)width;
{
  CGFloat contentViewWidth = width - 100 - 20;
  [self.contentView setPreferredMaxLayoutWidth:contentViewWidth];
  CGSize contentIntrinsicSize = [self.contentView intrinsicContentSize];
  CGFloat height = contentIntrinsicSize.height + 10 + 20;
//  NSLog(@"Height %1.2f", height);
  return height;
}

@end
