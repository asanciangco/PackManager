//
//  WeatherAPI.h
//  PackManager
//
//  Created by Alex Sanciangco on 5/3/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherReport.h"
/**
	NSString: Constant notification to be used to call the historical API handler
 */
static NSString *ZIP_JSON_DATA_RETURNED_NOTIFICATION = @"HistoricalJSONDataReturnedNotification";

/**
	NSString: Constant notification to be used to call the present API handler
 */
static NSString *CITY_JSON_DATA_RETURNED_NOTIFICATION = @"PresentJSONDataReturnedNotification";

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

// Get the shared instance //
/////////////////////////////

/**
    Get the shared instance
    @returns a shared instance of the WeatherAPI
*/
+ (instancetype) sharedInstance;

//Function to get Weather Based On Zip
//- (void) getWeatherFromHistorical:(NSInteger)zip start:(NSDate *)start end:(NSDate *)end;


/**
	Collect the weather data for a present forecast from openweathermap API
	@param city The trip city location
	@param country The two letter country ID
    @param start The start date of the trip
    @param end The end date of the trip
	@returns void after creating a weather report
 */
- (void) getWeatherFromPresent:(NSString*)city country:(NSString*)country start:(NSDate *)start end:(NSDate *)end;



@end
