//
//  WeatherAPI.h
//  PackManager
//
//  Created by Alex Sanciangco on 5/3/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherReport.h"
#import "WeatherDay.h"

/**
	NSString: Constant notification to be used to call the historical API handler
 */
static NSString *HISTORICAL_JSON_DATA_RETURNED_NOTIFICATION = @"HistoricalJSONDataReturnedNotification";

/**
	NSString: Constant notification to be used to call the present API handler
 */
static NSString *PRESENT_JSON_DATA_RETURNED_NOTIFICATION = @"PresentJSONDataReturnedNotification";

/**
	NSString: Constant key to be used for the weather entries object for high temperature
 */
static NSString *HIGH_KEY = @"high";

/**
	NSString: Constant key to be used for the weather entries object for low temperature
 */
static NSString *LOW_KEY = @"low";

/**
	NSString: Constant key to be used for the weather entries object for precipitation
 */
static NSString *PREC_KEY = @"prec";

/**
	NSString: Constant key to be used for the weather entries object for date of entry
 */
static NSString *DAY_KEY = @"day";

@interface WeatherAPI : NSObject

#pragma mark Main Functions

/**
 * Get the shared instance
 *@returns a shared instance of the WeatherAPI
 */
+ (instancetype) sharedInstance;

#pragma mark Helper Functions

/**
 * getWeatherReport
 * generates the weather report from a location, start, and end tuple
 * @returns WeatherReport*
 */
- (WeatherReport *) getWeatherReport:(NSString *)location start:(NSDate *)start end:(NSDate *)end;

/**
	Collect the weather data for a present forecast from openweathermap API
	@param lat The trip city latitude
	@param lng The trip city longitude
    @param start The start date of the trip
    @param end The end date of the trip
	@returns void after creating a weather report
 */
- (NSMutableArray *) getWeatherFromPresent:(CGFloat)lat lng:(CGFloat)lng start:(NSDate *)start end:(NSDate *)end;

/**
	Collect the weather data for a present forecast from openweathermap API
	@param zip The zip code of the location
    @param start The start date of the trip
    @param end The end date of the trip
	@returns void after creating a weather report
 */
- (NSMutableArray *) getWeatherFromHistorical:(NSString *)zip start:(NSDate *)start end:(NSDate *)end;

/**
 * getLatLongFromAddress
 * @param address location query entered by client
 * @param lat latitude of the location
 * @param lon longitude of the location
 * @returns void after retrieving the lat/long
 */
- (void) getLatLongFromAddress:(NSString*)address lat:(GLfloat *)lat lon:(GLfloat *)lon;

@end
