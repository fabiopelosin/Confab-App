//
//  MMFixedTextField.m
//  Confab App
//
//  Created by Fabio Pelosin on 23/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMFixedTextField.h"

@implementation MMFixedTextField

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    [self invalidateIntrinsicContentSize];
}

// Apparently the text container doesn't return a perfect size
- (NSSize)intrinsicContentSize {
    NSTextContainer* textContainer = [self textContainer];
    NSLayoutManager* layoutManager = [self layoutManager];
    [textContainer setContainerSize:NSMakeSize(self.preferredMaxLayoutWidth, FLT_MAX)];
    [layoutManager ensureLayoutForTextContainer: textContainer];
    NSSize size = [layoutManager usedRectForTextContainer: textContainer].size;
    size.width = self.preferredMaxLayoutWidth;
    return size;
}

@end
