//
//  PackingList.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Trip.h"

@interface PackingList : NSObject <NSCoding>

typedef enum PackingItems
{
    SHORT_SLEEVE_SHIRT,
    LONG_SLEEVE_SHIRT,
    FORMAL_SHIRT,
    SHORT_PANT,
    LONG_PANT,
    SWIMSUIT,
    SUIT,
    DRESS,
    TIE,
    
} PackingItems;

// Initializer
- (instancetype) initPackingListForTrip:(Trip *)trip;

// Returns number of different types of items.
//
// For instance, if the list has 3 shirts and 5 pants,
// this will return 2 (shirts, pants)
- (NSInteger) getNumberOfUniqueItems;


// Information Hiding! This class will convert it's items'
// names into strings for you
- (NSString *) stringForItemType:(PackingItems)item;


@end
