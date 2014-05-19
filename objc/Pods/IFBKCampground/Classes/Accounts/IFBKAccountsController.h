#import <Foundation/Foundation.h>
#import <IFBKThirtySeven/IFBKLPAccount.h>
#import <IFBKThirtySeven/IFBKCampfireClient.h>
#import <IFBKThirtySeven/IFBKCFAccount.h>
#import <IFBKThirtySeven/IFBKCFRoom.h>

@protocol IFBKAccountsControllerDeletage;

/**
 * Class which fetches all the information relative to the campfires of a
 * LauchPad account. It fetches all the information required to present a 
 * view similar to one presented by the
 * web interface to select a room.
 */
@interface IFBKAccountsController : NSObject

/**
 * The designated initializer.
 * 
 * @param launchpadAccounts  A list of `IFBKLPAccount` which reppresent the Launchpad
 *                          accounts for which the information is required.
 * @param accessToken       The access token used to configure the client for each
 *                          campfire.
 */
- (instancetype)initWithAccounts:(NSArray *)launchpadAccounts accessToken:(NSString*)accessToken;

/**
 * Convenience initializer.
 *
 * @param launchpadAccounts  A list of `IFBKLPAccount` which reppresent the Launchpad
 *                          accounts for which the information is required.
 * @param accessToken       The access token used to configure the client for each
 *                          campfire.
 */
+ (instancetype)newWithAccounts:(NSArray *)launchpadAccounts accessToken:(NSString*)accessToken;

/**
 * The list of Launchpad accounts passed on initialization.
 */
@property (nonatomic, copy, readonly) NSArray *launchpadAccounts;

/**
 * The delegate which will receive notifications about udpate progress.
 */
@property (weak) id<IFBKAccountsControllerDeletage>delegate;

/**
 * Returns the campfire API client for a given account. The client is configured 
 * with the access token and is ready to be useed.
 *
 * @param launchpadAccounts The account for which the client is needed.
 */
- (IFBKCampfireClient*)clientForLaunchpadAccount:(IFBKLPAccount*)launchpadAccounts;

/**
 * Returns the Campfire client for accessing the given Campfire account.
 */
- (IFBKCampfireClient*)clientForCampfireAccount:(IFBKCFAccount*)campfireAccount;

///-----------------------------------------------------------------------------
/// @name Fetching Information
///-----------------------------------------------------------------------------

/**
 * Fetches the information about the campfire accounts and their rooms for each 
 * Launchpad account.
 */
- (void)fetchInformation;

/**
 * The list of `IFBKCFAccount` instances representing the campfire accounts
 * associated with each LauchPad account.
 */
@property (nonatomic, strong, readonly) NSArray *campfireAccounts;

/**
 * The list of the room identifiers (`NSNumber`) associated with each campfire 
 * account identifier (`NSNumber`).
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *roomsIDBycampfireAccountID;

/**
 * The map of the rooms (`IFBKCFRoom`) by their identfifier (`NSNumber`).
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *roomsByID;

/**
 * The list of the room identifiers (`NSNumber`) associated with the given 
 * account.
 *
 * @param account The account for which the list of the rooms is needed.
 */
- (NSArray*)roomIdentifiersForcampfireAccount:(IFBKCFAccount*)account;

/**
 * The list of the `IFBKCFRoom` instances reppresenting the rooms associated 
 * with the given account.
 *
 * @param account The account for which the rooms are needed.
 */
- (NSArray*)roomsForcampfireAccount:(IFBKCFAccount*)account;

/**
 * Returns the Campfire account associated with a given room.
 * @param room The room for which the account is needed.
 */
- (IFBKCFAccount*)campfireAccountForRoom:(IFBKCFRoom*)room;

@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@protocol IFBKAccountsControllerDeletage <NSObject>

@optional

/**
 * Infors the delegate that a fecth for new information started.
 */
- (void)accountsControllerWillStartFetch:(IFBKAccountsController*)controller;

/*
 * Informs the delegate that all the information was fetches sucessfully.
 */
- (void)accountsControllerDidCompleteFetch:(IFBKAccountsController*)controller;

/**
 * Informs the delegate that an error occured during the one of the API calls.
 * It will be called only once.
 */
- (void)accountsController:(IFBKAccountsController*)controller didEncouterFetchError:(NSError*)error;

@end
