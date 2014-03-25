//
//  CFUser.h
//  Confab App
//
//  Created by Fabio Pelosin on 31/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MMUser : NSManagedObject

@property (nonatomic, retain) NSNumber * admin;
@property (nonatomic, retain) id avatar;
@property (nonatomic, retain) NSString * avatarURL;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * userID;

@end
