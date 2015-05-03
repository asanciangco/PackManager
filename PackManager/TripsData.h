//
//  TripsData.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

@interface TripsData : NSObject <NSCoding>

// Get the shared instance //
/////////////////////////////
+ (instancetype) sharedInstance;

- (NSInteger) numberOfTrips;
- (Trip *) getTrip:(NSInteger)index;

@end
