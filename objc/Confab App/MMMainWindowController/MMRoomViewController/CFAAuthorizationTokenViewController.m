//
//  CFAAuthorizationTokenViewController.m
//  Confab App
//
//  Created by Fabio Pelosin on 15/11/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "CFAAuthorizationTokenViewController.h"

@interface CFAAuthorizationTokenViewController ()

@end

@implementation CFAAuthorizationTokenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (NSString *)title {
    return @"Authorization Token request";
}

- (NSColor*)tintColor {
    return [NSColor colorWithCalibratedRed:0.123 green:0.660 blue:0.152 alpha:1.000];
}

- (IBAction)openLink:(id)sender {
    NSURL *url = [self.campfireSubdomain URLByAppendingPathComponent:@"/member/edit"];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)setTokenAction:(id)sender {
    NSString *token = [self.tokenTextField stringValue];
    [self.delegate authorizationTokenViewController:self wasDismissidedWithToken:token];
}

@end
