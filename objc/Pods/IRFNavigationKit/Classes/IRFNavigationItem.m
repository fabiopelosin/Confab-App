//
//  IRFNavigationItem.m
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 21/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import "IRFNavigationItem.h"

@implementation IRFNavigationItem

- (id)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = title;
    }
    return self;
}

- (void)setRightBarButtonItem:(IRFBarButtonItem *)item animated:(BOOL)animated {
    [self setRightBarButtonItem:item];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p title:%@>", NSStringFromClass(self.class), self, self.title];
}

@end
