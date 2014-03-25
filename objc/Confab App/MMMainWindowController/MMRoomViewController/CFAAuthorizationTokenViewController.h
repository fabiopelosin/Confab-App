//
//  CFAAuthorizationTokenViewController.h
//  Confab App
//
//  Created by Fabio Pelosin on 15/11/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CFAAuthorizationTokenViewControllerDelegate;

@interface CFAAuthorizationTokenViewController : NSViewController

@property (nonatomic, copy) NSURL *campfireSubdomain;

@property (nonatomic, weak) id<CFAAuthorizationTokenViewControllerDelegate> delegate;

@property (weak) IBOutlet NSTextField *tokenTextField;

@end

///-----------------------------------------------------------------------------
///-----------------------------------------------------------------------------

@protocol CFAAuthorizationTokenViewControllerDelegate <NSObject>

@required

- (void)authorizationTokenViewController:(CFAAuthorizationTokenViewController*)vc wasDismissidedWithToken:(NSString*)token;

@end
