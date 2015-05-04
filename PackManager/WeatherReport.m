//
//  WeatherReport.m
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "WeatherReport.h"
#import "WeatherDay.h"

@interface WeatherReport ()

@property (nonatomic, strong) NSMutableArray *weatherDays;

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

#pragma mark - Weather Info
// TODO: Implement me

- (NSInteger) getOverallHigh
{
    NSInteger high = NSIntegerMin;
    for (WeatherDay *r in self.weatherDays) {
        if(high < [r high]) {
            high = r.high;
        }
    }
    return high;
}

- (NSInteger) getOverallLow
{
    NSInteger low = NSIntegerMax;
    for (WeatherDay *r in self.weatherDays) {
        if(low > [r low]) {
            low = r.low;
        }
    }
    return low;
}

- (NSInteger) numberOfDays
{
    return [self.weatherDays count];
}

- (NSInteger) getHighForDay:(NSInteger)day
{
    if (day <= 0 || day > [self numberOfDays])
        return NSIntegerMin;
    
    WeatherDay *weatherDay = [self.weatherDays objectAtIndex:(day - 1)];
    
    return weatherDay.high;
}

- (NSInteger) getLowForDay:(NSInteger)day;
{
    if (day <= 0 || day > [self numberOfDays])
        return NSIntegerMin;
    
    WeatherDay *weatherDay = [self.weatherDays objectAtIndex:(day - 1)];
    
    return weatherDay.low;
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

#pragma mark - Encoding / Decoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.weatherDays forKey:@"weatherDays"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.weatherDays = [aDecoder decodeObjectForKey:@"weatherDays"];
    }
    return self;
}



@end
