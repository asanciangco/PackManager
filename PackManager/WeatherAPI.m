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
    
    if ((instance = [[WeatherAPI alloc] init]))
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWeatherDictionary:) name:HISTORICAL_JSON_DATA_RETURNED_NOTIFICATION object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWeatherDictionary:) name:PRESENT_JSON_DATA_RETURNED_NOTIFICATION object:self];
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
    BOOL startIsCurrent = [self date:start isBetweenDate:[NSDate date] andDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*15]];
    BOOL endIsCurrent = [self date:end isBetweenDate:[NSDate date] andDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*15]];
    bool presentForecast = false;
    bool historicalForeast = false;
    
    if(startIsCurrent && endIsCurrent)
    {
        presentForecast = true;
        historicalForeast = false;
    }
    else if(startIsCurrent && !endIsCurrent)
    {
        presentForecast = true;
        historicalForeast = true;
    }
    else
    {
        presentForecast = false;
        historicalForeast = true;
    }
  
  __block CGFloat lat = 0;
  __block CGFloat lon = 0;
  __block NSString *zip = 0;
  
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
  NSURLSessionConfiguration *sessionConfiguration2 = [NSURLSessionConfiguration defaultSessionConfiguration];
    
  NSURLSession *session2 = [NSURLSession sessionWithConfiguration:sessionConfiguration2];
  
  [[session dataTaskWithURL:[NSURL URLWithString:LatLongUrl]
          completionHandler:^(NSData *data,
                              NSURLResponse *response,
                              NSError *error) {
            // handle response
            NSDictionary *cityLatLong = [NSJSONSerialization JSONObjectWithData: data
                                                                                options:0
                                                                                  error:&error];
            
            if(error) {
              /* JSON was malformed, act appropriately here */
            }
            else{
              
              NSArray *results = [cityLatLong objectForKey:@"results"];
              NSDictionary *resultDict = [results objectAtIndex:0];
              
              [resultDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                  if ([key  isEqualToString:@"geometry"])
                  {
                      NSDictionary *geodict = [resultDict objectForKey:@"geometry"];
                      [geodict enumerateKeysAndObjectsUsingBlock:^(id geokey, id geoobj, BOOL *geostop)
                       {

                            if ([geokey  isEqualToString:@"location"])
                            {
                              NSDictionary *tempdict = [geodict objectForKey:@"location"];
                              [tempdict enumerateKeysAndObjectsUsingBlock:^(id key2, id obj2, BOOL *stop2)
                               {
                                 if ([key2 isEqualToString:@"lat"])
                                 {
                                   if ([obj2 isKindOfClass:([NSNumber class])])
                                   {
                                     NSNumber *num = (NSNumber*)obj2;
                                     lat = [num floatValue];
                                   }
                                 }
                                 if ([key2  isEqualToString:@"lng"])
                                 {
                                   if ([obj2 isKindOfClass:([NSNumber class])])
                                   {
                                     NSNumber *num = (NSNumber*)obj2;
                                     lon = [num floatValue];
                                   }
                                 }
                               }];
                            }
                       }];
                  }
              }];

            }
            if(presentForecast && !historicalForeast)
            {
            [[WeatherAPI sharedInstance]getWeatherFromPresent:lat lng:lon start:start end:end];
            }
            else
            {
                //NEED TO GET ZIP
                [[session2 dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@latlng=%f,%f&key=%@", GoogleLatLongURL, lat, lon, GoogleAPIKey]]
                        completionHandler:^(NSData *data,
                                            NSURLResponse *response,
                                            NSError *error) {
                            // handle response
                            NSDictionary *cityLatLong = [NSJSONSerialization JSONObjectWithData: data
                                                                                        options:0
                                                                                          error:&error];
                            
                            if(error) {
                                /* JSON was malformed, act appropriately here */
                            }
                            else{
                                //Get zipcode from JSON
                                NSArray *results = [cityLatLong objectForKey:@"results"];
                                NSDictionary *resultDict = [results objectAtIndex:0];
                                NSArray *addressComponents = [resultDict objectForKey:@"address_components"];
                                for (int i = 0; i < [addressComponents count]; i++)
                                {
                                    NSDictionary *zipdict = [addressComponents objectAtIndex:i];
                                    [zipdict enumerateKeysAndObjectsUsingBlock:^(id zipkey, id zipobj, BOOL *stop) {
                                        if ([zipkey  isEqualToString:@"types"])
                                        {
                                            NSArray *types = [zipdict objectForKey:@"types"];
                                            for (int i = 0; i < [types count]; i++)
                                            {
                                                if ([[types objectAtIndex:i]  isEqualToString:@"postal_code"])
                                                {
                                                    [zipdict enumerateKeysAndObjectsUsingBlock:^(id zipkey2, id zipobj2, BOOL *stop) {
                                                            if ([zipkey2  isEqualToString:@"long_name"])
                                                            {
                                                                    zip = zipobj2;
                                                        }
                                                        }];
                                                }
                                            }
                                        }
                                    }];
                                    if(zip != 0)
                                        break;
                                }
                                if(!presentForecast && historicalForeast)
                                {
                                    [[WeatherAPI sharedInstance]getWeatherFromHistorical: zip start: [self logicalOneYearAgo:start] end: [self logicalOneYearAgo:end]];
                                }
                                else
                                {
                                    //Use the Present API for as many days as possible up to 15 days past today
                                    [[WeatherAPI sharedInstance]getWeatherFromPresent:lat lng:lon start:start end:[[NSDate date] dateByAddingTimeInterval:60*60*24*14]];
                                    
                                    //Use historical for everything else
                                    [[WeatherAPI sharedInstance]getWeatherFromHistorical: zip start:[self logicalOneYearAgo:[[NSDate date] dateByAddingTimeInterval:60*60*24*15]]  end: [self logicalOneYearAgo:end]];
                                    
                                }
                            }
                }] resume];
            }
    }] resume];

  
}


