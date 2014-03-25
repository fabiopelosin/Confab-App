//
//  MMNotificationManager.h
//  Confab App
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Foundation/Foundation.h>
#import <IFBKThirtySeven/IFBKThirtySeven.h>
#import "MMUser.h"

@interface MMNotificationManager : NSObject <NSUserNotificationCenterDelegate>

+ (MMNotificationManager *)sharedManager;

- (void)showNotificationForMessage:(IFBKCFMessage*)message user:(MMUser*)user room:(IFBKCFRoom*)room;

+ (NSArray*)availableSoundNames;

@end
