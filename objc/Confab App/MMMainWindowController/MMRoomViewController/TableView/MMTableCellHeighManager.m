//
//  MMTableCellHeighManager.m
//  Confab App
//
//  Created by Fabio Pelosin on 23/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMTableCellHeighManager.h"
#import "MMRoomTableCellView.h"
#import "MMRoomCellProvider.h"

@interface MMTableCellHeighManager ()

@property (nonatomic, assign) CGFloat currentWidth;
@property (nonatomic, strong) NSMutableDictionary *heightByMessagesIDs;
@property (nonatomic, strong) NSMutableDictionary *cellsByIdentifier;
@property (nonatomic, strong) MMRoomCellProvider *cellProvider;

@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation MMTableCellHeighManager

- (id)init {
    self = [super init];
    if (self) {
        _heightByMessagesIDs = [NSMutableDictionary new];
        _cellsByIdentifier = [NSMutableDictionary new];
        _cellProvider = [MMRoomCellProvider new];
    }
    return self;
}

- (CGFloat)cellHeightForMessage:(IFBKCFMessage*)message withWidth:(CGFloat)width {
    [self clearCacheIfWitdhChanged:width];
    CGFloat height = [self.heightByMessagesIDs[message.identifier] doubleValue];

    if (!height) {
        NSString *identifier = [self.cellProvider identifierForMessageType:message.messageType];
        MMRoomTableCellView* cell = self.cellsByIdentifier[identifier];

        if (!cell) {
            cell = (MMRoomTableCellView*)[self.cellProvider createTableCellViewForMessage:message];
            self.cellsByIdentifier[identifier] = cell;
        }

        [self.cellProvider configureTableCellView:cell ForMessage:message];
        height = [cell preferredHeightWithWitdth:width];
        self.heightByMessagesIDs[message.identifier] = @(height);
    }

    return height;
}

- (void)clearCacheIfWitdhChanged:(CGFloat)width {
    if (self.currentWidth != width) {
        self.heightByMessagesIDs = [NSMutableDictionary new];
        [self setCurrentWidth:width];
    }
}

@end
