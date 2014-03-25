//
//  MMUserImageProvider.h
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMUser.h"

/**
 */
extern NSString *const kMMUserImageProviderImageUpdateNotification;

/**
 */
@interface MMUserImageProvider : NSObject

/**
 */
+ (void)loadImageForUser:(MMUser*)user;

@end
