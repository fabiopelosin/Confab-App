//
//  NSViewController+DSNSViewController.h
//  Confab App
//
//  Created by Fabio Pelosin on 02/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_OPTIONS(NSUInteger, IRFModalPresentationStyle) {
    IRFModalPresentationFullScreen = 0,
    IRFModalPresentationPageSheet,
    IRFModalPresentationFormSheet,
    IRFModalPresentationCurrentContext,
    IRFModalPresentationCustom,
    IRFModalPresentationNone
};


@protocol IRFNavigationKit <NSObject>

@optional

- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (NSColor*)tintColor;

@end
