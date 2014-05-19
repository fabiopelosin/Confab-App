#import <IFBKThirtySeven/IFBKThirtySeven.h>
#import "IFBKAccountsController.h"
#import "IFBKAccountsController+Private.h"
#import "NSError+IFBKCampground.h"

@implementation IFBKAccountsController

- (instancetype)init {
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithAccounts:(NSArray *)launchpadAccounts accessToken:(NSString*)accessToken {
    self = [super init];
    if (self) {
        _launchpadAccounts = launchpadAccounts;
        _accessToken = accessToken;
    }
    return self;
}

+ (instancetype)newWithAccounts:(NSArray *)launchpadAccounts accessToken:(NSString*)accessToken {
    return [[[self class] alloc] initWithAccounts:launchpadAccounts accessToken:accessToken];
}

- (IFBKCampfireClient*)clientForLaunchpadAccount:(IFBKLPAccount*)launchpadAccount {
    NSURL *baseURL = [NSURL URLWithString:launchpadAccount.href];
    return [[IFBKCampfireClient alloc]initWithBaseURL:baseURL accessToken:self.accessToken];
}

// TODO: Test
- (IFBKCampfireClient*)clientForCampfireAccount:(IFBKCFAccount*)campfireAccount {
    return [[IFBKCampfireClient alloc]initWithSubdomain:campfireAccount.subdomain accessToken:self.accessToken];
}

//------------------------------------------------------------------------------
#pragma mark - Fetching Information
//------------------------------------------------------------------------------

- (void)fetchInformation {
    if ([self.delegate respondsToSelector:@selector(accountsControllerWillStartFetch:)]) {
        [self.delegate accountsControllerWillStartFetch:self];
    }

    [self setCampfireAccountsByID:[NSMutableDictionary new]];
    [self setRoomsIDBycampfireAccountID:[NSMutableDictionary new]];
    [self setRoomsByID:[NSMutableDictionary new]];
    [self setFetchOperationsCount:0];
    [self setDidInformDelegateAboutError:NO];

    for (IFBKLPAccount *account in self.launchpadAccounts) {
        if ([account.product isEqualToString:@"campfire"]) { // TODO: test
            IFBKCampfireClient *client = [self clientForLaunchpadAccount:account];
            [self _fetchcampfireAccountWithClient:client];
        }
    }
}

- (NSArray*)campfireAccounts {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
    NSArray *sortedArray = [[self.campfireAccountsByID allValues] sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}

- (NSArray*)roomIdentifiersForcampfireAccount:(IFBKCFAccount*)account {
    return self.roomsIDBycampfireAccountID[account.identifier];
}

- (NSArray*)roomsForcampfireAccount:(IFBKCFAccount*)account {
    NSArray *roomIDs = [self roomIdentifiersForcampfireAccount:account];
    NSMutableArray *rooms = [NSMutableArray new];
    for (id identifier in roomIDs) {
        IFBKCFRoom *room = self.roomsByID[identifier];
        if (room) {
            [rooms addObject:room];
        }
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
    NSArray *sortedArray = [rooms sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}

- (IFBKCFAccount*)campfireAccountForRoom:(IFBKCFRoom*)room {
    __block NSNumber *accountID;
    [self.roomsIDBycampfireAccountID enumerateKeysAndObjectsUsingBlock:^(NSNumber *dictAccountID, NSArray *dictRoomIDs, BOOL *dictStop) {
        NSUInteger roomIndex = [dictRoomIDs indexOfObjectPassingTest:^BOOL(NSNumber *roomID, NSUInteger idx, BOOL *stop) {
            return [roomID isEqualToNumber:room.identifier];
        }];
        if (roomIndex != NSNotFound) {
            accountID = dictAccountID;
            *dictStop = TRUE;
        }
    }];

    IFBKCFAccount* account = self.campfireAccountsByID[accountID];
    return account;
}

//------------------------------------------------------------------------------
#pragma mark - API Private Helpers
//------------------------------------------------------------------------------

- (void)_fetchcampfireAccountWithClient:(IFBKCampfireClient*)client {
    [self _willStartFetchOperation];
    [client getCurrentAccount:^(IFBKCFAccount *account) {
        [self _campfireClient:client didGetCurrentAccount:account];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [self _campfireClientDidEncounterError:error response:response];
    }];
}


- (void)_campfireClient:(IFBKCampfireClient*)client didGetCurrentAccount:(IFBKCFAccount *)account {
    self.campfireAccountsByID[account.identifier] = account;
    [self _fetchcampfireRoomListForAccount:account client:client];
    [self _didCompleteFetchOperation];
}

- (void)_fetchcampfireRoomListForAccount:(IFBKCFAccount*)account client:(IFBKCampfireClient*)client {
    [self _willStartFetchOperation];
    [client getRooms:^(NSArray *rooms) {
        [self _campfireClient:client didGetRooms:rooms account:account.identifier];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [self _campfireClientDidEncounterError:error response:response];
    }];
}

- (void)_campfireClient:(IFBKCampfireClient*)client didGetRooms:(NSArray *)rooms account:(NSNumber*)accountID {
    self.roomsIDBycampfireAccountID[accountID] = [rooms valueForKey:@"identifier"];
    for (IFBKCFRoom *room in rooms) {
        if (room) {
            // TODO: document that this request doesn't returns the user count.
            self.roomsByID[room.identifier] = room;
        }
        [self _fetchRoomWithIdentifier:room.identifier client:client];
    }
    [self _didCompleteFetchOperation];
}

- (void)_fetchRoomWithIdentifier:(NSNumber*)identifier client:(IFBKCampfireClient*)client {
    [self _willStartFetchOperation];
    [client getRoomForId:identifier success:^(IFBKCFRoom *roomWithUsers) {
        [self _campfireClient:client didGetRoom:roomWithUsers];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [self _campfireClientDidEncounterError:error response:response];
    }];
}

- (void)_campfireClient:(IFBKCampfireClient*)client didGetRoom:(IFBKCFRoom *)room {
    if (room) {
        self.roomsByID[room.identifier] = room;
    }
    [self _didCompleteFetchOperation];
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

- (void)_willStartFetchOperation {
    self.fetchOperationsCount++;
}

- (void)_didCompleteFetchOperation {
    self.fetchOperationsCount--;
    if (self.fetchOperationsCount <= 0 && !self.didInformDelegateAboutError) {
        if ([self.delegate respondsToSelector:@selector(accountsControllerDidCompleteFetch:)]) {
            [self.delegate accountsControllerDidCompleteFetch:self];
        }
    }
}

- (void)_campfireClientDidEncounterError:(NSError*)responseError response:(NSHTTPURLResponse*)response {
    if ([self.delegate respondsToSelector:@selector(accountsController:didEncouterFetchError:)]) {
        if (!self.didInformDelegateAboutError) {
            NSError *error = [NSError campgroundErrorWithUnderlayingError:responseError response:response noAuthorizationErrorCode:IFBKCampgroundUserAuthorizationRequiredErrorCode];
            [self.delegate accountsController:self didEncouterFetchError:error];
            [self setDidInformDelegateAboutError:TRUE];
        }
    }
    [self _didCompleteFetchOperation];
}

@end
