//
//  MMUserImageCache.h
//  Confab App
//
//  Created by Fabio Pelosin on 23/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMUser.h"

@interface MMUserImageCache : NSObject

- (NSImage*)imageForUser:(MMUser*)user withSize:(CGFloat)size;

@end
