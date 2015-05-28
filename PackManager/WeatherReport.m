//
//  WeatherReport.m
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "WeatherReport.h"
#import "WeatherDay.h"
#import "NSCodingHelper.h"

@interface WeatherReport ()

@property (nonatomic, readwrite, strong) NSMutableArray *weatherDays;

@end

@implementation WeatherReport

#pragma mark - Initializer
// TODO: need to be able to initialize a weather report object from
// whatever the return type of the WeatherAPI is

- (instancetype) init
{
    if (self = [super init])
    {
        self.weatherDays = [NSMutableArray array];
    }
    return self;
}

- (instancetype) initExampleReport
{
    if (self = [super init])
    {
        self.weatherDays = [NSMutableArray array];
        
        // Current exmaple, 7 day trip of one temperature
        [self.weatherDays addObjectsFromArray:@[[[WeatherDay alloc] initWithHigh:70 low:70 precipitation:0.1 date:[NSDate date]],
                                                [[WeatherDay alloc] initWithHigh:70 low:70 precipitation:0.1 date:[NSDate date]],
                                                [[WeatherDay alloc] initWithHigh:70 low:70 precipitation:0.1 date:[NSDate date]],
                                                [[WeatherDay alloc] initWithHigh:70 low:70 precipitation:0.1 date:[NSDate date]],
                                                [[WeatherDay alloc] initWithHigh:70 low:70 precipitation:0.1 date:[NSDate date]],
                                                [[WeatherDay alloc] initWithHigh:70 low:70 precipitation:1 date:[NSDate date]],
                                                [[WeatherDay alloc] initWithHigh:70 low:70 precipitation:0 date:[NSDate date]]]];
    }
    return self;
}

#pragma mark - Weather Info
- (NSInteger) getOverallHigh
{
    NSInteger high = NSIntegerMin;
    for (WeatherDay *day in self.weatherDays)
    {
        if(high < day.high)
            high = day.high;
    }
    return high;
}

- (NSInteger) getOverallLow
{
    NSInteger low = NSIntegerMax;
    for (WeatherDay *day in self.weatherDays)
    {
        if(low > day.low)
            low = day.low;
    }
    return low;
}

- (NSInteger) numberOfDays
{
    return [self.weatherDays count];
}

- (WeatherDay*) getDayAtIndex: (NSInteger) day;
{
    if (day <= 0 || day > [self numberOfDays])
        return nil;
    
    return [self.weatherDays objectAtIndex:(day - 1)];
}

- (NSInteger) getHighForDay:(NSInteger)day
{
    WeatherDay *weatherDay = [self getDayAtIndex:day];
    return weatherDay.high;
}

- (NSInteger) getLowForDay:(NSInteger)day;
{
    WeatherDay *weatherDay = [self getDayAtIndex:day];
    return weatherDay.low;
}

- (NSInteger) getAverageForDay: (NSInteger)day;
{
    WeatherDay *weatherDay = [self getDayAtIndex:day];
    return [weatherDay weightedAverageTemp];
}

- (NSInteger) getRangeForDay: (NSInteger)day;
{
    WeatherDay *weatherDay = [self getDayAtIndex:day];
    return weatherDay.range;
}

#pragma mark - WeatherDay logic
- (BOOL) daysAreInOrder
{
    // TODO: Implement me.
    
    return NO;
}

- (void) putDaysInOrder
{
    // TODO: Implement me.
}

- (void) addDay:(WeatherDay *)day
{
    [self.weatherDays addObject:day];
}

#pragma mark - Encoding / Decoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSCodingHelper dataForArray:self.weatherDays] forKey:@"weatherDays"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.weatherDays = [NSCodingHelper mutableArrayFromData:[aDecoder decodeObjectForKey:@"weatherDays"]];
    }
    return self;
}



@end
