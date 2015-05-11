//
//  WeatherAPI.h
//  PackManager
//
//  Created by Alex Sanciangco on 5/3/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherReport.h"

static NSString *ZIP_JSON_DATA_RETURNED_NOTIFICATION = @"ZipJSONDataReturnedNotification";

static NSString *CITY_JSON_DATA_RETURNED_NOTIFICATION = @"CityJSONDataReturnedNotification";

static NSString *HIGH_KEY = @"high";
static NSString *LOW_KEY = @"low";
static NSString *PREC_KEY = @"prec";
static NSString *DAY_KEY = @"day";

@interface WeatherAPI : NSObject

// Get the shared instance //
/////////////////////////////
+ (instancetype) sharedInstance;

//Function to get Weather Based On Zip
//- (void) getWeatherFromZip:(NSInteger)zip start:(NSDate *)start end:(NSDate *)end;

- (void) getWeatherFromPresent:(NSString*)city country:(NSString*)country start:(NSDate *)start end:(NSDate *)end;



@end
