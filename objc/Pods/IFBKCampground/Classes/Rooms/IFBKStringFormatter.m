#import "IFBKStringFormatter.h"
#import <IRFEmojiCheatSheet/IRFEmojiCheatSheet.h>
#import <twitter-text-objc/TwitterText.h>
#import <QuartzCore/QuartzCore.h>


@implementation IFBKStringFormatter

// http://developer.apple.com/library/mac/#qa/qa2006/qa1487.html
- (NSAttributedString*)attributedStringForMessageBody:(NSString*)body {
    NSMutableAttributedString* attributedHTML = [[NSMutableAttributedString alloc] initWithString:body attributes:self.defaultAttributes];
    attributedHTML = [self _replaceEmojis:attributedHTML];

    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeLink error:nil];
    NSArray *matches = [linkDetector matchesInString:[attributedHTML string] options:0 range:NSMakeRange(0, [[attributedHTML string] length])];
    for (NSTextCheckingResult *match in matches) {
        NSDictionary *attributes = [self _attributesForLinkWithURL:match.URL.absoluteString];
        [attributedHTML addAttributes:attributes range:match.range];
    }
    return attributedHTML;
}

- (NSAttributedString*)attributedStringForTweetWithBody:(NSString*)body {
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:body attributes:self.defaultAttributes];
    NSArray *entities = [TwitterText entitiesInText:body];

    for (TwitterTextEntity *entity in entities) {
        NSString *substring = [body substringWithRange:entity.range];
        NSString *url;
        switch (entity.type) {
            case TwitterTextEntityHashtag:
                url = [NSString stringWithFormat:@"https://twitter.com/search?q=%@&src=hash", [substring stringByReplacingOccurrencesOfString:@"#" withString:@"%23"]];
                break;
            case TwitterTextEntitySymbol:
                url = [NSString stringWithFormat:@"https://twitter.com/search?q=%@&src=ctag", [substring stringByReplacingOccurrencesOfString:@"$" withString:@"%24"]];
                break;
            case TwitterTextEntityListName:
            case TwitterTextEntityScreenName:
                url = [NSString stringWithFormat:@"https://twitter.com/%@", [substring stringByReplacingOccurrencesOfString:@"@" withString:@""]];
                break;
            case TwitterTextEntityURL:
                url = substring;
                break;

        }
        NSDictionary *attributes = [self _attributesForLinkWithURL:url];
        [attributed addAttributes:attributes range:entity.range];
    }

    return attributed;
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (NSMutableAttributedString*)_replaceEmojis:(NSMutableAttributedString*)string {
    if ([[string string] rangeOfString:@":"].location == NSNotFound) {
		return string;
	}

    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"(:[a-z0-9-+_]+:)" options:NSRegularExpressionCaseInsensitive error:NULL];
	NSArray *matches = [regex matchesInString:[string string] options:0 range:NSMakeRange(0, [string length])];

	NSMutableAttributedString *emojiString = [string mutableCopy];

	// Loop through matches in reverse order so the ranges won't be affected
	for (NSTextCheckingResult *checkingResult in [matches reverseObjectEnumerator]) {


        NSString *match = [[string string] substringWithRange:checkingResult.range];
        NSString *alias = [match stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSString *emojiCharacter = [IRFEmojiCheatSheet emojisByAlias][alias];
        if (emojiCharacter) {
			[emojiString replaceCharactersInRange:checkingResult.range withString:emojiCharacter];
        }
	}

    return emojiString;
};

- (NSDictionary*)_attributesForLinkWithURL:(NSString*)url {
    NSMutableDictionary *attributes = [self.attributesForLink mutableCopy];
    [attributes setObject:url forKey:NSLinkAttributeName];
    return attributes;
}


@end
