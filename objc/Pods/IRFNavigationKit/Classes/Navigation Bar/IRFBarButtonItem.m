//
//  IRFBarButtonItem.m
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 21/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import "IRFBarButtonItem.h"

@implementation IRFBarButtonItem

- (id)initWithTitle:(NSString *)title style:(IRFBarButtonItemStyle)style target:(id)target action:(SEL)action {
    self = [super init];
    if (self) {
        _possibleTitles = [[NSMutableSet alloc] initWithObjects:title, nil];
        _style = style;
        _target = target;
        _action = action;
    }
    return self;
}

@end
