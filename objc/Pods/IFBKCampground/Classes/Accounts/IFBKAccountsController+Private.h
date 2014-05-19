#import "IFBKAccountsController.h"

@interface IFBKAccountsController ()

@property (nonatomic, copy, readwrite) NSArray *launchpadAccounts;
@property (nonatomic, strong, readwrite) NSString *accessToken;

@property (nonatomic, strong, readwrite) NSMutableDictionary *campfireAccountsByID;
@property (nonatomic, strong, readwrite) NSMutableDictionary *roomsIDBycampfireAccountID;
@property (nonatomic, strong, readwrite) NSMutableDictionary *roomsByID;

@property (atomic, assign) NSInteger fetchOperationsCount;
@property (atomic, assign) BOOL didInformDelegateAboutError;

// API Private Helpers

- (void)_fetchcampfireAccountWithClient:(IFBKCampfireClient*)client;
- (void)_campfireClient:(IFBKCampfireClient*)client didGetCurrentAccount:(IFBKCFAccount *)account;

- (void)_fetchcampfireRoomListForAccount:(IFBKCFAccount*)account client:(IFBKCampfireClient*)client;
- (void)_campfireClient:(IFBKCampfireClient*)client didGetRooms:(NSArray *)rooms account:(NSNumber*)accountID;

- (void)_fetchRoomWithIdentifier:(NSNumber*)identifier client:(IFBKCampfireClient*)client;
- (void)_campfireClient:(IFBKCampfireClient*)client didGetRoom:(IFBKCFRoom *)room;

// Private methods


- (void)_willStartFetchOperation;
- (void)_campfireClientDidEncounterError:(NSError*)responseError response:(NSHTTPURLResponse*)response;

@end

