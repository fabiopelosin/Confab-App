//
//  MMNetworkStackManager.m
//  Confab App
//
//  Created by Fabio Pelosin on 23/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMNetworkStackManager.h"
//#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>

@implementation MMNetworkStackManager

- (void)setUp;
{
  NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:[NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), [[NSProcessInfo processInfo] processName]]];
  [NSURLCache setSharedURLCache:URLCache];

  //[[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelWarn];
  //[[AFNetworkActivityLogger sharedLogger] startLogging];
}

@end
