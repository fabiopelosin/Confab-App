#import <IFBKCampground/IFBKCampground.h>

//------------------------------------------------------------------------------

@interface IFBKRoomController ()
@property (strong, readwrite) IFBKCFRoom *room;
@property (copy, readwrite) NSString *authorizationToken;
@property (nonatomic, strong, readwrite) IFBKCFUser *user;
@property (strong, readwrite) NSMutableArray* messages;

@property (assign, readwrite) NSUInteger unreadMessagesCount;
@property (copy, readwrite) NSNumber* lastReadMessageID;
@property (copy, readwrite) NSDate* lastReadMessageDate;

@property IFBKCampfireStreamingClient *streamClient;
@end

//------------------------------------------------------------------------------

@implementation IFBKRoomController

- (instancetype)init {
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithRoomID:(NSNumber *)roomID authorizationToken:(NSString*)authorizationToken {
    self = [super init];
    if (self) {
        _roomID = roomID;
        _authorizationToken = authorizationToken;
        _userTracker = [[IFBKRoomUsersTracker alloc] initWithRoomID:roomID];
        _messages = [NSMutableArray new];
        return self;
    }
    return nil;
}

//------------------------------------------------------------------------------
#pragma mark - Actions
//------------------------------------------------------------------------------

- (void)joinRoom {

    [self.apiClient joinRoom:self.roomID success:^{
        [self _startStream];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [self _handleError:error];
    }];

    [self _getRoom];
    [self _getCurrentUser];
    [self _loadRecentMessages];
}

- (void)leaveRoom {
    [self.apiClient leaveRoom:self.roomID success:^{
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [self _handleError:error];
    }];

    [self.streamClient closeConnection];
}


#define IFBKMessageTypeTweetRegEx @" *https://twitter.com/\\w+/status/[0-9]+ *"
#define IFBKMessageTypeSoundRegEx @" */play \\w+ *"

- (void)postMessage:(NSString*)body {
    NSString *type;

    NSPredicate *twitterTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IFBKMessageTypeTweetRegEx];
    NSPredicate *soundTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IFBKMessageTypeSoundRegEx];

    if ([[body componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count] > 1) {
        type = @"PasteMessage";
    }
    else if ([twitterTest evaluateWithObject:body]) {
        type = @"TweetMessage";
    }
    else if ([soundTest evaluateWithObject:body]) {
        type = @"SoundMessage";
    }
    else {
        type = @"TextMessage";
    }

    IFBKCFMessage *message = [IFBKCFMessage messageWithBody:body type:type];
    [self.apiClient postMessage:message toRoom:self.roomID success:^(IFBKCFMessage *confirm_message) {
        [self.delegate roomController:self didConfirmPost:body message:message];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [self _handleError:error];
    }];
}

- (void)refreh {
    [self _loadRecentMessages];
}

//------------------------------------------------------------------------------
#pragma mark - Messages
//------------------------------------------------------------------------------

- (BOOL)doesMessageIncludeMention:(IFBKCFMessage*)message {
    NSString *searchKey = [self.user.name componentsSeparatedByString:@" "].firstObject;
    NSRange range = [message.body rangeOfString:searchKey options:NSCaseInsensitiveSearch];
    return range.location != NSNotFound;
}

- (void)_didReceiveNewMessage:(IFBKCFMessage*)message {
    [self _loadAlternativeViewForMessage:message];
    [self _handleNewMessages:@[message]];
    [self.messages addObject:message];
    [self.userTracker roomDidReceiveMessage:message];
    [self _sendNotificaitonForMessageIfNeeded:message];
    [self.delegate roomController:self didReceiveNewMessage:message];
}

//------------------------------------------------------------------------------
#pragma mark - Notifications
//------------------------------------------------------------------------------

