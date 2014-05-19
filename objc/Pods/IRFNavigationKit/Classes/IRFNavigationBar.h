#import <Cocoa/Cocoa.h>
#import "IRFNavigationBarProtocol.h"

@class IRFNavigationItem;
@protocol IRFNavigationBarDelegate;

/**
 *
 */
@interface IRFNavigationBar : NSView <IRFNavigationBarProtocol>

///-----------------------------------------------------------------------------
/// @name Customizing the Bar Appearance
///-----------------------------------------------------------------------------

@property(nonatomic, retain) NSColor *barTintColor;

@property(nonatomic, retain) NSColor *tintColor;

@property(nonatomic, copy) NSDictionary *titleTextAttributes;

@end
