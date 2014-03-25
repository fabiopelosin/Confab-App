//
//  ConfabAppTypography.m
//  Confab App
//
//  Created by Fabio Pelosin on 12/11/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "ConfabAppTypography.h"

@implementation ConfabAppTypography

+ (NSDictionary*)defaultAttributes {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setMaximumLineHeight:18.0];
    [paragraphStyle setMinimumLineHeight:18.0];

    NSDictionary *attributes = @{ NSParagraphStyleAttributeName: paragraphStyle,
                                  NSFontAttributeName: [self font],
                                  NSForegroundColorAttributeName:  [self textColor],
                                  };
    return attributes;
}

+ (NSDictionary*)attributesForLink {
    NSDictionary *attributes = @{
                                  NSForegroundColorAttributeName: [NSColor colorWithCalibratedRed:0.264 green:0.399 blue:0.550 alpha:1.000],
                                  NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlinePatternSolid],
                                  NSCursorAttributeName: [NSCursor pointingHandCursor],
                                  };
    return attributes;
}

+ (NSColor*)textColor {
    return [NSColor blackColor];
}

+ (NSColor*)lightTextColor {
    return [NSColor colorWithDeviceRed:0.617 green:0.641 blue:0.629 alpha:1.000];
}

+ (NSColor*)lighterTextColor {
    return [NSColor colorWithDeviceWhite:0.682 alpha:1.000];
}

+ (NSFont*)font {
    return [NSFont fontWithName:@"Helvetica Neue" size:12.0];
}

+ (NSFont*)boldFont {
    return [NSFont fontWithName:@"Helvetica Neue Bold" size:12.0];
}

@end
