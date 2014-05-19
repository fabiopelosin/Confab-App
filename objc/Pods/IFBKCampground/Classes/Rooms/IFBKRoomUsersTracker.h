#import <Foundation/Foundation.h>
#import <IFBKThirtySeven/IFBKThirtySeven.h>

/**
 * Keeps track of the users ids present in a room and of the recent users.
 * The list are seeded from the list of the initial users preesnt in a room and
 * from the list of the recent messages.
 */
@interface IFBKRoomUsersTracker : NSObject

/**
 * The designated initializer
 */
- (id)initWithRoomID:(NSNumber *)roomID;

/**
 * The room whose users are being tracked.
 */
@property (copy, readonly) NSNumber *roomID;


///-----------------------------------------------------------------------------
/// Storing users information
///-----------------------------------------------------------------------------

/**
 * The initial list of the online users as returned by the API while joining
 * the room.
 *
 * @param users The list of NSNumbers relative to the identifiers of the users
 *              present in the room.
 */
- (void)seedWithUsers:(NSArray *)users;

/**
 */
- (void)seedWithRecentMessages:(NSArray *)messages;

/**
 * Indicates to the tracker about a new message in the room.
 */
- (void)roomDidReceiveMessage:(IFBKCFMessage*)message;

///-----------------------------------------------------------------------------
/// Querying the tracker
///-----------------------------------------------------------------------------

/**
 * The list of NSNumbers the users which are currently online.
 */
- (NSArray *)onlineUsers;

/**
 * The list of all the users which have been seen on the messages of the room.
 * Regardless that they are online or not.
 */
- (NSArray *)recentUsers;

@end
