#import <Foundation/Foundation.h>

@class IFBKCFMessage;
@protocol IFBKRoomMessagesTrackerDelegate;

//------------------------------------------------------------------------------

@interface IFBKRoomMessagesTracker : NSObject

@property (readonly) NSMutableArray *cells;
@property id<IFBKRoomMessagesTrackerDelegate> delegate;
@property BOOL disableUserEvents;

- (void)clearMessagesList;
- (void)appendMessage:(IFBKCFMessage*)message;
- (NSUInteger)addMessagePreview:(IFBKCFMessage*)message;
- (void)confirmMessagePreview:(NSUInteger)temporaryID message:(IFBKCFMessage*)confirmedMessage;
//- (void)addInformation:(NSDictionary*)info forMessage:(IFBKCFMessage*)message;

@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@protocol IFBKRoomMessagesTrackerDelegate <NSObject>

- (void)cellList:(IFBKRoomMessagesTracker*)cellList didInsertRowAtIndex:(NSUInteger)index;

@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@interface MMRoomTableViewCellListItem : NSObject

@property NSString *type;
@property id reppresentedValue;
@property NSNumber* userID;
@property IFBKCFMessage* message;

@end
