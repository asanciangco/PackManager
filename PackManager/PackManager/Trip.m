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
{
    if (self = [Trip init])
    {
        self.startDate      = start;
        self.duration       = numDays;
        self.destination    = dest;
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

@end
