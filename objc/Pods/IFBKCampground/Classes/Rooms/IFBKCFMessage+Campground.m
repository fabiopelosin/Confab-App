#import "IFBKCFMessage+Campground.h"

@implementation IFBKCFMessage (Campground)

- (BOOL)isUserGenerated {
    BOOL result;
    switch (self.messageType) {
        case IFBKMessageTypeText:
        case IFBKMessageTypePaste:
        case IFBKMessageTypeTweet:
        case IFBKMessageTypeSound:
        case IFBKMessageTypeUpload:
            result = TRUE;
            break;
        case IFBKMessageTypeAdvertisement:
        case IFBKMessageTypeAllowGuests:
        case IFBKMessageTypeDisallowGuests:
        case IFBKMessageTypeIdle:
        case IFBKMessageTypeKick:
        case IFBKMessageTypeLeave:
        case IFBKMessageTypeEnter:
        case IFBKMessageTypeSystem:
        case IFBKMessageTypeTimestamp:
        case IFBKMessageTypeTopicChange:
        case IFBKMessageTypeUnidle:
        case IFBKMessageTypeLock:
        case IFBKMessageTypeUnlock:
        case IFBKMessageTypeConferenceCreated:
        case IFBKMessageTypeConferenceFinished:
        case IFBKMessageTypeUnknown:
            result = FALSE;
            break;
    }
    return result;
}

- (BOOL)isRoomEvent {
    return ![self isUserGenerated];
}

- (NSString*)roomEventDescriptionWithUser:(NSString*)userName {
    NSString *result;
    switch (self.messageType) {
        case IFBKMessageTypeAdvertisement:
            result = [NSString stringWithFormat:@"Advertisement: %@", self.body];
            break;
        case IFBKMessageTypeAllowGuests:
            result = @"Guest are allowed in the room";
            break;
        case IFBKMessageTypeDisallowGuests:
            result = @"Guest are not allowed in the room";
            break;
        case IFBKMessageTypeSystem:
            result = [NSString stringWithFormat:@"System message: %@", self.body];
            break;
        case IFBKMessageTypeTimestamp:
            result = [NSString stringWithFormat:@"Time stamp: %@", self.body];
            break;
        case IFBKMessageTypeTopicChange:
            result = [NSString stringWithFormat:@"Room topic changed: %@", self.body];
            break;
        case IFBKMessageTypeLock:
            result = @"Room locked";
            break;
        case IFBKMessageTypeUnlock:
            result = @"Room unlocked";
            break;
        case IFBKMessageTypeConferenceCreated:
            result = @"Conference started";
            break;
        case IFBKMessageTypeConferenceFinished:
            result = @"Conference finished";
            break;

        case IFBKMessageTypeIdle:
            result = [NSString stringWithFormat:@"%@ became idle", userName];
            break;
        case IFBKMessageTypeKick:
            result = [NSString stringWithFormat:@"%@ was kicked from the room", userName];
            break;
        case IFBKMessageTypeLeave:
            result = [NSString stringWithFormat:@"%@ left the room", userName];
            break;
        case IFBKMessageTypeEnter:
            result = [NSString stringWithFormat:@"%@ entered the room", userName];
            break;
        case IFBKMessageTypeUnidle:
            result = [NSString stringWithFormat:@"%@ is not idle anymore", userName];
            break;

        case IFBKMessageTypeUnknown:
            result = self.body;
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Expected room event message"];
    }

    result = NSLocalizedStringFromTable(result, @"IFBKCampground", nil);
    return result;
}

@end
