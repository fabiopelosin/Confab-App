//
//  MMUsersController.m
//  Confab App
//
//  Created by Fabio Pelosin on 23/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMUsersFetcher.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "MMUserImageProvider.h"

@implementation MMUsersFetcher

- (MMUser*)userWithID:(NSNumber*)userID {
    if (![userID isEqual:[NSNull null]]) {
        return [MMUser MR_findFirstByAttribute:@"userID" withValue:[userID stringValue]];
    } else {
        return nil;
    }
}

- (void)loadUserWithID:(NSNumber*)userID apiClient:(IFBKCampfireClient*)apiClient {
    [apiClient getUserForId:userID success:^(IFBKCFUser *user) {
        NSLog(@"API HIT: grabbed user %@.", user.name);
        MMUser *userCD = [self userWithID:userID];
        if (!userCD) {
            userCD = [MMUser MR_createEntity];
        }
        [self configureUser:userCD apiUser:user];
        [[NSManagedObjectContext MR_defaultContext]  MR_saveToPersistentStoreAndWait];
        [self loadImageForUser:userCD];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [[NSAlert alertWithError:error] runModal];
    }];
}

- (MMUser*)userWithID:(NSNumber*)userID fetchingFromApiClientIfNeede:(IFBKCampfireClient*)apiClient {
    MMUser *userCD = [self userWithID:userID];
    if (userCD) {
        return userCD;
    } else {
        [self loadUserWithID:userID apiClient:apiClient];
        return nil;
    }
}

//------------------------------------------------------------------------------
#pragma mark - Private Helpers
//------------------------------------------------------------------------------

- (void)configureUser:(MMUser*)user apiUser:(IFBKCFUser *)apiUser {
  user.admin = [NSNumber numberWithBool:apiUser.admin];
  user.avatarURL = apiUser.avatarUrl;
  user.createdAt = apiUser.createdAt;
  user.emailAddress = apiUser.emailAddress;
  user.userID = [apiUser.identifier stringValue];
  user.name = apiUser.name;
  user.type = apiUser.type;
}

- (void)loadImageForUser:(MMUser*)user {
  [MMUserImageProvider loadImageForUser:user];
}

@end
