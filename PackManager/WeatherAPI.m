//
//  WeatherAPI.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/3/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "WeatherAPI.h"

static WeatherAPI *sharedInstance;

static NSString *ZipWeatherAPIKey = @"FgFYQJXIFJwfhPAWbARqFNwPqdokgUeC";
static NSString *CityWeatherAPIKey = @"1412e64aff4c8a2d7411980f8568efd2";

static NSString *ZipWeatherURLData = @"http://www.ncdc.noaa.gov/cdo-web/api/v2/data?";

static NSString *ZipWeatherURLLocation = @"http://www.ncdc.noaa.gov/cdo-web/api/v2/locations?";

static NSString *CityWeatherURLData = @"http://api.openweathermap.org/data/2.5/forecast/daily?";

static NSString *CityWeatherURLLocation = @"http://api.openweathermap.org/data/2.5/find?";

@implementation WeatherAPI

// Get the shared instance //
/////////////////////////////
#pragma mark - Accessing sharedInstance
+ (instancetype) sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [WeatherAPI initWithDefaults];
    }
    return sharedInstance;
}

+ (instancetype) initWithDefaults
{
    WeatherAPI *instance;
    
    if ((instance = [[WeatherAPI alloc] init]))
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWeatherDictionaryZip:) name:ZIP_JSON_DATA_RETURNED_NOTIFICATION object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWeatherDictionaryZip:) name:CITY_JSON_DATA_RETURNED_NOTIFICATION object:self];
    }
    return instance;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Core Fuctions

- (void) getWeatherFromZip:(NSInteger)zip start:(NSDate *)start end:(NSDate *)end{
    NSString *WeatherUrl = [NSString stringWithFormat:@"%@datasetid=GHCND&locationid=ZIP:%@&startdate=%@&enddate=%@&sortfield", ZipWeatherURLData, zip, start, end];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"token"       : ZipWeatherAPIKey
                                                   };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSError *error = nil;
    [[session dataTaskWithURL:[NSURL URLWithString:WeatherUrl]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSDictionary *ZipWeatherFeatures = [NSJSONSerialization JSONObjectWithData:response
                    options:0
                    error:&error];
                
                if(error) { /* JSON was malformed, act appropriately here */ }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ZIP_JSON_DATA_RETURNED_NOTIFICATION object:self userInfo:ZipWeatherFeatures];
                
            }] resume];
}

//need to figure out how to collect data from this crazy API
- (void) handleWeatherDictionaryZip:(NSDictionary*)dict
{
    NSDate *day;
    CGFloat high;
    CGFloat low;
    CGFloat prec;
    
    NSArray *results = [dict objectForKey:@"results"];
    for (int i = 0; i < [results count]; i++) {
        NSDictionary *tempdict = [results objectAtIndex:i];
        [tempdict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([key  isEqual: @"date"]) {
                //Set Date
                //*day = ;
            }
            if ([key  isEqual: @"datatype"]) {
                if ([obj  isEqual: @"PRCP"]) {
                    //Set prec based on key "value"
                }
            }
            if ([key  isEqual: @"datatype"]) {
                if ([obj  isEqual: @"TMAX"]) {
                    //Set high based on key "value"
                }
            }
            if ([key  isEqual: @"datatype"]) {
                if ([obj  isEqual: @"TMIN"]) {
                    //Set low based on key "value"
                }
            }
        }];
        
    }
}

//Still need to figure out how to parse json to only collect the number of days needed, also need to ensure the date of trip is captured by the forecast (0> end_of_trip > 16)
- (void) getWeatherFromCity:(NSString*)city country:(NSString*)country start:(NSDate *)start end:(NSDate *)end
{
    NSString *reformattedCity = [ city stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *WeatherUrl = [NSString stringWithFormat:@"%@q=%@,%@&cnt=16&mode=json&units=imperial", CityWeatherURLData, reformattedCity, country];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"x-api-key"       : CityWeatherAPIKey
                                                   };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSError *error = nil;
    [[session dataTaskWithURL:[NSURL URLWithString:WeatherUrl]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSDictionary *CityWeatherFeatures = [NSJSONSerialization JSONObjectWithData:response
                    options:0
                    error:&error];
                
                if(error) { /* JSON was malformed, act appropriately here */ }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:CITY_JSON_DATA_RETURNED_NOTIFICATION object:self userInfo:CityWeatherFeatures];
                
            }] resume];
}


//Get Min, Max, Day, and Prec from json object of all 16 gathered days
- (void) handleWeatherDictionaryCity:(NSDictionary*)dict
{
    NSDate *day = [NSDate date];
    CGFloat high;
    CGFloat low;
    CGFloat prec;
    
    NSArray *results = [dict objectForKey:@"list"];
    for (int i = 0; i < [results count]; i++) {
        NSDate *dateplus1 = [day dateByAddingTimeInterval:60*60*24*1];
        day = dateplus1;
        prec = 0;
        NSDictionary *weatherdict = [results objectAtIndex:i];
        [weatherdict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([key  isEqual: @"temp"]) {
                NSDictionary *tempdict = [results objectAtIndex:i];
                [tempdict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([key  isEqual: @"min"]) {
                       __block low = obj;
                    }
                    if ([key  isEqual: @"max"]) {
                        __block high = obj;
                    }
                }];
            }
            if ([key  isEqual: @"rain"]) {
                if(obj > 0 && obj <= 1)
                {
                    __block prec = .1;
                }
                else if (obj > 1 && obj <= 3)
                {
                    __block prec = .3;
                }
                else if (obj > 3 && obj <= 7)
                {
                    __block prec = .5;
                }
                else if (obj > 7)
                {
                    __block prec = .8;
                }
            }
        }];
        //TODO: addDay with the 4 parameters
        //THEN RESET PARAMETERS
        //Right now this function only returns the 16 future days. It doesnt consider the date of the trip
    }
}

@end
