//
//  MMDataStackManager.m
//  Confab App
//
//  Created by Fabio Pelosin on 23/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMDataStackManager.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>

@implementation MMDataStackManager

- (void)setUp;
{
  [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@ "MyDatabase.sqlite"];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanUp) name:NSApplicationWillTerminateNotification object:nil];
}

- (void)cleanUp;
{
  [MagicalRecord cleanUp];
}

- (void)dealloc;
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
