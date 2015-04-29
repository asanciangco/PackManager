//
//  Trip.m
//  
//
//  Created by Alex Sanciangco on 4/21/15.
//
//

#import "Trip.h"

@implementation Trip

#pragma mark - Initializers

- (instancetype) initWithStartDate:(NSDate *)start
                          duration:(NSInteger)numDays
                       destination:(Destination *)dest
                              name:(NSString *)name
{
    if (self = [Trip init])
    {
        self.startDate      = start;
        self.duration       = numDays;
        self.destination    = dest;
        self.name           = name;
    }
    return self;
}

#pragma mark - Helpers

- (NSDate *) endDate
{
    // duration * hours * minutes * seconds
    NSInteger numSeconds = self.duration * 24 * 60 * 60;
    return [NSDate dateWithTimeInterval:numSeconds sinceDate:self.startDate];
}

#pragma mark - Encoding/Decoding
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.destination forKey:@"destination"];
    [aCoder encodeObject:self.startDate forKey:@"startDate"];
    [aCoder encodeInteger:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.packingList forKey:@"packingList"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.destination = [aDecoder decodeObjectForKey:@"destination"];
        self.startDate = [aDecoder decodeObjectForKey:@"startDate"];
        self.duration = [aDecoder decodeIntegerForKey:@"duration"];
        self.packingList = [aDecoder decodeObjectForKey:@"packingList"];
    }
    return self;
}

@end
