//
//  TripsData.m
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "TripsData.h"
#import "Trip.h"
#import "NSCodingHelper.h"

static TripsData *sharedInstance;

@interface TripsData ()

@property (nonatomic, strong) NSMutableArray *trips;    // of Trips

@end

@implementation TripsData

#pragma mark - Accessing sharedInstance
+ (instancetype) sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [TripsData initFromUserDefaults];
    }
    return sharedInstance;
}

+ (instancetype) initFromUserDefaults
{
    TripsData *data;
    
    if ((data = [[TripsData alloc] init]))
    {
        NSData *rawData = [[NSUserDefaults standardUserDefaults] dataForKey:@"tripsData"];
        if (rawData)
        {
            data.trips = [NSKeyedUnarchiver unarchiveObjectWithData:rawData];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            data.trips = [NSMutableArray array];
        }
    }
    return data;
}

#pragma mark - Trips
- (NSInteger) numberOfTrips
{
    return [self.trips count];
}

- (Trip *) getTrip:(NSInteger)index
{
    if (index >= [self numberOfTrips] || index < 0)
        return NULL;
    
    return [self.trips objectAtIndex:index];
}

// TODO: test this
- (void) addTrip:(Trip *)newTrip
{
//    if ([self.trips count] == 0)
//    {
//        [self.trips addObject:newTrip];
//        [self saveList];
//        return;
//    }
//    if ([self.trips containsObject:newTrip])
//        return;
    
//    for (NSInteger i = 0; i < [self.trips count]; i++)
//    {
//        Trip *trip = [self.trips objectAtIndex:i];
//        if ([trip.startDate compare:newTrip.startDate] == NSOrderedDescending)
//        {
//            [self.trips insertObject:newTrip atIndex:i];
//        }
//    }
    [self.trips addObject:newTrip];
    [self saveList];
}

- (void) removeTripAtIndex:(NSInteger)index
{
    if (index < 0 || index >= [self.trips count])
        return;
    [self.trips removeObjectAtIndex:index];
    [self saveList];
}

#pragma mark - Save list
- (void) saveList
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSCodingHelper dataForArray:self.trips] forKey:@"tripsData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Encoding / Decoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSCodingHelper dataForArray:self.trips] forKey:@"trips"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.trips = [NSCodingHelper mutableArrayFromData:[aDecoder decodeObjectForKey:@"trips"]];
    }
    return self;
}

@end
