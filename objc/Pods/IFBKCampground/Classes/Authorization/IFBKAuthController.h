#import <Foundation/Foundation.h>
#import <IFBKThirtySeven/IFBKLPAuthorizationData.h>

typedef void (^IFBKAuthControllerSucessBlock)(IFBKLPAuthorizationData *authData);
typedef void (^IFBKAuthControllerFailureBlock)(NSError *error);

/**
 * Simplifies Launchpad authorization abstracting it and automatically
 * refreshing the access token if needed.
 *
 * The suggested workflow for clients is:
 *
 * - attempt the authorization
 * - if authorization fails with an error indicating that user authorization is
 *   needed, they should retrieve the temporary code (with their custom UI) and
 *   use it to authorize.
 * - the operation fails for any other reason the only suggested strategy is to
 *   retry later.
 *
 * Clients are responsible of storing any token securely and providing them
 * before authorization.
 */
@interface IFBKAuthController : NSObject

///-----------------------------------------------------------------------------
/// @name Initialization
///-----------------------------------------------------------------------------

/**
 * The designated initializer.
 *
 * @param clientID The OAuth client ID.
 * @param clientSecret The OAuth client secret key.
 * @param redirectURI  The OAuth redirect URI, which is passed in as a
 *                     post-authentication callback
*/
- (instancetype)initWithClientID:(NSString*)clientID clientSecret:(NSString*)clientSecret redirectURI:(NSString*)redirectURI;

/**
 * Convenience initializer.
 *
 * @param clientID The OAuth client ID.
 * @param clientSecret The OAuth client secret key.
 * @param redirectURI  The OAuth redirect URI, which is passed in as a
 *                     post-authentication callback
 */
+ (instancetype)newWithClientID:(NSString*)clientID clientSecret:(NSString*)clientSecret redirectURI:(NSString*)redirectURI;

///-----------------------------------------------------------------------------
/// @name Tokens
///-----------------------------------------------------------------------------

/**
 * The OAuth access token.
 */
@property (nonatomic, copy) NSString *accessToken;

/**
 * The OAuth refresh token used to refresh expired access tokens.
 */
@property (nonatomic, copy) NSString *refreshToken;

/**
 * The expiration date of the access token.
 */
@property (nonatomic, copy) NSDate *expirationDate;

///-----------------------------------------------------------------------------
/// @name Authorization
///-----------------------------------------------------------------------------

/**
 * Authorizes with the access token if one has been set. Otherwise if the
 * access token has not been set, has expired, or is invalid, it uses the
 * refresh token to generate a new access token and authorizes with that one.
 *
 * Unless an unexpected error occurred, failures are can be recovered with one
 * of the following strategies:
 *
 * - `shouldRecoverByReauthorizing`
 * - `shouldRecoverByReestablishingInternetConnection`
 *
 * Other error codes might be returned but this is unexpected and the only
 * suggested strategy is to retry later.
 *
 * @param success A handle called if the authorization is successful. It
 *                receives the authorization data which contains the
 *                information about the accounts. Clients might want to store
 *                the authorization tokens at this point.
 * @param failure A called if the authorization failed. It receives the
 *                `IFBKCampground` error which usually wraps an underlying
 *                error.
 */
- (void)authorizeWithSuccess:(IFBKAuthControllerSucessBlock)success
                     failure:(IFBKAuthControllerFailureBlock)failure;

/**
 * Authorizes with the temporary code provided by OAuth.
 *
 * The failure block will return an error which in the majority of the cases
 * will respond to the `shouldRecoverByReestablishingInternetConnection`
 * recovery strategy:
 *
 * Unless an unexpected error occurred, failures are can be recovered with the
 * `shouldRecoverByReestablishingInternetConnection` strategy.
 *
 * @param success A handle called if the authorization is successful. It
 *                receives the authorization data which contains the
 *                information about the accounts. Clients might want to store
 *                the authorization tokens at this point.
 * @param failure A called if the authorization failed. It receives the
 *                `IFBKCampground` error which usually wraps an underlying
 *                error.
 */
- (void)authorizeWithTemporaryCode:(NSString*)code
                           success:(IFBKAuthControllerSucessBlock)success
                           failure:(IFBKAuthControllerFailureBlock)failure;
@end
