//
//  MMRoomCellProvider.m
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMRoomCellProvider.h"
#import "MMTextMessageContentView.h"
#import "MMPasteMessageContentView.h"
#import "MMRoomTableCellView.h"
#import "ConfabAppTypography.h"
#import <IFBKCampground/IFBKCampground.h>

@interface MMRoomCellProvider ()

@property IFBKStringFormatter *stringFormatter;

@end

//------------------------------------------------------------------------------

@implementation MMRoomCellProvider

- (id)init {
    self = [super init];
    if (self) {
        _stringFormatter = [IFBKStringFormatter new];
        [_stringFormatter setDefaultAttributes:[ConfabAppTypography defaultAttributes]];
        [_stringFormatter setAttributesForLink:[ConfabAppTypography attributesForLink]];
    }
    return self;
}

- (NSTableCellView*)createTableCellViewForMessage:(IFBKCFMessage*)message {
    NSArray *topLevelObjects;
    [[NSBundle mainBundle] loadNibNamed:@"MMRoomTableCellView" owner:self topLevelObjects:&topLevelObjects];
    NSArray *cellViews = [topLevelObjects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary * bindings){
        return [evaluatedObject isKindOfClass:[MMRoomTableCellView class]];
    }]];
    MMRoomTableCellView *cellView = cellViews[0];
    cellView.identifier = [self identifierForMessageType:message.messageType];
    MMContentView *contentView = [self _contentViewForMessage:message];
    [cellView setContentView:contentView];
    return cellView;
}

- (void)configureTableCellView:(NSTableCellView*)cellView ForMessage:(IFBKCFMessage*)message {
    MMContentView *contentView = [(MMRoomTableCellView*)cellView contentView];
    [(MMRoomTableCellView*)cellView setDate:message.createdAt];
    switch (message.messageType) {
        case IFBKMessageTypeText: {
            NSAttributedString *attributedMessage = [self.stringFormatter attributedStringForMessageBody:message.body];
            [(MMTextMessageContentView*)contentView setMessage:attributedMessage];
            break;
        }

        case IFBKMessageTypePaste: {
            NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:message.body];
            [(MMPasteMessageContentView*)contentView setMessage:attributedMessage];
            break;
        }

        default: {
            NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:message.body];
            [(MMTextMessageContentView*)contentView setMessage:attributedMessage];
            break;
        }
    }
}

- (NSString*)identifierForMessageType:(IFBKMessageType)type {
    return [self _contentViewClassForMessageType:type];
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (MMContentView*)_contentViewForMessage:(IFBKCFMessage*)message {
    NSString *className = [self _contentViewClassForMessageType:message.messageType];
    if (className) {
        NSArray *topLevelObjects;
        [[NSBundle mainBundle] loadNibNamed:className owner:self topLevelObjects:&topLevelObjects];
        NSArray *contentViews =[topLevelObjects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary * bindings){
            return [[evaluatedObject className] isEqualToString:className];
        }]];
        MMContentView *contentView = contentViews[0];
        return contentView;
    } else {
        [NSException raise:@"Unexpected message type" format:@"Message type"];
        return nil;
    }
}

- (NSString*)_contentViewClassForMessageType:(IFBKMessageType)type {
    NSString *result;
    switch (type) {
        case IFBKMessageTypeText:
            result = @"MMTextMessageContentView";
            break;
        case IFBKMessageTypePaste:
            result = @"MMPasteMessageContentView";
            break;

        case IFBKMessageTypeTweet:
        case IFBKMessageTypeSound:
        case IFBKMessageTypeUpload:
            result = @"MMTextMessageContentView";
            break;
        default:
            [NSException raise:@"Unexpected message type" format:@"Message type"];

    }
    return result;
}

@end
