//
//  MMRoomTableCellView.h
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MMContentView.h"

@interface MMRoomTableCellView : NSTableCellView

@property (nonatomic) MMContentView *contentView;
@property (nonatomic) NSDate *date;
@property (nonatomic) BOOL unread;
@property (nonatomic) BOOL highlighted;
@property (nonatomic) BOOL pending;

- (CGFloat)preferredHeightWithWitdth:(CGFloat)width;

@end
