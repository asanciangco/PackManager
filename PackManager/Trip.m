//
//  Trip.m
//  
//
//  Created by Alex Sanciangco on 4/21/15.
//
//

#import "Trip.h"
#import "UserPreferences.h"

@implementation Trip

#pragma mark - Initializers

- (instancetype) initWithStartDate:(NSDate *)start
                          duration:(NSInteger)numDays
                       destination:(Destination *)dest
                              name:(NSString *)name
{
    if (self = [Trip init])
    {
        UserPreferences *prefs = [UserPreferences sharedInstance];
        
        self.startDate      = start;
        self.duration       = numDays;
        self.destination    = dest;
        self.name           = name;
        
        self.swimmingPreference = [prefs getSwimmingPreference];
        self.formalPreference   = [prefs getFormalPreference];
        self.rewearJeansPreference  = [prefs getRewearJeansPreference];
        self.accessToLaundryPreference  = [prefs getAccessToLaundryPreference];
    }
    return self;
}

- (instancetype) initNewTrip
{
    if (self = [[Trip alloc] initWithStartDate:NULL duration:-1 destination:NULL name:@""])
    {
        
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

- (BOOL) generatePackingList
{
    // Sanity checks first:
    //
    // Check destination
    if (!self.destination || ![self.destination valid])
        return NO;
    
    // Check weather report
    if (!self.weatherReport)
        return NO;
    
    // check dates
    if (!self.startDate || self.duration <=0)
        return NO;
    
    // Have the packing list create itself based on the
    self.packingList = [[PackingList alloc] initPackingListForTrip:self];

    return (self.packingList != NULL);
}

#pragma mark - Encoding/Decoding
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.destination forKey:@"destination"];
    [aCoder encodeObject:self.startDate forKey:@"startDate"];
    [aCoder encodeInteger:self.duration forKey:@"duration"];
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
        self.destination = [aDecoder decodeObjectForKey:@"destination"];
        self.startDate = [aDecoder decodeObjectForKey:@"startDate"];
        self.duration = [aDecoder decodeIntegerForKey:@"duration"];
        self.packingList = [aDecoder decodeObjectForKey:@"packingList"];
        
        self.swimmingPreference = [aDecoder decodeBoolForKey:@"swimmingPreference"];
        self.formalPreference = [aDecoder decodeBoolForKey:@"formalPreference"];
        self.rewearJeansPreference = [aDecoder decodeBoolForKey:@"rewearJeansPreference"];
        self.accessToLaundryPreference = [aDecoder decodeBoolForKey:@"accessToLaundryPreference"];
    }
    return self;
}

@end
