//
//  WeatherReport.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherDay.h"

/**
	Class representing a WeatherReport
*/
@interface WeatherReport : NSObject <NSCoding>

/**
 Generates example report for demo purposes.
 */
- (instancetype) initExampleReport;

/**
   Returns highest temp for entire report
   @returns returns integer representing the report's high
*/
- (NSInteger) getOverallHigh;

/**
   Returns lowest temp for entire report
   @returns returns integer representing the report's low
*/
- (NSInteger) getOverallLow;

/**
	Returns number of days in this weather report
	@returns returns integer representing number of days in report
*/
- (NSInteger) numberOfDays;

// to floats
// return high/low temp for given day of trip
/**
	Returns the high temp for a given day
	@param day The day to check for the high
	@returns an integer representing the day's high
*/
- (NSInteger) getHighForDay:(NSInteger)day; // 1-indexed, so '1' for day 1

/**
	Returns the low temp for a given day
	@param day The day to check for the low
	@returns an integer representing the day's low
*/
- (NSInteger) getLowForDay:(NSInteger)day;  // 1-indexed, so '1' for day 1

/**
	Returns the average temp for a given day
	@param day The day to check for the average
	@returns an integer representing the day's average
 */
- (NSInteger) getAverageForDay: (NSInteger)day;

/**
	Returns the range temp for a given day
	@param day The day to check for the range
	@returns an integer representing the day's range
 */
- (NSInteger) getRangeForDay: (NSInteger)day;

/**
 Returns whether or not the individual WeatherDays are in chronological order
 */
- (BOOL) daysAreInOrder;

/**
 Sort the WeatherDay objects chronologically
 */
- (void) putDaysInOrder;

/**
 Add a day to the report
 @param day The day to add
 */
- (void) addDay:(WeatherDay *)day;

@end
