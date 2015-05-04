//
//  PackingList.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Trip.h"
#include "Packable.h"

@class Trip;

@interface PackingList : NSObject <NSCoding>

typedef enum PackingItems
{
    SHORT_SLEEVE_SHIRT = 0,
    LONG_SLEEVE_SHIRT,
    FORMAL_SHIRT,
    SHORT_PANT,
    LONG_PANT,
    UNDERWEAR,
    SOCKS,
    SHOES,
    SANDALS,
    SWIMSUIT,
    SUIT,
    DRESS,
    TIE,
    UMBERELLA,
    SUNSCREEN,
    
} PackingItems;

// Initializer
- (instancetype) initPackingListForTrip:(Trip *)trip;

- (id<Packable>) getPackableForIndex:(NSInteger)index;

// Returns number of different types of items.
//
// For instance, if the list has 3 shirts and 5 pants,
// this will return 2 (shirts, pants)
- (NSInteger) getNumberOfUniqueItems;

- (NSInteger) quantityForItemAtIndex:(NSInteger)index;

// Information Hiding! This class will convert it's items'
// names into strings for you
+ (NSString *) stringForItemType:(PackingItems)item;


@end
