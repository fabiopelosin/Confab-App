//
//  IRFBarButtonItem.h
//  IRFNavigationKit
//
//  Created by Fabio Pelosin on 21/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IRFBarButtonItemStyle) {
    IRFBarButtonItemStylePlain,
    IRFBarButtonItemStyleBordered,
};


@class NSImage, NSView;

@interface IRFBarButtonItem : NSObject

//- (id)initWithImage:(UIImage *)image style:(IRFBarButtonItemStyle)style target:(id)target action:(SEL)action;
//- (id)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(IRFBarButtonItemStyle)style target:(id)target action:(SEL)action NS_AVAILABLE_IOS(5_0); // landscapeImagePhone will be used for the bar button image in landscape bars in UIUserInterfaceIdiomPhone only
- (id)initWithTitle:(NSString *)title style:(IRFBarButtonItemStyle)style target:(id)target action:(SEL)action;
//- (id)initWithCustomView:(UIView *)customView;

@property(nonatomic)         IRFBarButtonItemStyle style;            // default is IRFBarButtonItemStylePlain
                                                                     //@property(nonatomic)         CGFloat              width;            // default is 0.0
@property(nonatomic,copy)    NSSet               *possibleTitles;   // default is nil
                                                                    //@property(nonatomic,retain)  UIView              *customView;       // default is nil
@property(nonatomic)         SEL                  action;           // default is NULL
@property(nonatomic,assign)  id                   target;           // default is nil

@property(nonatomic,retain) NSColor *tintColor;

@end
