//
//  MMAuthManager.h
//  Confab App
//
//  Created by Fabio Pelosin on 26/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IFBKThirtySeven/IFBKThirtySeven.h>

@interface CFAAuthorizationCredentialsVault : NSObject

+ (instancetype)sharedInstance;

- (NSString*)clientID;
- (NSString*)clientSecret;
- (NSString*)redirectUri;

- (NSString*)accessToken;
- (NSString*)refreshToken;
- (NSDate*)expirationDate;
- (void)storeAccessToken:(NSString*)accessToken refresToken:(NSString*)refreshToken expirationDate:(NSDate*)expirtationDate;

- (NSString*)apiAuthenticationTokenForDomain:(NSURL*)domain;
- (void)setAPIAuthenticationToken:(NSString*)token forDomain:(NSURL*)domain;

- (void)clearAuthData;

@property IFBKLPAuthorizationData* authData;

@end
