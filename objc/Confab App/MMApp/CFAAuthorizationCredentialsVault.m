//
//  MMAuthManager.m
//  Confab App
//
//  Created by Fabio Pelosin on 26/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "CFAAuthorizationCredentialsVault.h"
#import "CFASecrets.h"

NSString *kMMAuthManagerAccessToken = @"kMMAuthManagerAccessToken";
NSString *kMMAuthManagerRefreshToken = @"kMMAuthManagerRefreshToken";
NSString *kMMAuthManagerExpirtationDate = @"kMMAuthManagerExpirtationDate";
NSString *kMMAuthManagerAuthenticationTokensByDomainKey = @"kMMAuthManagerAuthenticationTokensByDomainKey";

@interface CFAAuthorizationCredentialsVault ()
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation CFAAuthorizationCredentialsVault

+ (instancetype)sharedInstance {
    static id __sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [CFAAuthorizationCredentialsVault new];
    });
    return __sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Getting tokens
//------------------------------------------------------------------------------

- (void)storeAccessToken:(NSString*)accessToken refresToken:(NSString*)refreshToken expirationDate:(NSDate*)expirtationDate {
    NSString *stringExpirationDate = [[self _dateFormatter] stringFromDate:expirtationDate];
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kMMAuthManagerAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:kMMAuthManagerRefreshToken];
    [[NSUserDefaults standardUserDefaults] setObject:stringExpirationDate forKey:kMMAuthManagerExpirtationDate];
}

- (NSString*)accessToken {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:kMMAuthManagerAccessToken];
    return accessToken;
}

- (NSString*)refreshToken {
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] stringForKey:kMMAuthManagerRefreshToken];
    return refreshToken;
}

- (NSDate*)expirationDate {
    NSString *stringExpirationDate = [[NSUserDefaults standardUserDefaults] stringForKey:kMMAuthManagerExpirtationDate];
    NSDate *date = [[self _dateFormatter] dateFromString:stringExpirationDate];
    return date;
}

- (NSString*)apiAuthenticationTokenForDomain:(NSURL*)domain {
    NSDictionary *authTokens = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kMMAuthManagerAuthenticationTokensByDomainKey];
    return authTokens[domain.absoluteString];
}

- (void)setAPIAuthenticationToken:(NSString*)token forDomain:(NSURL*)domain {
    NSMutableDictionary *authTokens = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:kMMAuthManagerAuthenticationTokensByDomainKey] mutableCopy];
    if (!authTokens) {
        authTokens = [NSMutableDictionary new];
    }

    if (token && domain) {
        authTokens[domain.absoluteString] = token;
    }
    [[NSUserDefaults standardUserDefaults] setObject:authTokens forKey:kMMAuthManagerAuthenticationTokensByDomainKey];
}

- (void)clearAuthData {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMMAuthManagerAccessToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMMAuthManagerRefreshToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMMAuthManagerExpirtationDate];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMMAuthManagerAuthenticationTokensByDomainKey];
}

//------------------------------------------------------------------------------
#pragma mark - Auths
//------------------------------------------------------------------------------

- (NSString*)clientID {
    return kCFAClientID;
}

- (NSString*)clientSecret {
    return kCFAClientSecret;
}

- (NSString*)redirectUri {
    return kCFARedirectURI;
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (NSDateFormatter*)_dateFormatter {
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return dateFormatter;
}


@end
