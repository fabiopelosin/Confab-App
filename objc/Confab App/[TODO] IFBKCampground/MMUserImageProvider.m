//
//  MMUserImageProvider.m
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMUserImageProvider.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking/AFNetworking.h>

NSString *const kMMUserImageProviderImageUpdateNotification = @"kMMUserImageProviderImageUpdateNotification";

//------------------------------------------------------------------------------
@implementation MMUserImageProvider
//------------------------------------------------------------------------------

+ (void)loadImageForUser:(MMUser*)user {
    NSImage *userDefinedImage = [self _userDefinedImageForUser:user];
    if (userDefinedImage) {
        user.avatar = userDefinedImage;
        [[NSNotificationCenter defaultCenter] postNotificationName:kMMUserImageProviderImageUpdateNotification object:self];
        return;
    }

    NSURL *avatarURL = [NSURL URLWithString:user.avatarURL];
    if ([[avatarURL absoluteString] rangeOfString:@"missing/avatar.gif"].location != NSNotFound) {
        NSString *email = user.emailAddress;
        avatarURL = [self _URLForGravatarWithEmail:email imageSize:nil defaultImage:nil];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:avatarURL];
    AFHTTPRequestOperation *image_operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [image_operation setResponseSerializer:[AFImageResponseSerializer serializer]];
    [image_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSImage *image) {
        user.avatar = image;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMMUserImageProviderImageUpdateNotification object:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    [image_operation start];
}


//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

// TODO
+ (NSImage*)_userDefinedImageForUser:(MMUser*)user {
    if ([user.name isEqualToString:@"GitHub"]) {
        return [NSImage imageNamed:@"bot_avatar.png"];
    } else {
        return nil;
    }
}

+ (NSURL*)_URLForGravatarWithEmail:(NSString*)email imageSize:(NSString*)imageSize defaultImage:(NSString*)defaultImage {
    if (email) {
        if(!imageSize) {
            imageSize = @"80";
        }

        if(!defaultImage) {
            defaultImage = @"mm";
        }

        NSString *cleanEmail = [[email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        NSString *emailDiggest = [self _md5HexDigest:cleanEmail];
        NSString *gravatarURL = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=%@&d=%@", emailDiggest, imageSize, defaultImage];
        return [NSURL URLWithString:gravatarURL];
    }

    return nil;
}

+ (NSString*)_md5HexDigest:(NSString*)string {
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (unsigned)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

@end
