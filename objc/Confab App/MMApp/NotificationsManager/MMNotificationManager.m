//
//  MMNotificationManager.m
//  Confab App
//
//  Created by Fabio Pelosin on 22/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMNotificationManager.h"

@implementation MMNotificationManager

+ (MMNotificationManager *)sharedManager {
    static MMNotificationManager *_sharedManager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
        return self;
    }
    return nil;
}

+ (NSArray*)availableSoundNames {
    NSString *systemSoundsPath = @"/System/Library/Sounds";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:systemSoundsPath error:nil];
    NSMutableArray *names = [NSMutableArray new];
    [contents enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
        if ([fileName rangeOfString:@".aiff"].location != NSNotFound) {
            NSString *name = [fileName stringByReplacingOccurrencesOfString:@".aiff" withString:@""];
            [names addObject:name];
        }
    }];
    return names;
}

- (void)showNotificationForMessage:(IFBKCFMessage*)message user:(MMUser*)user room:(IFBKCFRoom*)room {
    NSString *title;
    NSString *informative;

    switch (message.messageType) {
        case IFBKMessageTypeText:
        case IFBKMessageTypePaste:
        {
            title = [NSString stringWithFormat:@"%@\n%@", user.name, room];
            informative = message.body;
            break;
        }

        case IFBKMessageTypeTweet:
        case IFBKMessageTypeSound:
        case IFBKMessageTypeUpload:
        {
            title = [NSString stringWithFormat:@"%@ - %@", user.name, room];
            informative = message.type;
            break;
        }

        default:
        {
            break;
        }
    }

    if (title && informative) {
        [self showNotificationWithTitle:title informative:informative image:user.avatar];
    }
}


//------------------------------------------------------------------------------
#pragma mark - NSUserNotificationCenterDelegate
//------------------------------------------------------------------------------

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}


//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (void)showNotificationWithTitle:(NSString*)title informative:(NSString*)informative image:(NSImage*)image {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = title;
    notification.informativeText = informative;
    notification.soundName = [self soundName];
    if ([notification respondsToSelector:@selector(setContentImage:)]) {
        [notification setContentImage:image];
    }
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}


- (NSString*)soundName {
    return @"Purr";
    return NSUserNotificationDefaultSoundName;
}

@end






