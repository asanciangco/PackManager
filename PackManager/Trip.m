//
//  Trip.m
//  
//
//  Created by Alex Sanciangco on 4/21/15.
//
//

#import "Trip.h"
#import "UserPreferences.h"

/**
 Trip object that contains all necessary information for a trip, including
 the packing lists and weather information. This data structure will be
 passed around frequently for populating the core UI of many screens.
 */
@implementation Trip

#pragma mark - Initializers

/**
 Creates new trip with given parameters.
 @param start   start date of the trip
 @param name    the name of the trip
 */
- (instancetype) initWithStartDate:(NSDate *)start
                              name:(NSString *)name
{
    if (self = [Trip init])
    {
        UserPreferences *prefs = [UserPreferences sharedInstance];
        
        self.startDate      = start;
        self.durations      = [NSMutableArray array];
        self.destinations   = [NSMutableArray array];
        self.name           = name;
        
        self.swimmingPreference = [prefs getSwimmingPreference];
        self.formalPreference   = [prefs getFormalPreference];
        self.rewearJeansPreference  = [prefs getRewearJeansPreference];
        self.accessToLaundryPreference  = [prefs getAccessToLaundryPreference];
    }
    return self;
}

/**
 Creates new, blank trip
 */
- (instancetype) initNewTrip
{
    if (self = [[Trip alloc] initWithStartDate:NULL name:@""])
    {
        
    }
    return self;
}

#pragma mark - Helpers

- (NSDate *) endDate
{
    NSInteger totalDuration = 0;
    for (NSNumber *num in self.durations)
        totalDuration += [num integerValue];
    
    // duration * hours * minutes * seconds
    NSInteger numSeconds = totalDuration * 24 * 60 * 60;
    return [NSDate dateWithTimeInterval:numSeconds sinceDate:self.startDate];
}

- (NSInteger) totalDuration
{
    NSInteger duration = 0;
    for (Destination *dest in self.destinations)
    {
        duration += dest.duration;
    }
    
    return duration;
}

- (BOOL) generatePackingList
{
    // Sanity checks first:
    //
    // Check destination
    for (Destination *dest in self.destinations)
    {
        if (!dest || ![dest valid])
            return NO;
    }
        
    
    
    // Check weather report
    if (!self.weatherReport)
        return NO;
    
    // check dates
    if (!self.startDate || [self totalDuration] <=0)
        return NO;
    
    // Have the packing list create itself based on the
    self.packingList = [[PackingList alloc] initPackingListForTrip:self];

    return (self.packingList != NULL);
}

#pragma mark - Encoding/Decoding
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.destinations forKey:@"destination"];
    [aCoder encodeObject:self.startDate forKey:@"startDate"];
    [aCoder encodeObject:self.packingList forKey:@"packingList"];
    
    [aCoder encodeBool:self.swimmingPreference forKey:@"swimmingPreference"];
    [aCoder encodeBool:self.formalPreference forKey:@"formalPreference"];
    [aCoder encodeBool:self.rewearJeansPreference forKey:@"rewearJeansPreference"];
    [aCoder encodeBool:self.accessToLaundryPreference forKey:@"accessToLaundryPreference"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.destinations = [aDecoder decodeObjectForKey:@"destination"];
        self.startDate = [aDecoder decodeObjectForKey:@"startDate"];
        self.packingList = [aDecoder decodeObjectForKey:@"packingList"];
        
        self.swimmingPreference = [aDecoder decodeBoolForKey:@"swimmingPreference"];
        self.formalPreference = [aDecoder decodeBoolForKey:@"formalPreference"];
        self.rewearJeansPreference = [aDecoder decodeBoolForKey:@"rewearJeansPreference"];
        self.accessToLaundryPreference = [aDecoder decodeBoolForKey:@"accessToLaundryPreference"];
    }
    return self;
}

@end
