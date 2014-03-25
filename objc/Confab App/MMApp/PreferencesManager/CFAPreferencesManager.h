//
//  MMPreferences.h
//  Confab App
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Foundation/Foundation.h>

/**
 *
 */
NSString *const kCFAPreferencesManagerNotificationKey;

/**
 *
 */
NSString *const kCFAPreferencesManagerNotificationUserInfoKey;

/*
 *
 */
NSString *const kCFAPreferencesManagerNotifyOnlyForMentionsPreferenceKey;

/**
 *
 */
@interface CFAPreferencesManager : NSObject

///-----------------------------------------------------------------------------
/// @name Initialization
///-----------------------------------------------------------------------------

/**
 * The shared instance which should be used by the application.
 */
+ (instancetype)sharedInstance;

///-----------------------------------------------------------------------------
/// @name Room setting
///-----------------------------------------------------------------------------

/**
 * Whether notifications for the rooms where the user is logged in should be 
 * fired only for messages mentioning the name of the user.
 */
@property (nonatomic, assign) BOOL notifyOnlyForMentions;

@end
