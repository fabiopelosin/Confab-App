//
//  MMAuthWindowController.m
//  Confab App
//
//  Created by Fabio Pelosin on 26/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "CFAAuthWindowController.h"
#import <ObjectiveSugar/ObjectiveSugar.h>

@interface CFAAuthWindowController ()
@property NSView *currentView;
@property BOOL wantsProgressIndicator;
@end

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation CFAAuthWindowController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//------------------------------------------------------------------------------
#pragma mark - View lifecycle
//------------------------------------------------------------------------------

- (void)windowDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_webViewProgressStarted:) name:WebViewProgressStartedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_webViewProgressEstimateChanged:) name:WebViewProgressEstimateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_webViewProgressFinished:) name:WebViewProgressFinishedNotification object:nil];

    [self.webView setPolicyDelegate:self];
    [self.webView setFrameLoadDelegate:self];
    [self.webView setDrawsBackground:NO];
    //[self.webView setApplicationNameForUserAgent:@"Confab App"];

    [self.progressIndicator setHidden:TRUE];
    [self.progressIndicator setControlTint:NSGraphiteControlTint];
    [self _loadInitialPage];
}

//------------------------------------------------------------------------------
#pragma mark - IBActions
//------------------------------------------------------------------------------

- (IBAction)continueButtonAction:(NSButton*)sender {
    [sender setHidden:TRUE];
    [self _loadAuthorizationPage];
}

//------------------------------------------------------------------------------
#pragma mark - Mark Loading pages
//------------------------------------------------------------------------------

- (void)_loadInitialPage {
    [self setWantsProgressIndicator:NO];
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"WelcomeMessage" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webView.mainFrame loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:htmlFile]];
}

- (void)_loadAuthorizationPage {
    [self setWantsProgressIndicator:TRUE];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.requestURL];
    [self.webView.mainFrame loadRequest:request];
}

//------------------------------------------------------------------------------
#pragma mark - WebView
//------------------------------------------------------------------------------

#pragma mark WebPolicyDelegate

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener {
    NSURL *url = request.URL;
    NSString *scheme = [url scheme];
    if ([scheme isEqualToString:@"confabapp"]) {
        NSString *query = [url query];
        NSString *temporaryCode = [query split:@"="].lastObject;
        [self setTemporaryCode:temporaryCode];
        [self.delegate authWindowController:self didAuthorizeWithTemporaryCode:temporaryCode];
        [listener ignore];
    };
    [listener use];
}

- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener {
    
}

- (void)webView:(WebView *)webView decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
    
}

- (void)webView:(WebView *)webView unableToImplementPolicyWithError:(NSError *)error frame:(WebFrame *)frame {
    [[NSAlert alertWithError:error] runModal];
}

#pragma mark WebFrameLoadDelegate

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
    NSScrollView *mainScrollView = [frame.frameView.documentView enclosingScrollView];
    [mainScrollView setVerticalScrollElasticity:NSScrollElasticityNone];
    [mainScrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    NSScrollView *mainScrollView = [frame.frameView.documentView enclosingScrollView];
    [mainScrollView setVerticalScrollElasticity:NSScrollElasticityNone];
    [mainScrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
//    [[NSAlert alertWithError:error] runModal];
}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
//    [[NSAlert alertWithError:error] runModal];
}

#pragma mark Notifications

- (void)_webViewProgressStarted:(NSNotification*)notification {
    if([notification object] == self.webView) {
        if (self.wantsProgressIndicator) {
            [self.progressIndicator setMinValue:0];
            [self.progressIndicator setMaxValue:1];
            [self.progressIndicator setDoubleValue:0];
            [self.progressIndicator startAnimation:self];
            [self.progressIndicator setHidden:FALSE];
        }
    }
}

- (void)_webViewProgressEstimateChanged:(NSNotification*)notification {
    if([notification object] == self.webView) {
        [self.progressIndicator setDoubleValue:[self.webView estimatedProgress]];
    }
}

- (void)_webViewProgressFinished:(NSNotification*)notification {
    if([notification object] == self.webView) {
        [self.progressIndicator setDoubleValue:1];
        [self.progressIndicator stopAnimation:self];
        [self.progressIndicator setHidden:TRUE];
    }
}

@end
