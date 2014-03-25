//
//  MMTableCellHeighManager.h
//  Confab App
//
//  Created by Fabio Pelosin on 23/09/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IFBKThirtySeven/IFBKThirtySeven.h>

/**
 Returns the height for the cell of the given message taking into account the
 cell type.
 
 Notes:

 - The sample cells are cached.
 - The heights are chached and change only if the width changes.
 */
@interface MMTableCellHeighManager : NSObject

- (CGFloat)cellHeightForMessage:(IFBKCFMessage*)message withWidth:(CGFloat)width;

@end
