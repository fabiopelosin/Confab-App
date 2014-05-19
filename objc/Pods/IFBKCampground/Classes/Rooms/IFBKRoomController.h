#import <Foundation/Foundation.h>
#import <IFBKThirtySeven/IFBKThirtySeven.h>
#import "IFBKRoomControllerDelegate.h"
#import "IFBKRoomUsersTracker.h"

/**
 * TODO: This class is a kitchen sink.
 * TODO: Retain cycles in blocks.
 * TODO: Support polling as streaming requires the authorization token.
 */
@interface IFBKRoomController : NSObject

///-----------------------------------------------------------------------------
/// @name Initialization
///-----------------------------------------------------------------------------

/**
 * The designated initializer.
 */
- (id)initWithRoomID:(NSNumber *)roomID authorizationToken:(NSString*)authorizationToken;

/**
 * The ID of the room that this controller will manager.
 */
@property (nonatomic, copy, readonly) NSNumber* roomID;

/**
 * Must be set before joining the room.
 * Allows to perform other actions like changing the topic of the room.
 */
@property (nonatomic, strong) IFBKCampfireClient *apiClient;

/**
 * The Authorization toke for the room, found in the My Info section of the
 * campfire web interface. Requred for the streaming support.
 */
@property (nonatomic, copy, readonly) NSString *authorizationToken;

/**
 * The delegate that this class will inform.
 */
@property id<IFBKRoomControllerDelegate> delegate;

///-----------------------------------------------------------------------------
/// Actions
///-----------------------------------------------------------------------------

- (void)joinRoom;

- (void)leaveRoom;

- (void)postMessage:(NSString*)body;

- (void)refreh;

//- (void)loadMessagesUpToLastUserPost:(NSUInteger)limit;

///-----------------------------------------------------------------------------
/// Room
///-----------------------------------------------------------------------------

/**
 * The room managed by this controller.
 */
@property (nonatomic, strong, readonly) IFBKCFRoom *room;

/**
 * The user which is logged in the room.
 */
@property (nonatomic, strong, readonly) IFBKCFUser *user;

///-----------------------------------------------------------------------------
/// @name Messages
///-----------------------------------------------------------------------------

/**
 * The messages currently loaded.
 */
@property (strong, readonly) NSMutableArray* messages;

/**
 * Wether the given message includes a mention to the current user.
 */
- (BOOL)doesMessageIncludeMention:(IFBKCFMessage*)message;

///-----------------------------------------------------------------------------
/// @name Notifications
///-----------------------------------------------------------------------------

/**
 * Wether the delegate should be informed to present a notification only if the message includes a mention to the logged in user.
 */
@property BOOL notifyOnlyForMentions;

///-----------------------------------------------------------------------------
/// Helper Classes
///-----------------------------------------------------------------------------

@property IFBKRoomUsersTracker *userTracker;

///-----------------------------------------------------------------------------
/// Unread messages // TODO: Factor out in IFBKRoomMessagesTracker!
///-----------------------------------------------------------------------------

@property BOOL trackUnreadMessages;

@property (assign, readonly) NSUInteger unreadMessagesCount;

@property (copy, readonly) NSNumber* lastReadMessageID;

@property (copy, readonly) NSDate* lastReadMessageDate;

- (void)clearUnreadMessages;

- (BOOL)isMessageUnread:(NSString*)messageID;




@end
