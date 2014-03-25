//
//  ConfabAppTypography.h
//  Confab App
//
//  Created by Fabio Pelosin on 12/11/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfabAppTypography : NSObject

+ (NSDictionary*)defaultAttributes;
+ (NSDictionary*)attributesForLink;

+ (NSColor*)textColor;
+ (NSColor*)lightTextColor;
+ (NSColor*)lighterTextColor;

+ (NSFont*)font;
+ (NSFont*)boldFont;

@end
