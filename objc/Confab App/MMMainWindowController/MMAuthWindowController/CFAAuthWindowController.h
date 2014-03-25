//
//  MMAuthWindowController.h
//  Confab App
//
//  Created by Fabio Pelosin on 26/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@protocol CFAAuthWindowControllerDelegate;

/**
 * TODO: confabapp://auth?error=access_denied
 */
@interface CFAAuthWindowController : NSWindowController

@property id<CFAAuthWindowControllerDelegate> delegate;

@property (strong, nonatomic) NSURL *requestURL;

@property NSString *temporaryCode;

///-----------------------------------------------------------------------------
/// IB Outlets
///-----------------------------------------------------------------------------

@property (weak) IBOutlet WebView *webView;

@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@end


@protocol CFAAuthWindowControllerDelegate <NSObject>

@required

- (void)authWindowController:(CFAAuthWindowController*)vc didAuthorizeWithTemporaryCode:(NSString*)temporaryCode;

@end
