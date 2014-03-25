//
//  MMPreferences.m
//  Confab App
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "CFAPreferencesManager.h"

// Notifications
NSString *const kCFAPreferencesManagerNotificationKey = @"kCFAPreferencesManagerNotificationKey";
NSString *const kCFAPreferencesManagerNotificationUserInfoKey = @"kCFAPreferencesManagerNotificationUserInfoKey";

// Keys
NSString *const kCFAPreferencesManagerNotifyOnlyForMentionsPreferenceKey = @"kCFAPreferencesManagerNotifyOnlyForMentionsPreferenceKey";

@implementation CFAPreferencesManager {
    BOOL _notifyOnlyForMentions;
}

//------------------------------------------------------------------------------
#pragma mark - Initialization
//------------------------------------------------------------------------------

+ (instancetype)sharedInstance {
    static id __sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [self new];
    });
    return __sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _notifyOnlyForMentions = [[NSUserDefaults standardUserDefaults] boolForKey:kCFAPreferencesManagerNotifyOnlyForMentionsPreferenceKey];
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Room settings
//------------------------------------------------------------------------------

- (BOOL)notifyOnlyForMentions {
    return _notifyOnlyForMentions;
}

- (void)setNotifyOnlyForMentions:(BOOL)flag {
    _notifyOnlyForMentions = flag;
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:kCFAPreferencesManagerNotifyOnlyForMentionsPreferenceKey];
    [self _postNotificationForKey:kCFAPreferencesManagerNotifyOnlyForMentionsPreferenceKey];
}

//------------------------------------------------------------------------------
#pragma mark - Private helpers
//------------------------------------------------------------------------------

- (void)_postNotificationForKey:(NSString*)key {
    NSDictionary *userInfo = @{ kCFAPreferencesManagerNotificationUserInfoKey: key };
    [[NSNotificationCenter defaultCenter] postNotificationName:kCFAPreferencesManagerNotificationKey object:self userInfo:userInfo];
}

@end
