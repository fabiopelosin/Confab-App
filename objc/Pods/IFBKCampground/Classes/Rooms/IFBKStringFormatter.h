#import <Foundation/Foundation.h>

@interface IFBKStringFormatter : NSObject

@property NSDictionary *defaultAttributes;

@property NSDictionary *attributesForLink;

- (NSAttributedString*)attributedStringForMessageBody:(NSString*)body;

- (NSAttributedString*)attributedStringForTweetWithBody:(NSString*)body;

@end
