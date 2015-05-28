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
 Trip object that this packing list refers to.
 */
@property (nonatomic, strong) Trip* trip;

/**
    Initialize a new PackingList object
    @param trip The trip the packing list is for
    @returns a newly intialized object
*/
- (instancetype) initPackingListForTrip:(Trip *)trip;

/**
 Initialize a new demo packing list. This method always returns the exact same packing list.
 @params trip The trip this packing list is attributed to
 */
- (instancetype) initExamplePackingListForTrip:(Trip *)trip;

/**
 Returns a packable item that as at the given index in the PackingList object
 @param index The index of a packable in the PackingList you wish to retrieve
 @returns a packable item at the given index
 */
- (Packable *) getPackableForIndex:(NSInteger)index;

- (void) removeItemForIndex:(NSInteger)index;

- (void) changeQuantityForIndex:(NSInteger)index to:(NSInteger)q;

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
//+ (NSString *) stringForItemType:(PackingItems)item;

/**
 Used for testing, this function will print out the packing list to the console.
 */
- (void) printList;

@end
