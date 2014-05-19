//
//  IFBKRoomControllerDelegate.h
//  IFBKCampground
//
//  Created by Fabio Pelosin on 07/12/13.
//  Copyright (c) 2013 IFBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFBKCFMessage;
@class IFBKRoomController;

/**
 *
 */
@protocol IFBKRoomControllerDelegate <NSObject>

/**
 *
 */
- (void)roomControllerDidJoinRoom:(IFBKRoomController*)controller;

/**
 *
 */
- (void)roomController:(IFBKRoomController*)controller didReceiveNewMessage:(IFBKCFMessage*)message;

/**
 *
 */
- (void)roomControllerDidUpdateMessagesList:(IFBKRoomController*)controller;

/**
 *
 */
- (void)roomController:(IFBKRoomController*)controller didConfirmPost:(NSString*)body message:(IFBKCFMessage*)message;

/**
 *
 */
- (void)roomControllerDidUpdateUnreadMessages:(IFBKRoomController*)controller;

///-----------------------------------------------------------------------------
/// @name Notifications
///-----------------------------------------------------------------------------

/**
 * Informs the delegate that a notification for a new message should be posted.
 */
- (void)roomController:(IFBKRoomController*)controller didReceiveNotificationFormessage:(IFBKCFMessage*)message;

///-----------------------------------------------------------------------------
/// @name Errors
///-----------------------------------------------------------------------------

/**
 *
 */
- (void)roomController:(IFBKRoomController*)controller didEncouterError:(NSError*)error;

/**
 *
 */
- (void)roomController:(IFBKRoomController*)controller didEncouterStreamError:(NSError*)error;

@end
