//
//  MMUsersController.h
//  Confab App
//
//  Created by Fabio Pelosin on 23/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Foundation/Foundation.h>
#import <IFBKThirtySeven/IFBKThirtySeven.h>
#import "MMUser.h"

@interface MMUsersFetcher : NSObject

- (MMUser*)userWithID:(NSNumber*)userID;

- (void)loadUserWithID:(NSNumber*)userID apiClient:(IFBKCampfireClient*)apiClient;

- (MMUser*)userWithID:(NSNumber*)userID fetchingFromApiClientIfNeede:(IFBKCampfireClient*)apiClient;

@end
