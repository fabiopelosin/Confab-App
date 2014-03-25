//
//  MMAccountsTableView.m
//  Confab App
//
//  Created by Fabio Pelosin on 26/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMAccountsTableViewManager.h"
#import <IFBKThirtySeven/IFBKThirtySeven.h>

@interface MMAccountsTableViewManager ()
@property NSMutableArray *rowItems;
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation MMAccountsTableViewManager

- (id)init {
    self = [super init];
    if (self) {
        _rowItems = [NSMutableArray new];
    }
    return self;
}

- (void)addAccount:(IFBKCFAccount*)account withRooms:(NSArray *)rooms {
    [_rowItems addObject:account];
    [_rowItems addObjectsFromArray:rooms];
}

- (BOOL)_isAccountRow:(NSUInteger)row {
    id rowItem = self.rowItems[row];
    return [rowItem isKindOfClass:[IFBKCFAccount class]];
}

//------------------------------------------------------------------------------
#pragma mark - NSTableViewDataSource
//------------------------------------------------------------------------------

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.rowItems count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    id rowItem = self.rowItems[row];
    NSTableCellView *cell;

    if ([self _isAccountRow:row]) {
        static NSString *identifier = @"AccountCell";
        cell = [tableView makeViewWithIdentifier:identifier owner:nil];
        IFBKCFAccount *account = rowItem;
        [cell.textField setStringValue:account.name];
    } else {
        static NSString *identifier = @"RoomCell";
        cell = [tableView makeViewWithIdentifier:identifier owner:nil];
        IFBKCFRoom *room = rowItem;
        [cell.textField setStringValue:room.name];
        NSTextField *topicTextField = [cell viewWithTag:100];
        assert(topicTextField);

        if (room.topic && room.users.count != 0) {
            NSString *topicString = [NSString stringWithFormat:@"%@ (%ld users)", room.topic, room.users.count];
            [topicTextField setStringValue:topicString];
        } else if (room.topic) {
            [topicTextField setStringValue:room.topic];
        } else if (room.users.count != 0) {
            NSString *topicString = [NSString stringWithFormat:@"%@ (%ld users)", room.topic, room.users.count];
            [topicTextField setStringValue:topicString];
        }
    }
    return cell;
}

//------------------------------------------------------------------------------
#pragma mark - NSTableViewDelegate
//------------------------------------------------------------------------------

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    if ([self _isAccountRow:row]) {
        return 80;
    } else {
        return 40;
    }
}

- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
    NSUInteger row = [proposedSelectionIndexes firstIndex];
    if (row == NSNotFound) {
        return nil;
    } else if ([self _isAccountRow:row]) {
        return nil;
    } else {
        return [NSIndexSet indexSetWithIndex:row];
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *table = [notification object];
    NSInteger row = table.selectedRow;
    if (row != -1) {
        if (![self _isAccountRow:row]) {
            IFBKCFRoom *room = self.rowItems[row];
            [self.delegate tableView:table didClickRoom:room];
        }
    }
}

@end
