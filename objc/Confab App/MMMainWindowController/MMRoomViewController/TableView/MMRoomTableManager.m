//
//  MMRoomViewControllerDataSource.m
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMRoomTableManager.h"
#import "MMUser.h"
#import "MMUserImageProvider.h"
#import "MMRoomCellProvider.h"
#import "MMTableCellHeighManager.h"
#import "MMUserImageCache.h"

#import "MMInfoTableCellView.h"
#import "MMUserTableCellView.h"

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <IFBKCampground/IFBKCampground.h>

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@interface MMRoomTableManager () <IFBKRoomMessagesTrackerDelegate>

@property NSMutableDictionary *sampleCells;
@property NSDateFormatter *dateFormatter;
@property NSCache *imagesByURL;
@property MMRoomCellProvider *cellProvider;
@property MMTableCellHeighManager *cellHeightProvider;
@property MMUserImageCache *userImageProvider;
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation MMRoomTableManager

- (id)init {
    self = [super init];
    if (self) {
        _sampleCells = [NSMutableDictionary new];
        _roomMessagesTracker = [IFBKRoomMessagesTracker new];
        [_roomMessagesTracker setDelegate:self];
        [_roomMessagesTracker setDisableUserEvents:TRUE];

        _cellProvider = [MMRoomCellProvider new];
        _cellHeightProvider = [MMTableCellHeighManager new];
        _userImageProvider = [MMUserImageCache new];

        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.dateFormatter = dateFormatter;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData) name:kMMUserImageProviderImageUpdateNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadTableViewData {
    [self.tableView reloadData];
}

- (void)setTableView:(NSTableView *)tableView {
    _tableView = tableView;
    NSNib *userCellNib = [[NSNib alloc] initWithNibNamed:@"MMUserTableCellView" bundle:nil];
    [_tableView registerNib:userCellNib forIdentifier:@"MMUserTableCellView"];
    NSNib *infoCellNib = [[NSNib alloc] initWithNibNamed:@"MMInfoTableCellView" bundle:nil];
    [_tableView registerNib:infoCellNib forIdentifier:@"MMInfoTableCellView"];
}

//------------------------------------------------------------------------------
#pragma mark - CellListDelegate
//------------------------------------------------------------------------------

- (void)cellList:(IFBKRoomMessagesTracker*)cellList didInsertRowAtIndex:(NSUInteger)index; {
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationSlideDown];
}

//------------------------------------------------------------------------------
#pragma mark - NSTableViewDataSource & NSTableViewDelegate
//------------------------------------------------------------------------------

/*
 * Returns the count  of the cells based on the cellList.
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.roomMessagesTracker.cells count];
}

/*
 * Returns the cell based on the cellListItem.
 */
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cell;
    MMRoomTableViewCellListItem* item = [self.roomMessagesTracker.cells objectAtIndex:row];

    if ([item.type isEqualToString:@"User"]) {
        MMUser *user = [self _userWithID:item.userID];
        cell = [self _cellForUser:user];
    } else {
        IFBKCFMessage *message = item.reppresentedValue;
        if ([message isUserGenerated]) {
            cell = [self _cellForMessage:message];
        } else {
            cell = [self _cellForInfo:message];
        }
    }
    return cell;
}


#define kUserTableViewCellHeight 60

/*
 * Returns the height of the cell taking into account if the cell is a user
 * cell or a message cell.
 */
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    CGFloat height = 0;
    MMRoomTableViewCellListItem* item = [self.roomMessagesTracker.cells objectAtIndex:row];

    if ([item.type isEqualToString:@"User"]) {
        height = kUserTableViewCellHeight;
    }
    else {
        IFBKCFMessage *message = item.reppresentedValue;
        if ([message isUserGenerated]) {
            CGFloat width = self.tableView.frame.size.width;
            height = [self.cellHeightProvider cellHeightForMessage:message withWidth:width];
        } else {
            height = 40;
        }
    }
    return height;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = self.tableView.selectedRow;
    if (row == -1) {
        return;
    }
    MMRoomTableViewCellListItem* item = [self.roomMessagesTracker.cells objectAtIndex:row];
    if ([item.type isEqualToString:@"User"]) {
        MMUser *user = [self _userWithID:item.userID];
        [self.delegate tableManager:self didClickRowForUser:user];
    } else if ([item.type isEqualToString:@"Message"]) {
        IFBKCFMessage *message = item.reppresentedValue;
        [self.delegate tableManager:self didClickMessage:message];
    }

    [self.tableView selectRowIndexes:[NSIndexSet indexSet] byExtendingSelection:NO];
}

