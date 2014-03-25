//
//  MMFixedTextField.h
//  Confab App
//
//  Created by Fabio Pelosin on 23/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * TextFiled which provides support for calculating the -intrinsicContentSize 
 * given a preferred max layout withd.
 */
@interface MMFixedTextField : NSTextView

@property (nonatomic) CGFloat preferredMaxLayoutWidth;

@end
