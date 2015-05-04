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

/**
  Class that represents a list of packing items and adds some convenience methods
*/
@interface PackingList : NSObject <NSCoding>

/**
    An enumeration of packing items (i.e. shirts, pants, etc)
*/
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

/**
    Initialize a new PackingList object
    @param trip The trip the packing list is for
    @returns a newly intialized object
*/
- (instancetype) initPackingListForTrip:(Trip *)trip;

/**
 Returns a packable item that as at the given index in the PackingList object
 @param index The index of a packable in the PackingList you wish to retrieve
 @returns a packable item at the given index
 */
- (id<Packable>) getPackableForIndex:(NSInteger)index;

/**
    Returns number of different types of items
    For instance, if the list has 3 shirts and 5 pants, this will return 2 (shirts, pants)
    @returns an integer representing the number of unique items
*/
- (NSInteger) getNumberOfUniqueItems;

/**
    Returns the number of items at a specific index
    For instance, 5 socks at index 6. 
    @param index The index to examine
    @returns an integer representing the quantity of items at given index
*/
- (NSInteger) quantityForItemAtIndex:(NSInteger)index;

/**
  Information Hiding! This class will convert it's items'
  names into strings for you
  @param item A packing item
  @returns a string representation of the given item
*/
+ (NSString *) stringForItemType:(PackingItems)item;


@end
