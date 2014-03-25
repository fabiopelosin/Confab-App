//
//  MMRoomCellProvider.h
//  Confab App
//
//  Created by Fabio Pelosin on 13/08/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IFBKThirtySeven/IFBKThirtySeven.h>

@interface MMRoomCellProvider : NSObject

- (NSTableCellView*)createTableCellViewForMessage:(IFBKCFMessage*)message;
- (void)configureTableCellView:(NSTableCellView*)cellView ForMessage:(IFBKCFMessage*)message;
- (NSString*)identifierForMessageType:(IFBKMessageType)type;

@end
