//
//  TripsData.m
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "TripsData.h"

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
            data = [NSKeyedUnarchiver unarchiveObjectWithData:rawData];
        }
        else
        {
            data.trips = [NSMutableArray array];
        }
    }
    return data;
}

#pragma mark - Acessing Trip Info
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

#pragma mark - Encoding / Decoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    NSData *encodedTrips = [NSKeyedArchiver archivedDataWithRootObject:self.trips];
    [aCoder encodeObject:encodedTrips forKey:@"trips"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.trips = [NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObjectForKey:@"trips"]];
    }
    return self;
}

@end
