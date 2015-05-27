//
//  WeatherAPI.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/3/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "WeatherAPI.h"

static WeatherAPI *sharedInstance;

static NSString *HistoricalWeatherAPIKey = @"FgFYQJXIFJwfhPAWbARqFNwPqdokgUeC";
static NSString *PresentWeatherAPIKey = @"1412e64aff4c8a2d7411980f8568efd2";
static NSString *GoogleAPIKey = @"AIzaSyDUwWOuEWRMEHuXuQVwNbUkzXSpxgpyJoA";

static NSString *HistoricalWeatherURLData = @"http://www.ncdc.noaa.gov/cdo-web/api/v2/data?";

static NSString *HistoricalWeatherURLLocation = @"http://www.ncdc.noaa.gov/cdo-web/api/v2/locations?";

static NSString *PresentWeatherURLData = @"http://api.openweathermap.org/data/2.5/forecast/daily?";

static NSString *PresentWeatherURLLocation = @"http://api.openweathermap.org/data/2.5/find?";

static NSString *GoogleLatLongURL = @"https://maps.googleapis.com/maps/api/geocode/json?";

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
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWeatherDictionaryHistorical:) name:HISTORICAL_JSON_DATA_RETURNED_NOTIFICATION object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWeatherDictionaryPresent:) name:PRESENT_JSON_DATA_RETURNED_NOTIFICATION object:self];
    }
    return instance;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Core Fuctions

- (void) getLatLongFromAddress:(NSString*)address start:(NSDate *)start end:(NSDate *)end
{
    //Get URL search string with + instead of space
    NSString *reformattedAddress = [ address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *LatLongUrl = [NSString stringWithFormat:@"%@address=%@&key=%@", GoogleLatLongURL, reformattedAddress, GoogleAPIKey];
    
    //Check which API to use based on number of days until end of trip
    NSInteger daysNeeded = [self daysBetweenDate:[NSDate date] andDate:end];
    bool presentForecast = daysNeeded >= 15;
    // bool historicalForeast = !presentForecast; //unused
  
    CGFloat lat = 0;
    CGFloat lon = 0;

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:LatLongUrl]];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse* response;
    NSError* error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    NSDictionary *cityLatLong = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
            
    if(error) {
        return; /* do nothing */
    }
    
    NSArray *results = [cityLatLong objectForKey:@"results"];
    NSDictionary *resultDict = [results objectAtIndex:0];
    
    if(resultDict && resultDict[@"geometry"] && resultDict[@"geometry"][@"location"]) {
        NSDictionary *loc = resultDict[@"geometry"][@"location"];
        lat = [loc[@"lat"] floatValue];
        lon = [loc[@"lng"] floatValue];
    }

    //[[WeatherAPI sharedInstance]getWeatherFromPresent:&lat lng:&lon start:start end:end];
}


//Gets weather for a city country combination for the next 16 days and uses that to get the weather for the upcoming trip. Country needs to be the two char country code. Takes the data from json and places it into a new dictionary that it passes to a handler to work with. Have not tested yet!
- (void) getWeatherFromPresent:(CGFloat*)lat lng:(CGFloat*)lng start:(NSDate *)start end:(NSDate *)end
{
    NSString *WeatherUrl = [NSString stringWithFormat:@"%@lat=%f&lon=%f&cnt=16&mode=json&units=imperial", PresentWeatherURLData, lat, lng];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:WeatherUrl]];
    [request setHTTPMethod:@"GET"];
    [request addValue:PresentWeatherAPIKey forHTTPHeaderField:@"x-api-key"];
    
    NSURLResponse* response;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
        // handle response
    NSDictionary *cityWeatherFeatures = [NSJSONSerialization JSONObjectWithData: data
        options:0
        error:&error];
    
    if(error) {
        return; /* JSON was malformed, act appropriately here */
    }
    NSMutableArray *weatherArray = [self parseJSONforPresent:cityWeatherFeatures start:start end:end];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_JSON_DATA_RETURNED_NOTIFICATION object:self userInfo:@{@"data":weatherArray}];
}