//------------------------------------------------------------------------------
#pragma mark - Cells
//------------------------------------------------------------------------------

- (NSTableCellView *)_cellForUser:(MMUser*)user {
   MMUserTableCellView *cell = [self.tableView makeViewWithIdentifier:@"MMUserTableCellView" owner:self];
    if (user) {
        cell.authorTextField.stringValue = user.name;
        CGFloat size = MAX(CGRectGetWidth(cell.imageView.frame), CGRectGetHeight(cell.imageView.frame));
        cell.imageView.image = [self.userImageProvider imageForUser:user withSize:size];
    }
    return cell;
}

- (NSTableCellView *)_cellForInfo:(IFBKCFMessage*)message {
    MMUser *user = [self _userWithID:message.userIdentifier];
    NSString *body = [message roomEventDescriptionWithUser:user.name];
    MMInfoTableCellView *cell = [self.tableView makeViewWithIdentifier:@"MMInfoTableCellView" owner:self];
    [cell.authorTextField setStringValue:body];
    return cell;
}

- (NSTableCellView *)_cellForMessage:(IFBKCFMessage*)message {
    NSString *identifier = [self.cellProvider identifierForMessageType:message.messageType];
    NSTableCellView* cell = [self.tableView makeViewWithIdentifier:identifier owner:self];

    if (!cell) {
        cell = [self.cellProvider createTableCellViewForMessage:message];
    }
    [self.cellProvider configureTableCellView:cell ForMessage:message];
    return cell;
}

- (id)_dequeCellWithClass:(Class)class {
  NSString *identifier = NSStringFromClass(class);
  NSTableCellView *cell = [self.tableView makeViewWithIdentifier:identifier owner:self];
  if (!cell) {
    cell = [class new];
    cell.identifier = identifier;
  }
  return cell;
}

//------------------------------------------------------------------------------
#pragma mark - Configuring Post Cells
//------------------------------------------------------------------------------

//- (void)_configureTextMessageCell:(MMTextMessageTableCellView*)cell message:(IFBKCFMessage*)message {
//  NSAttributedString *body = [self _attributedStringForMessageBody:message.body];
//  [cell.messageTextField.textStorage setAttributedString:body];
//  cell.dateTextField.stringValue = [self.dateFormatter stringFromDate:message.createdAt];
//}
//
//- (void)_configurePasteMessageCell:(MMTextMessageTableCellView*)cell message:(IFBKCFMessage*)message {
//  [cell.messageTextField setString:message.body];
//  cell.dateTextField.stringValue = [self.dateFormatter stringFromDate:message.createdAt];
//}
//
//- (void)_configureUploadMessageCell:(MMUploadTableCellView*)cell message:(IFBKCFMessage*)message {
//  NSString *extension = [message.body pathExtension];
//  NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFileType:extension];
//  [cell.messageImageView setImage:icon];
//  [cell.messageTextField setStringValue:message.body];
//  [cell setUnread: TRUE];
//  cell.dateTextField.stringValue = [self.dateFormatter stringFromDate:message.createdAt];
//}
//
//- (void)_configureTweetMessageCell:(MMTweetMessageTableCellView*)cell message:(IFBKCFMessage*)message {
//
//  NSImage *icon = [self.imagesByURL objectForKey:message.tweet.authorAvatarUrl];
//  if (!icon) {
//    icon = [NSImage imageNamed:NSImageNameUser];
//  }
//
//  [cell.messageImageView setImage:icon];
//  NSAttributedString *body = [self _attributedStringForTweet:message.tweet.message];
//  [cell.messageTextField setAttributedStringValue:body];
//  [cell setUnread: TRUE];
//  cell.dateTextField.stringValue = [self.dateFormatter stringFromDate:message.createdAt];
//}
//
//- (void)_configureInformativeCell:(MMInformativeTableCellView*)cell withMessage:(IFBKCFMessage*)message {
//  NSString *informative;
//  switch (message.typeGroup) {
//    case IFBKMessageTypeGroupUserEvent:
//      informative = [self _informativeForUserEventMessage:message];
//      break;
//
//    case IFBKMessageTypeGroupRoomEvent:
//      informative = [self _informativeForRoomEventMessage:message];
//      break;
//
//    case IFBKMessageTypeGroupOther:
//      informative = [self _informativeForOtherEventMessage:message];
//      break;
//
//    default:
//      [NSException raise:@"Attempt to ask informative for message with wrong type group." format:@"message: %@", message];
//      break;
//  }
//  cell.textField.stringValue = informative;
//  cell.dateTextField.stringValue = [self.dateFormatter stringFromDate:message.createdAt];
//}


