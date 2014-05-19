#import "IFBKRoomMessagesTracker.h"
#import "IFBKCFMessage+Campground.h"
#import <AFNetworking/AFNetworking.h>
#import <IFBKThirtySeven/IFBKThirtySeven.h>

@interface IFBKRoomMessagesTracker ()

@property NSMutableArray *cells;
@property NSMutableDictionary *temporaryMessages;
@property NSUInteger temporaryIDCount;

@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation IFBKRoomMessagesTracker

- (id)init {
    self = [super init];
    if (self) {
        _cells = [NSMutableArray new];
        _temporaryMessages = [NSMutableDictionary new];
    }
    return self;
}

- (void)clearMessagesList {
    self.cells = [NSMutableArray new];
}

- (void)appendMessage:(IFBKCFMessage*)message {
    // Disable time stamps.
    if (message.messageType == IFBKMessageTypeTimestamp) {
        return;
    }

    MMRoomTableViewCellListItem *lastItem = self.cells.lastObject;
    NSNumber *lastUserID = lastItem.userID;

    BOOL shouldInsertUserCell = FALSE;

    if ([message isUserGenerated]) {
        BOOL usersMatch = ![lastUserID isEqual:[NSNull null]] && [lastUserID isEqualToNumber:message.userIdentifier];
        if (usersMatch) {
            if ([lastItem.type isEqualToString:@"Message"]) {
                IFBKCFMessage *previousMessage = lastItem.reppresentedValue;
                if (![previousMessage isUserGenerated]) {
                    shouldInsertUserCell = true;
                }

            }
        } else {
            shouldInsertUserCell = true;
        }
    }

    // Insert User cell.
    if (shouldInsertUserCell) {
        MMRoomTableViewCellListItem *userItem  = [MMRoomTableViewCellListItem new];
        userItem.reppresentedValue = message.userIdentifier;
        userItem.userID = message.userIdentifier;
        userItem.type = @"User";
        [self.cells addObject:userItem];
    }

    // Insert Message cell.
    MMRoomTableViewCellListItem *messageItem = [MMRoomTableViewCellListItem new];
    messageItem.reppresentedValue = message;
    messageItem.message = message;
    messageItem.userID = message.userIdentifier;
    messageItem.type = @"Message";
    [self.cells addObject:messageItem];
}

- (NSUInteger)addMessagePreview:(IFBKCFMessage*)message; {
    NSUInteger temporaryID = self.temporaryIDCount++;
    NSString *boxedID = [[NSNumber numberWithUnsignedInteger:temporaryID] stringValue];
    self.temporaryMessages[boxedID] = message;
    [self appendMessage:message];
    return temporaryID;
}

- (void)confirmMessagePreview:(NSUInteger)temporaryID message:(IFBKCFMessage*)confirmedMessage {
    NSNumber *boxedID = [NSNumber numberWithUnsignedInteger:temporaryID];
    IFBKCFMessage *temporaryMessage = self.temporaryMessages[boxedID];
    NSUInteger index = [self.cells indexOfObject:temporaryMessage];
    [self.cells replaceObjectAtIndex:index withObject:confirmedMessage];
}

- (void)addInformation:(NSDictionary*)info forMessage:(IFBKCFMessage*)message {
    NSUInteger index = [self.cells indexOfObjectPassingTest:^BOOL(MMRoomTableViewCellListItem *item, NSUInteger idx, BOOL *stop) {
        return [item.message.identifier isEqualToNumber:message.identifier];
    }];

    MMRoomTableViewCellListItem *infoItem = [MMRoomTableViewCellListItem new];
    infoItem.reppresentedValue = info;
    infoItem.message = message;
    infoItem.userID = message.userIdentifier;
    infoItem.type = @"Info";

    [self.cells insertObject:infoItem atIndex:index+1];
    [self.delegate cellList:self didInsertRowAtIndex:index+1];
}

@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation MMRoomTableViewCellListItem

@end


