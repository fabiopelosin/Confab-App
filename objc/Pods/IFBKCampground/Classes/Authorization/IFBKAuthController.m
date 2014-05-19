#import "IFBKAuthController.h"
#import "NSError+IFBKCampground.h"
#import <IFBKThirtySeven/IFBKThirtySeven.h>

@interface IFBKAuthController ()
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation IFBKAuthController {
}

- (instancetype)init {
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithClientID:(NSString*)clientID clientSecret:(NSString*)clientSecret redirectURI:(NSString*)redirectURI {
    self = [super init];
    if (self) {
        [IFBKLaunchpadClient setClientId:clientID clientSecret:clientSecret redirectUri:redirectURI];
    }
    return self;
}

+ (instancetype)newWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret redirectURI:(NSString *)redirectURI {
    return [[[self class] alloc] initWithClientID:clientID clientSecret:clientSecret redirectURI:redirectURI];
}

//------------------------------------------------------------------------------
#pragma mark - Authorization
//------------------------------------------------------------------------------

- (void)authorizeWithSuccess:(IFBKAuthControllerSucessBlock)success failure:(IFBKAuthControllerFailureBlock)failure {
    [self _authorizeUsingAccessToken:success failure:^(NSError *accessTokenError) {
        if ([accessTokenError shouldRecoverByReestablishingInternetConnection]) {
            failure(accessTokenError);
        } else {
            [self _authorizeByRefreshingAccessToken:success failure:^(NSError *refreshTokenError) {
                NSError *error = [NSError campgroundErrorWithCode:IFBKCampgroundUserAuthorizationRequiredErrorCode underlyingError:refreshTokenError response:nil];
                failure(error);
            }];
        }
    }];
}

- (void)authorizeWithTemporaryCode:(NSString*)code success:(IFBKAuthControllerSucessBlock)success failure:(IFBKAuthControllerFailureBlock)failure {
    NSLog(@"Verification Code: %@", code);
    [IFBKLaunchpadClient getAccessTokenForVerificationCode:code success:^(NSString *accessToken, NSString *refreshToken, NSDate *expiresAt) {
        [self setAccessToken:accessToken];
        [self setRefreshToken:refreshToken];
        [self setExpirationDate:expiresAt];
        [self authorizeWithSuccess:success failure:failure];
    } failure:^(NSError *responseError, NSHTTPURLResponse *response) {
        NSError *error;
        if (response.statusCode == 401) {
            error = [NSError campgroundErrorWithCode:IFBKCampgroundInvalidTemporaryCodeErrorCode underlyingError:responseError response:response];
        } else {
            error = [NSError campgroundErrorWithNSURLError:responseError response:response];
        }
        failure(error);
    }];
}

//------------------------------------------------------------------------------
#pragma mark - Authorization Strategies
//------------------------------------------------------------------------------


- (void)_authorizeUsingAccessToken:(IFBKAuthControllerSucessBlock)success failure:(IFBKAuthControllerFailureBlock)failure {
    if (!self.accessToken) {
        NSError *error = [NSError campgroundErrorWithCode:IFBKCampgroundNoAccessTokenErrorCode underlyingError:nil response:nil];
        failure(error);
    }

    else if ([self.expirationDate laterDate:[NSDate date]] != self.expirationDate) {
        NSError *error = [NSError campgroundErrorWithCode:IFBKCampgroundExpiredAccessTokenErrorCode underlyingError:nil response:nil];
        failure(error);
    }
    else {
        [IFBKLaunchpadClient setBearerToken:self.accessToken];
        [IFBKLaunchpadClient getAuthorizationData:^(IFBKLPAuthorizationData *authData) {
            success(authData);
        } failure:^(NSError *responseError, NSHTTPURLResponse *response) {
            NSError *error;
            if (response.statusCode == 401) {
                error = [NSError campgroundErrorWithCode:IFBKCampgroundInvalidAccessTokenErrorCode underlyingError:responseError response:response];
            } else {
                error = [NSError campgroundErrorWithNSURLError:responseError response:response];
            }
            failure(error);
        }];
    }
}

- (void)_authorizeByRefreshingAccessToken:(IFBKAuthControllerSucessBlock)success failure:(IFBKAuthControllerFailureBlock)failure {
    if (!self.refreshToken) {
        NSError *error = [NSError campgroundErrorWithCode:IFBKCampgroundNoRefreshTokenErrorCode underlyingError:nil response:nil];
        failure(error);
    }
    else {
        [IFBKLaunchpadClient refreshAccessTokenWithRefreshToken:self.refreshToken success:^(NSString *accessToken, NSDate *expiresAt) {
            [self setAccessToken:accessToken];
            [self setExpirationDate:expiresAt];
            [self _authorizeUsingAccessToken:success failure:failure];
        } failure:^(NSError *responseError, NSHTTPURLResponse *response) {
            NSError *error;
            if (response.statusCode == 401) {
                error = [NSError campgroundErrorWithCode:IFBKCampgroundInvalidRefreshTokenErrorCode underlyingError:responseError response:response];
            } else {
                error = [NSError campgroundErrorWithNSURLError:responseError response:response];
            }
            failure(error);
        }];
    }
}

@end
