//
//  MMImageValueTransformer.m
//  Confab App
//
//  Created by Fabio Pelosin on 19/01/13.
//  Copyright (c) 2013 Fabio Pelosin. MIT License.
//

#import "MMImageValueTransformer.h"

@implementation MMImageValueTransformer

+ (BOOL)allowsReverseTransformation

{

  return YES;

}

+ (Class)transformedValueClass

{

  return [NSData class];

}

- (id)transformedValue:(id)value

{

  NSBitmapImageRep *rep = [[value representations] objectAtIndex: 0];

  NSData *data = [rep representationUsingType: NSPNGFileType

                                   properties: nil];

  return data;

}

- (id)reverseTransformedValue:(id)value

{

  NSImage *uiImage = [[NSImage alloc] initWithData:value];
  return uiImage;
}

@end
