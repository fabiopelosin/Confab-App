//
//  MMUserImageCache.m
//  Confab App
//
//  Created by Fabio Pelosin on 23/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "MMUserImageCache.h"

@interface MMUserImageCache ()
@property (nonatomic) NSCache *cache;
@end

@implementation MMUserImageCache

//------------------------------------------------------------------------------
#pragma mark - Initialization
//------------------------------------------------------------------------------

- (id)init {
    self = [super init];
    if (self) {
        _cache = [NSCache new];
    }
    return self;
}

- (NSImage*)imageForUser:(MMUser*)user withSize:(CGFloat)size {
    NSImage *image = [self.cache objectForKey:user.userID];
    if (!image) {
        image = [self _roundedImageForImage:user.avatar withSize:size];
        [self.cache setObject:image forKey:user.userID];
    }

    return image;
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (NSImage*)_roundedImageForImage:(NSImage*)image withSize:(CGFloat)sideSize {
    NSSize size = NSMakeSize(sideSize, sideSize);
    NSImage *result = [[NSImage alloc] initWithSize:size];
    [result lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    NSRect imageFrame = NSMakeRect(0, 0, sideSize, sideSize);
    NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:imageFrame];
    [circlePath addClip];
    [image drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    [result unlockFocus];
    return result;
}

@end
