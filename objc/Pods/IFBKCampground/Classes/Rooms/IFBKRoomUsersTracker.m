#import "IFBKRoomUsersTracker.h"

//------------------------------------------------------------------------------

@interface IFBKRoomUsersTracker ()
@property NSMutableArray *onlineUsersMutableDictionary;
@property NSMutableArray *recentUsersMutableDictionary;
@end

//------------------------------------------------------------------------------

@implementation IFBKRoomUsersTracker

- (instancetype) init {
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithRoomID:(NSNumber *)roomID;
{
    self = [super init];
    if (self) {
        _roomID = roomID;
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Storing users information
//------------------------------------------------------------------------------

- (void)seedWithUsers:(NSArray *)users {
    self.onlineUsersMutableDictionary = [users mutableCopy];
    self.recentUsersMutableDictionary = [users mutableCopy];
}

- (void)roomDidReceiveMessage:(IFBKCFMessage*)message {
    [self _addIfNeededUserIdentifier:message.userIdentifier toMutableArray:self.recentUsersMutableDictionary];

    switch (message.messageType) {
        case IFBKMessageTypeEnter: {
            [self _addIfNeededUserIdentifier:message.userIdentifier toMutableArray:self.onlineUsersMutableDictionary];
            break;
        }
        case IFBKMessageTypeLeave:
        case IFBKMessageTypeKick: {
            [self.onlineUsersMutableDictionary removeObject:message.userIdentifier];
            break;
        }
        default:
            break;
    }
}

- (void)seedWithRecentMessages:(NSArray *)messages {
    [messages enumerateObjectsUsingBlock:^(IFBKCFMessage* message, NSUInteger idx, BOOL *stop) {
        [self _addIfNeededUserIdentifier:message.userIdentifier toMutableArray:self.recentUsersMutableDictionary];
    }];
}

//------------------------------------------------------------------------------
#pragma mark - Querying the tracker
//------------------------------------------------------------------------------

-(NSArray *)onlineUsers {
    return [self.onlineUsersMutableDictionary copy];
}

- (NSArray *)recentUsers {
    return [self.recentUsersMutableDictionary copy];
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (void)_addIfNeededUserIdentifier:(NSNumber*)userIdentifier toMutableArray:(NSMutableArray*)mutableArray {
    if (userIdentifier && ![userIdentifier isEqualTo:[NSNull null]] && [mutableArray indexOfObject:userIdentifier] == NSNotFound) {
        [mutableArray addObject:userIdentifier];
    }
}

@end