- (void)_sendNotificaitonForMessageIfNeeded:(IFBKCFMessage*)message {
    if ([message.userIdentifier isNotEqualTo:self.user.identifier] && [message isUserGenerated]) {
        if (!self.notifyOnlyForMentions || [self doesMessageIncludeMention:message]) {
            [self.delegate roomController:self didReceiveNotificationFormessage:message];
        }
    }
}

//------------------------------------------------------------------------------
#pragma mark - Unread messages
//------------------------------------------------------------------------------

- (void)clearUnreadMessages {
    [self _handleNewMessages:@[self.messages.lastObject]];
}

- (BOOL)isMessageUnread:(NSNumber*)messageID {
    IFBKCFMessage *message;
    for (IFBKCFMessage *aMessage in self.messages) {
        if ([aMessage.identifier isEqualToNumber:messageID]) {
            message = aMessage;
            break;
        }
    }

    return message.createdAt == [message.createdAt laterDate:self.lastReadMessageDate];
}

//------------------------------------------------------------------------------
#pragma mark - Private Helpers
//------------------------------------------------------------------------------

- (void)_handleNewMessages:(NSArray*)messages {
    if (self.trackUnreadMessages) {
        self.unreadMessagesCount += messages.count;
        [self.delegate roomControllerDidUpdateUnreadMessages:self];
    } else {
        IFBKCFMessage *message = messages.lastObject;
        if (message.createdAt == [message.createdAt laterDate:self.lastReadMessageDate])
        {
            self.lastReadMessageID = message.identifier;
            self.lastReadMessageDate = message.createdAt;
        }
    }
}

- (void)_handleError:(NSError*)error {
    [self.delegate roomController:self didEncouterError:error];
}

- (void)_loadAlternativeViewForMessage:(IFBKCFMessage*)message {
    //  NSView *view = nil;
    //  [self.delegate roomController:self didReceiveAlternativeView:nil message:message];
}

- (void)_addNewMessages:(NSArray*)messages {
    [self.messages addObjectsFromArray:messages];
    // Check if the new messages come after the message stored;
    [self _restoreMessageListIntegrity];
}

/*
 Restores the integrity of the messages ensuring that they are unique and sorted.
 */
- (void)_restoreMessageListIntegrity {
    // Uniq
    // Sort
}


//------------------------------------------------------------------------------
#pragma mark - Private API Helpers
//------------------------------------------------------------------------------

- (void)_startStream {
    __weak IFBKRoomController *weakSelf = self;
    [self setStreamClient:[[IFBKCampfireStreamingClient alloc] initWithRoomId:self.roomID authorizationToken:self.authorizationToken]];

    [self.streamClient openConnection:^(NSHTTPURLResponse *httpResponse) {
        NSLog(@"Streaming connection open");
    } messageReceived:^(IFBKCFMessage *message) {
        [weakSelf _didReceiveNewMessage:message];
    } failure:^(NSError *error) {
        // TODO: attempt reconnect if the connection was open
        [self _handleError:error];
        NSLog(@"Streaming connection open");
    }];
}

- (void)_getRoom {
    [self.apiClient getRoomForId:self.roomID success:^(IFBKCFRoom *room) {
        [self setRoom:room];
        NSArray *userIdentifiers = [room.users valueForKey:@"identifier"];
        [self.userTracker seedWithUsers:userIdentifiers];
        [self.delegate roomControllerDidJoinRoom:self];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [self _handleError:error];
    }];
}

- (void)_getCurrentUser {
    [self.apiClient getCurrentUser:^(IFBKCFUser *user) {
        self.user = user;
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [self _handleError:error];
    }];
}

- (void)_loadRecentMessages {
    [self.apiClient getMessagesForRoom:self.roomID limit:100 sinceMessageId:nil success:^(NSArray *messages) {
        self.messages = [messages mutableCopy];
        [self _handleNewMessages:messages];
        [self.userTracker seedWithRecentMessages:messages];
        [self.delegate roomControllerDidUpdateMessagesList:self];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [self _handleError:error];
    }];
}

@end
