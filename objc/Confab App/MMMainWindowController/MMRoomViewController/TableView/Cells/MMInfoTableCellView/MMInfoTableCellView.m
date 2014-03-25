//
//  MMUserTableCellView.m
//  Confab App
//
//  Created by Fabio Pelosin on 30/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMInfoTableCellView.h"

@implementation MMInfoTableCellView

- (void)awakeFromNib {
}

- (void)drawRect:(NSRect)dirtyRect {
  [[NSColor whiteColor] setFill];
  NSRectFill(dirtyRect);
  [super drawRect:dirtyRect];
}

@end
