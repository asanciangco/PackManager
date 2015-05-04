//
//  WeatherReport.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherReport : NSObject

// Returns highest temp for entire report
- (NSInteger) getOverallHigh;   // to float

// Returns lowest temp for entire report
- (NSInteger) getOverallLow;    // to float

// returns number of days in this weather report
- (NSInteger) numberOfDays;

// to floats
// return high/low temp for given day of trip
- (NSInteger) getHighForDay:(NSInteger)day; // 1-indexed, so '1' for day 1
- (NSInteger) getLowForDay:(NSInteger)day;  // 1-indexed, so '1' for day 1

/**
 Returns whether or not the individual WeatherDays are in chronological order
 */
- (BOOL) daysAreInOrder;

/**
 Sort the WeatherDay objects chronologically
 */
- (void) putDaysInOrder;

@end