//Gets weather for a city country combination for the next 16 days and uses that to get the weather for the upcoming trip. Country needs to be the two char country code. Takes the data from json and places it into a new dictionary that it passes to a handler to work with. Have not tested yet!
- (void) getWeatherFromPresent:(CGFloat)lat lng:(CGFloat)lng start:(NSDate *)start end:(NSDate *)end
{
    NSString *WeatherUrl = [NSString stringWithFormat:@"%@lat=%f&lon=%f&cnt=16&mode=json&units=imperial", PresentWeatherURLData, lat, lng];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"x-api-key"       : PresentWeatherAPIKey
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
                else{
                    NSMutableArray *weatherArray = [self parseJSONforPresent:cityWeatherFeatures start:start end:end];
                    
                    //Call handler
                    [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_JSON_DATA_RETURNED_NOTIFICATION object:self userInfo:@{@"data":weatherArray}];
                }
                
            }] resume];
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
    
    __block CGFloat high = 0;
    __block CGFloat low = 0;
    __block CGFloat prec = 0;
    
    NSArray *results = [weather objectForKey:@"list"];
    
    NSDate *dateplus1 = start;
    
    NSInteger dateRange = [self daysBetweenDate:start andDate:end];
    NSInteger dateOffset = [self daysBetweenDate:[NSDate date] andDate:start];
    
    for (NSInteger i = dateOffset; i <= dateRange + dateOffset; i++)
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
        [weatherEntry setObject:@(low) forKey:LOW_KEY];
        [weatherEntry setObject:@(prec) forKey:PREC_KEY];
        [weatherEntry setObject:dateplus1 forKey:DAY_KEY];
        
        [weatherArray addObject:[weatherEntry copy]];
        
        //Increase Date
        dateplus1 = [dateplus1 dateByAddingTimeInterval:60*60*24*1];
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

//To be used later when we implement the NOAA API (CURRENTLY NOT COMPLETE)
- (void) getWeatherFromHistorical:(NSString *)zip start:(NSDate *)start end:(NSDate *)end{
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *startString = [df stringFromDate:start];
    NSString *endString = [df stringFromDate:end];
    
    NSString *WeatherUrl = [NSString stringWithFormat:@"%@datasetid=GHCND&locationid=ZIP:%@&startdate=%@&enddate=%@&sortfield=date&limit=1000", HistoricalWeatherURLData, zip, startString, endString];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"token"       : HistoricalWeatherAPIKey
                                                   };
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
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
                else{
                    NSMutableArray *weatherArray = [self parseJSONforHistorical:cityWeatherFeatures];
                    
                    //Call handler
                    [[NSNotificationCenter defaultCenter] postNotificationName:HISTORICAL_JSON_DATA_RETURNED_NOTIFICATION object:self userInfo:@{@"data":weatherArray}];
                }
                
            }] resume];

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
- (void) handleWeatherDictionary:(NSMutableDictionary*)dict
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
//        WeatherDay *weatherDay;
        
        [weatherReport addDay:[[WeatherDay alloc] initWithHigh: high low: low precipitation: prec date: day]];

    }
}

@end
