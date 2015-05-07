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
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWeatherDictionaryZip:) name:ZIP_JSON_DATA_RETURNED_NOTIFICATION object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWeatherDictionaryCity:) name:CITY_JSON_DATA_RETURNED_NOTIFICATION object:self];
    }
    return instance;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Core Fuctions
/*
//To be used later when we implement the NOAA API (CURRENTLY NOT COMPLETE)
- (void) getWeatherFromZip:(NSInteger)zip start:(NSDate *)start end:(NSDate *)end{
    // TODO: Need to format the dates as strings
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
                
                if(error) { 
                    // JSON was malformed, act appropriately here
                }
                
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
                // *day = ;
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
 */


//Gets weather for a city country combination for the next 16 days and uses that to get the weather for the upcoming trip. Country needs to be the two char country code. Takes the data from json and places it into a new dictionary that it passes to a handler to work with. Have not tested yet!
- (void) getWeatherFromCity:(NSString*)city country:(NSString*)country start:(NSDate *)start end:(NSDate *)end
{
    NSString *reformattedCity = [ city stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *WeatherUrl = [NSString stringWithFormat:@"%@q=%@,%@&cnt=16&mode=json&units=imperial", CityWeatherURLData, reformattedCity, country];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"x-api-key"       : CityWeatherAPIKey
                                                   };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    //NSError *error = nil;
    [[session dataTaskWithURL:[NSURL URLWithString:WeatherUrl]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSDictionary *cityWeatherFeatures = [NSJSONSerialization JSONObjectWithData: data
                    options:0
                    error:&error];
                
                if(error) {
                    /* JSON was malformed, act appropriately here */
                }
                
                //Parse CityWeatherFeatures by start end dates and pass new dictionary
                NSDate *today = [NSDate date];
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *duration = [gregorianCalendar components:NSDayCalendarUnit
                                            fromDate:start
                                            toDate:end
                                            options:0];
                NSDateComponents *startday = [gregorianCalendar components:NSDayCalendarUnit
                                            fromDate:today
                                            toDate:start
                                            options:0];
                
                NSMutableArray *weatherArray = [NSMutableArray array];
                NSMutableDictionary *weatherEntry = [NSMutableDictionary dictionary];
                
                __block CGFloat high = 0;
                __block CGFloat low = 0;
                __block CGFloat prec = 0;
                
                NSArray *results = [cityWeatherFeatures objectForKey:@"list"];
                
                NSDate *dateplus1 = start;
                
                NSInteger dateRange = [self daysBetweenDate:start andDate:end];
                NSInteger dateOffset = [self daysBetweenDate:[NSDate date] andDate:start];
                
                for (NSInteger i = dateOffset; i < dateRange; i++)
                {
                    NSDictionary *weatherdict = [results objectAtIndex:i];
                    [weatherdict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        if ([key  isEqualToString:@"temp"])
                        {
                            NSDictionary *tempdict = [weatherdict objectForKey:@"temp"];
                            [tempdict enumerateKeysAndObjectsUsingBlock:^(id key2, id obj2, BOOL *stop2)
                            {
                                if ([key2 isEqualToString:@"min"])
                                {
                                    if ([obj2 isKindOfClass:([NSNumber class])])
                                    {
                                        NSNumber *num = (NSNumber*)obj2;
                                        low = [num floatValue];
                                    }
                                }
                                if ([key2  isEqualToString:@"max"])
                                {
                                    if ([obj2 isKindOfClass:([NSNumber class])])
                                    {
                                        NSNumber *num = (NSNumber*)obj2;
                                        high = [num floatValue];
                                    }
                                }
                            }];
                        }
                        if ([key isEqualToString:@"rain"] && [obj isKindOfClass:[NSNumber class]]) {
                            CGFloat p = [obj doubleValue];
                            
                            if(p > 0 && p <= 1)
                            {
                                prec = .1;
                            }
                            else if (p > 1 && p <= 3)
                            {
                                prec = .3;
                            }
                            else if (p > 3 && p <= 7)
                            {
                                prec = .5;
                            }
                            else if (p > 7)
                            {
                                prec = .8;
                            }
                        }
                    }];
                    //Add weather entry to array
                    [weatherEntry setObject:@(high) forKey:HIGH_KEY];
                    [weatherEntry setObject:@(low) forKey:HIGH_KEY];
                    [weatherEntry setObject:@(prec) forKey:HIGH_KEY];
                    [weatherEntry setObject:dateplus1 forKey:HIGH_KEY];
                    
                    [weatherArray addObject:[weatherEntry copy]];
                    
                    //Increase Date
                    dateplus1 = [start dateByAddingTimeInterval:60*60*24*1];
                    //RESET PARAMETERS
                    prec = 0;

                }
                //Call handler
                [[NSNotificationCenter defaultCenter] postNotificationName:CITY_JSON_DATA_RETURNED_NOTIFICATION object:self userInfo:@{@"data":weatherArray}];
                
            }] resume];
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


//Changing this function to access a new dictionary and collect data from it
- (void) handleWeatherDictionaryCity:(NSMutableDictionary*)dict
{
    NSMutableArray *array = [dict objectForKey:@"data"];
    
    __block NSDate *day;
    __block CGFloat high = 0;
    __block CGFloat low = 0;
    __block CGFloat prec = 0;
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *weatherdict = [array objectAtIndex:i];
        [weatherdict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([key  isEqual: HIGH_KEY]) {
                if ([obj isKindOfClass:([NSNumber class])]) {
                    NSNumber *num = (NSNumber*)obj;
                    high = [num floatValue];
                }
            }
            if ([key  isEqual: LOW_KEY]) {
                if ([obj isKindOfClass:([NSNumber class])]) {
                    NSNumber *num = (NSNumber*)obj;
                    low = [num floatValue];
                }
            }
            if ([key  isEqual: DAY_KEY]) {
                day = obj;
            }
            if ([key  isEqual: PREC_KEY]) {
                if ([obj isKindOfClass:([NSNumber class])]) {
                    NSNumber *num = (NSNumber*)obj;
                    prec = [num floatValue];
                }
            }
            
        }];
        //TODO: addDay with the 4 parameters

    }
}

@end
