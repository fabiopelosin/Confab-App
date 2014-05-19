//
//  IRFNavigationBarDelegate.h
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 21/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IRFNavigationBarDelegate <NSObject>

@optional

- (BOOL)navigationBar:(IRFNavigationBar *)navigationBar shouldPushItem:(IRFNavigationItem *)item;

- (void)navigationBar:(IRFNavigationBar *)navigationBar didPushItem:(IRFNavigationItem *)item;

- (BOOL)navigationBar:(IRFNavigationBar *)navigationBar shouldPopItem:(IRFNavigationItem *)item;

- (void)navigationBar:(IRFNavigationBar *)navigationBar didPopItem:(IRFNavigationItem *)item;

@end
