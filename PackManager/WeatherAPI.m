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

static NSString *PresentWeatherURLData = @"http://api.openweathermap.org/data/2.5/forecast/daily?";

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
    
    if (!instance)
    {
        instance = [[WeatherAPI alloc] init];
    }
    return instance;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Core Fuctions

- (void) getLatLongFromAddress:(NSString*)address lat:(GLfloat *)lat lon:(GLfloat *)lon
{
    //Get URL search string with + instead of space
    NSString *reformattedAddress = [ address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *LatLongUrl = [NSString stringWithFormat:@"%@address=%@&key=%@", GoogleLatLongURL, reformattedAddress, GoogleAPIKey];
    
    //Check which API to use based on number of days until end of trip. Should me moved out.

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
        *lat = [loc[@"lat"] floatValue];
        *lon = [loc[@"lng"] floatValue];
    }
}

/**
 * getZipFromLatLong
 * @param lat latitude of the location
 * @param lon longitude of the location
 * @param zip zip code of the location to be returned
 * @returns void after retrieving the zip
 */
- (void) getZipFromLatLong:(GLfloat *)lat lon:(GLfloat *)lon zip:(NSString **)zip
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *URLString = [NSString stringWithFormat:@"%@latlng=%f,%f&key=%@", GoogleLatLongURL, *lat, *lon, GoogleAPIKey];
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse* response;
    NSError* error = nil;
    
    response = nil;
    error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSDictionary *addressesFromLatLong = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        return; // Make a boolean to return an error
    }
    
    NSArray *addresses = [addressesFromLatLong objectForKey:@"results"];
    NSDictionary *first = addresses[0]; //If conflicting zip codes, arbitrarily pick the first address in the list
    NSArray *components = first[@"address_components"];
    
    for(id obj in components) {
        if([((NSArray*)obj[@"types"]) containsObject:@"postal_code"]) {
            *zip = obj[@"long_name"];
            break;
        }
    }
}


//Gets weather for a city country combination for the next 16 days and uses that to get the weather for the upcoming trip. Country needs to be the two char country code. Takes the data from json and places it into a new dictionary that it passes to a handler to work with. Have not tested yet!
- (NSMutableArray *) getWeatherFromPresent:(CGFloat)lat lng:(CGFloat)lng start:(NSDate *)start end:(NSDate *)end
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
    NSDictionary *cityWeatherFeatures = [NSJSONSerialization JSONObjectWithData: data options:0 error:&error];
    
    if(error) {
        return nil; /* JSON was malformed, act appropriately here */
    }
    
    return [self parseJSONforPresent:cityWeatherFeatures start:start end:end];
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
    
    for (NSInteger i = dateOffset; i <= dateRange + dateOffset; i++)
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
        dateplus1 = [self dayFromDate:dateplus1 andDays:1];
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

- (NSDate *)dayFromDate:(NSDate *) date andDays:(NSInteger) numDays
{
    return [date dateByAddingTimeInterval:60*60*24*numDays];
}

/**
	Given a date tell me if it falls between two other dates
	@param date The date to check
	@param beginDate The start date
    @param endDate The end date
	@returns bool of whether it is within the bounds or not
 */

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

- (NSDate *)logicalOneYearAgo:(NSDate *)from {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-1];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:from options:0];
    
}

- (NSMutableArray *) getWeatherFromHistorical:(NSString *)zip start:(NSDate *)start end:(NSDate *)end{
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *startString = [df stringFromDate:[self logicalOneYearAgo:start]];
    NSString *endString = [df stringFromDate:[self logicalOneYearAgo:end]];
    
    NSString *WeatherUrl = [NSString stringWithFormat:@"%@datasetid=GHCND&locationid=ZIP:%@&startdate=%@&enddate=%@&sortfield=date&limit=1000", HistoricalWeatherURLData, zip, startString, endString];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:WeatherUrl]];
    [request setHTTPMethod:@"GET"];
    [request addValue:HistoricalWeatherAPIKey forHTTPHeaderField:@"token"];
    
    NSURLResponse* response;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    // handle response
    NSDictionary *cityWeatherFeatures = [NSJSONSerialization JSONObjectWithData: data options:0 error:&error];
    
    if(error) {
        return nil; /* JSON was malformed, act appropriately here */
    }
    
    return [self parseJSONforHistorical:cityWeatherFeatures];
}