/**
	Given the json object, returns an array of the forecast for the days of the trip
	@param weather The json object collected from the api
	@param start The start date of the trip
    @param end The end date of the trip
	@returns NSMutableArray of weather forecast for the days of the trip
 */
- (NSMutableArray*) parseJSONforPresent:(NSDictionary *)weather start:(NSDate *)start end:(NSDate *)end
{
    //Parse PresentWeatherFeatures by start end dates and pass new dictionary
    NSMutableArray *weatherArray = [NSMutableArray array];
    NSMutableDictionary *weatherEntry = [NSMutableDictionary dictionary];
    
    CGFloat high = 0;
    CGFloat low = 0;
    CGFloat prec = 0;
    
    NSArray *results = [weather objectForKey:@"list"];
    
    NSDate *dateplus1 = start;
    
    NSInteger dateRange = [self daysBetweenDate:start andDate:end];
    NSInteger dateOffset = [self daysBetweenDate:[NSDate date] andDate:start];
    
    for (NSInteger i = dateOffset; i <= dateOffset + dateRange; i++)
    {
        NSDictionary *weatherdict = [results objectAtIndex:i];
        
        if (weatherdict[@"temp"]) {
            low = [weatherdict[@"temp"][@"min"] floatValue];
            high = [weatherdict[@"temp"][@"max"] floatValue];
        }
        
        if (weatherdict[@"rain"]) {
            CGFloat p = [weatherdict[@"rain"] floatValue];
            
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
        
        //Add weather entry to array
        [weatherEntry setObject:@(high) forKey:HIGH_KEY];
        [weatherEntry setObject:@(low) forKey:LOW_KEY];
        [weatherEntry setObject:@(prec) forKey:PREC_KEY];
        [weatherEntry setObject:dateplus1 forKey:DAY_KEY];
        
        [weatherArray addObject:[weatherEntry copy]];
        
        //Increase Date
        dateplus1 = [start dateByAddingTimeInterval:60*60*24*1];
        //RESET PARAMETERS
        prec = 0;
        
    }
    
    return weatherArray;
}

/**
	Given two dates tell me the number of days between the two
	@param fromDateTime The first date
	@param toDateTime The second date
	@returns integer of the number of days difference between two dates
 */
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

/**
	Create a weather report based on the trips forecast
	@param dict a dictionary that holds the array of weather data for the trip
	@returns void after creating a weather report
 */
//Changing this function to access a new dictionary and collect data from it
- (void) handleWeatherDictionaryPresent:(NSMutableDictionary*)dict
{
    NSMutableArray *array = [dict objectForKey:@"data"];
    
    __block WeatherReport *weatherReport;
    
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
        WeatherDay *weatherDay;
        
        [weatherReport addDay:[weatherDay initWithHigh: high low: low precipitation: prec date: day]];

    }
}

/*
//To be used later when we implement the NOAA API (CURRENTLY NOT COMPLETE)
- (void) getWeatherFromHistorical:(NSInteger)zip start:(NSDate *)start end:(NSDate *)end{
    // TODO: Need to format the dates as strings
    NSString *WeatherUrl = [NSString stringWithFormat:@"%@datasetid=GHCND&locationid=ZIP:%@&startdate=%@&enddate=%@&sortfield", HistoricalWeatherURLData, zip, start, end];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"token"       : HistoricalWeatherAPIKey
                                                   };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSError *error = nil;
    [[session dataTaskWithURL:[NSURL URLWithString:WeatherUrl]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSDictionary *HistoricalWeatherFeatures = [NSJSONSerialization JSONObjectWithData:response
                    options:0
                    error:&error];
                
                if(error) { 
                    // JSON was malformed, act appropriately here
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:HISTORICAL_JSON_DATA_RETURNED_NOTIFICATION object:self userInfo:HistoricalWeatherFeatures];
                
            }] resume];
}

//need to figure out how to collect data from this crazy API
- (void) handleWeatherDictionaryHistorical:(NSDictionary*)dict
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

@end
