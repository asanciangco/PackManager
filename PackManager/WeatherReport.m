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
    return 100;
}

- (NSInteger) getOverallLow
{
    return 0;
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

@end
