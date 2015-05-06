//
//  PackManagerTests.m
//  PackManagerTests
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Trip.h"
#import "Destination.h"

@interface PackManagerTests : XCTestCase


@end



@implementation PackManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Utilities

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

/* Trip Tests */

#pragma mark - TripTests

- (void)testTripEndDate //Start Unit Test
{
    Trip *trip = [[Trip alloc] initNewTrip];
    Destination *d1 = [[Destination alloc] init];
    d1.duration = 10;
    Destination *d2 = [[Destination alloc] init];
    d2.duration = 5;
    
    trip.startDate = [NSDate date];
    trip.destinations = [NSMutableArray arrayWithObjects:@[d1,d2], nil];
    
    NSInteger diff = [PackManagerTests daysBetweenDate:[trip startDate] andDate:[trip endDate]];

    XCTAssertEqual(diff,15);
}



@end
