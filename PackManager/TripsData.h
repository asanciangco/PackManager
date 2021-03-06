//
//  TripsData.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

/**
	Adds some convenience methods to TripsData
*/
@interface TripsData : NSObject <NSCoding>

/**
	Returns a shared instance
	@returns a shared TripsData instance
*/
+ (instancetype) sharedInstance;

/**
	Returns the number of trips 
	@returns an integer representing the number of trips
*/
- (NSInteger) numberOfTrips;

/**
	Returns a trip at a given index
	@param index Index of trip
	@returns A trip object
*/
- (Trip *) getTrip:(NSInteger)index;

/**
 Adds a new trip to the list of trips. It will be added in chronological order.
 @param newTrip The trip to add
 */
- (void) addTrip:(Trip *)newTrip;

/**
 Removes trip at the given index of list of trips.
 @param index The index of the trip to remove
 */
- (void) removeTripAtIndex:(NSInteger)index;

@end
