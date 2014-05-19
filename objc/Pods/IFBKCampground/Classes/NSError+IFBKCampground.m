#import "NSError+IFBKCampground.h"

NSString * const kIFBKCampgroundErrorDomain = @"IFBKCampgroundErrorDomain";
NSString * const kIFBKCampgroundErrorResponseKey = @"IFBKCampgroundErrorDomain";

@implementation NSError (IFBKCampground)

+ (instancetype)campgroundErrorWithCode:(IFBKCampgroundErrorCode)errorCode underlyingError:(NSError*)underlyingError response:(NSHTTPURLResponse *)response {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];

    if (underlyingError) {
        userInfo[NSUnderlyingErrorKey] = underlyingError;
    }

    if (response) {
        // AFNetworkingOperationFailingURLResponseErrorKey
        userInfo[kIFBKCampgroundErrorResponseKey] = response;
    }

    userInfo[NSLocalizedDescriptionKey] = [NSString stringWithFormat:NSLocalizedStringFromTable([self _localizedDescriptionForCode:errorCode underlyingError:underlyingError response:response], @"IFBKCampground", nil)];

    NSError *error = [self errorWithDomain:kIFBKCampgroundErrorDomain code:errorCode userInfo:userInfo];
    return error;
}

+ (NSString*)_localizedDescriptionForCode:(IFBKCampgroundErrorCode)errorCode underlyingError:(NSError*)underlyingError response:(NSHTTPURLResponse *)response {
    NSString *result;
    switch (errorCode) {
        case IFBKCampgroundNoInternetConnectivityErrorCode:
            result = @"No internet Connectivity";
            break;
        case IFBKCampgroundUnknownErrorCode:
            result = @"Unexpected Error";
            break;
        case IFBKCampgroundUserAuthorizationRequiredErrorCode:
            result = @"User authorization required via OAuth";
            break;
        case IFBKCampgroundNoAccessTokenErrorCode:
            result = @"No access token";
            break;
        case IFBKCampgroundExpiredAccessTokenErrorCode:
            result = @"The access token is expired";
            break;
        case IFBKCampgroundInvalidAccessTokenErrorCode:
            result = @"Invalid access token";
            break;
        case IFBKCampgroundNoRefreshTokenErrorCode:
            result = @"No refresh token";
            break;
        case IFBKCampgroundInvalidRefreshTokenErrorCode:
            result = @"Invalid refresh token";
            break;
        case IFBKCampgroundInvalidTemporaryCodeErrorCode:
            result = @"Invalid verification code";
            break;
    }

    if (underlyingError && underlyingError.localizedDescription) {
        result = [result stringByAppendingString:[NSString stringWithFormat:@": %@", underlyingError.localizedDescription]];
    }

    if (response) {
        result = [result stringByAppendingString:[NSString stringWithFormat:@" (%@)", [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]]];
    }

    return result;
}

+ (instancetype)campgroundErrorWithUnderlayingError:(NSError*)underlyingError response:(NSHTTPURLResponse *)response noAuthorizationErrorCode:(IFBKCampgroundErrorCode)errorCode {
    NSError *error;
    if (response && response.statusCode == 401) {
        error = [self campgroundErrorWithCode:errorCode underlyingError:underlyingError response:response];
    } else if ([underlyingError.domain isEqualToString:NSURLErrorDomain]) {
        error = [self campgroundErrorWithNSURLError:underlyingError response:response];
    } else {
        error = [self errorWithDomain:kIFBKCampgroundErrorDomain code:IFBKCampgroundUnknownErrorCode userInfo:nil];
    }
    return error;
}


+ (instancetype)campgroundErrorWithNSURLError:(NSError*)underlyingError response:(NSHTTPURLResponse *)response {
    IFBKCampgroundErrorCode code;
    if (underlyingError.code == NSURLErrorTimedOut ||
        underlyingError.code == NSURLErrorCannotFindHost ||
        underlyingError.code == NSURLErrorCannotConnectToHost ||
        underlyingError.code == NSURLErrorNetworkConnectionLost ||
        underlyingError.code == NSURLErrorNotConnectedToInternet ||
        underlyingError.code == NSURLErrorDNSLookupFailed ) {
        code = IFBKCampgroundNoInternetConnectivityErrorCode;
    } else {
        code = IFBKCampgroundUnknownErrorCode;
    }

    NSError *error = [self campgroundErrorWithCode:code underlyingError:underlyingError response:response];
    return error;
}

- (BOOL)isIFBKCampgroundError {
    return [self.domain isEqualToString:kIFBKCampgroundErrorDomain];
}

//------------------------------------------------------------------------------
#pragma mark - Querying Errors
//------------------------------------------------------------------------------

- (BOOL)shouldRecoverByReauthorizing {
    NSInteger code = self.code;
    return
    code == IFBKCampgroundUserAuthorizationRequiredErrorCode ||
    code == IFBKCampgroundNoAccessTokenErrorCode ||
    code == IFBKCampgroundExpiredAccessTokenErrorCode ||
    code == IFBKCampgroundInvalidAccessTokenErrorCode ||
    code == IFBKCampgroundNoRefreshTokenErrorCode ||
    code == IFBKCampgroundInvalidRefreshTokenErrorCode ||
    code == IFBKCampgroundInvalidTemporaryCodeErrorCode;
}

- (BOOL)shouldRecoverByReestablishingInternetConnection {
    return self.code == IFBKCampgroundNoInternetConnectivityErrorCode;
}


@end
