//
//  MMRoomCellProviderInformativeMessageBodyGenerator.h
//  Confab App
//
//  Created by Fabio Pelosin on 02/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMUser.h"

@interface MMRoomCellProviderInformativeMessageBodyGenerator : NSObject
+ (NSString*)bodyForInformativeMessage:(IFBKCFMessage*)message user:(MMUser*)user;
@end