//------------------------------------------------------------------------------
#pragma mark - MetaData
//------------------------------------------------------------------------------

- (void)getTwitterImageForMessageIfNeeded:(IFBKCFMessage*)message {
//    BOOL isTweet = message.messageType == IFBKMessageTypeTweet;
//    BOOL hasCachedImage = [self.imagesByURL objectForKey:message.tweet.authorAvatarUrl] ? TRUE : FALSE;
//
//    if (isTweet && !hasCachedImage) {
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:message.tweet.authorAvatarUrl]];
//        AFImageRequestOperation *image_operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(NSImage *image) {
//            [self.imagesByURL setObject:image forKey:message.tweet.authorAvatarUrl];
//            //      MMTweetMessageTableCellView *cell = [self cellForMessage:message];
//            //      if (cell) {
//            //        [cell.messageImageView setImage:image];
//            //      }
//        }];
//        [image_operation start];
//    }
}

- (void)getUploadInformationForMessage:(IFBKCFMessage*)message {
    if (message.messageType == IFBKMessageTypeUpload) {
//        [[[MMAccountsController sharedInstance] apiClient] getUploadForRoomWithID:message.roomID uploadMessageID:message.messageID success:^(IFToastingUpload *upload) {
//
//            NSURLRequest *request = [NSURLRequest requestWithURL:upload.fullURL];
//            AFImageRequestOperation *image_operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(NSImage *image) {
//                [self.cellList addInformation:@{@"Image": image} forMessage:message];
//            }];
//            [image_operation start];
//
//        } failure:^(NSError *error) {
//            NSLog(@"%@", error);
//        }];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Helpers
//------------------------------------------------------------------------------

- (void)clearMessagesList {
    [self.roomMessagesTracker clearMessagesList];
}

- (void)appendMessage:(IFBKCFMessage*)message {
    [self.roomMessagesTracker appendMessage:message];
}

- (id)cellForMessage:(IFBKCFMessage*)message {
    NSRect visibleRect = [self.tableView visibleRect];
    NSRange rowsRange = [self.tableView rowsInRect:visibleRect];
    NSIndexSet *rowsIndexSet = [NSIndexSet indexSetWithIndexesInRange:rowsRange];

    NSIndexSet *itemsIndexSet = [self.roomMessagesTracker.cells indexesOfObjectsAtIndexes:rowsIndexSet options:NSEnumerationConcurrent passingTest:^BOOL(MMRoomTableViewCellListItem *item, NSUInteger idx, BOOL *stop) {
        BOOL found = item.message.identifier ==  message.identifier;
        *stop = found;
        return found;
    }];
    
    if (itemsIndexSet.count != 0) {
        id cell = [self.tableView viewAtColumn:0 row:itemsIndexSet.firstIndex makeIfNecessary:NO];
        return cell;
    }
    return nil;
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (MMUser*)_userForMessage:(IFBKCFMessage*)message {
    return [self _userWithID:message.userIdentifier];
}

- (MMUser*)_userWithID:(NSNumber*)userID {
    return [MMUser MR_findFirstByAttribute:@"userID" withValue:[userID stringValue]];
}

@end