- (NSMutableArray*) parseJSONforHistorical:(NSDictionary *)weather
{
    //Parse PresentWeatherFeatures by start end dates and pass new dictionary
    NSMutableArray *weatherArray = [NSMutableArray array];
    NSMutableDictionary *weatherEntry = [NSMutableDictionary dictionary];
    
    __block CGFloat prec = 0;
    __block NSString *date = @"";
    __block CGFloat value = 0;
    __block NSString* type = @"";
    __block NSString *last_date = @"";
    
    NSArray *results = [weather objectForKey:@"results"];
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date_obj;
    
    for (int i = 0; i < [results count]; i++)
    {
        NSDictionary *weatherdict = [results objectAtIndex:i];
        [weatherdict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([key  isEqualToString:@"value"])
            {
                if ([obj isKindOfClass:([NSNumber class])]) {
                    NSNumber *num = (NSNumber*)obj;
                    value = [num floatValue];
                }
            }
            if ([key  isEqualToString:@"datatype"])
            {
                type = obj;
            }
            if ([key  isEqualToString:@"date"])
            {
                last_date = date;
                date = obj;
            }
            
        }];
        if (![date  isEqualToString:last_date] && ![last_date isEqualToString:@""]) {
            last_date = [last_date stringByReplacingOccurrencesOfString:@"T"
                                                 withString:@" "];
            
            date_obj = [df dateFromString:last_date];
            
            [weatherEntry setObject:date_obj forKey:DAY_KEY];
            [weatherArray addObject:[weatherEntry copy]];
        }
        if ([type isEqualToString:@"PRCP"]) {
            if(value > 0 && value <= 1)
            {
                prec = .1;
            }
            else if (value > 1 && value <= 3)
            {
                prec = .3;
            }
            else if (value > 3 && value <= 7)
            {
                prec = .5;
            }
            else if (value > 7)
            {
                prec = .8;
            }
            [weatherEntry setObject:@(prec) forKey:PREC_KEY];
        }
        if ([type isEqualToString:@"TMIN"]) {
            [weatherEntry setObject:@((((value/10) * 9) / 5) + 32) forKey:LOW_KEY];
        }
        if ([type isEqualToString:@"TMAX"]) {
            [weatherEntry setObject:@((((value/10) * 9) / 5) + 32) forKey:HIGH_KEY];
        }
        
        //RESET PARAMETERS
        prec = 0;
        
    }
    //Enter last day
    
    last_date = [last_date stringByReplacingOccurrencesOfString:@"T"
                                                     withString:@" "];
    
    date_obj = [df dateFromString:last_date];
    
    [weatherEntry setObject:date_obj forKey:DAY_KEY];
    [weatherArray addObject:[weatherEntry copy]];
    
    return weatherArray;
}

/**
	Create a weather report based on the trips forecast
	@param dict a dictionary that holds the array of weather data for the trip
	@returns void after creating a weather report
 */
//Changing this function to access a new dictionary and collect data from it
- (WeatherReport *) handleWeatherDictionary:(NSMutableArray*) array
{
    WeatherReport *weatherReport = [[WeatherReport alloc] init];
    
    for (id obj in array) {
        [weatherReport addDay:[[WeatherDay alloc]
                               initWithHigh: [obj[HIGH_KEY] floatValue]
                               low: [obj[LOW_KEY] floatValue]
                               precipitation: [obj[PREC_KEY] floatValue]
                               date: obj[DAY_KEY]]];
    }
    
    return weatherReport;
}

- (WeatherReport *) getWeatherReport:(NSString *)location start:(NSDate *)start end:(NSDate *)end {
    NSInteger daysToStart = [self daysBetweenDate:[NSDate date] andDate:start];
    NSInteger daysToEnd = [self daysBetweenDate:[NSDate date] andDate:end];
    
    bool presentForecast = daysToStart <= 15;
    bool historicalForecast = daysToEnd >= 15;
    
    GLfloat lat;
    GLfloat lon;
    NSString *zip;
    
    [self getLatLongFromAddress:location lat:&lat lon:&lon];
    
    
    if (presentForecast && historicalForecast) {
        [self getZipFromLatLong:&lat lon:&lon zip:&zip];
        NSDate * mid = [self dayFromDate:start andDays:(15-daysToStart)];
        NSMutableArray *weather = [self getWeatherFromPresent:lat lng:lon start:start end:mid];
        [weather addObjectsFromArray:[self getWeatherFromHistorical:zip start:[self dayFromDate:mid andDays:1] end:end]];
        return [self handleWeatherDictionary:weather];
    } else if (presentForecast) {
        return [self handleWeatherDictionary:[self getWeatherFromPresent:lat lng:lon start:start end:end]];
    } else if (historicalForecast) {
        [self getZipFromLatLong:&lat lon:&lon zip:&zip];
        return [self handleWeatherDictionary:[self getWeatherFromHistorical:zip start:start end:end]];
    }
    
    
    return nil;
}

@end
