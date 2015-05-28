//
//  WeatherDay.m
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "WeatherDay.h"

@implementation WeatherDay

- (instancetype) initWithHigh:(NSInteger)high low:(NSInteger)low precipitation:(CGFloat)prec date:(NSDate *)date
{
    if (self = [super init])
    {
        self.high = high;
        self.low = low;
        self.precipitaion = prec;
        self.date = date;
    }
    
    return self;
}

- (NSInteger) weightedAverageTemp
{
    return (0.80 * self.high) + (0.20 * self.low);
}

//- (NSInteger) weightedAverageTemp
//{
//    return (0.80 * self.high) + (0.20 * self.low);
//}

- (NSInteger) range
{
    return self.high - self.low;
}

#pragma mark - Encoding / Decoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.high forKey:@"high"];
    [aCoder encodeInteger:self.low forKey:@"low"];
    [aCoder encodeFloat:self.precipitaion forKey:@"precipitation"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.high = [aDecoder decodeIntegerForKey:@"high"];
        self.low = [aDecoder decodeIntegerForKey:@"low"];
        self.precipitaion = [aDecoder decodeFloatForKey:@"precipitation"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

@end
