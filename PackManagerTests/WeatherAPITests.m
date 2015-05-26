//
//  WeatherAPITests.m
//  PackManager
//
//  Created by NIck Westman on 5/26/15.
//
//

#import <XCTest/XCTest.h>
#import "WeatherAPI.h"

@interface WeatherAPITests : XCTestCase

@end

@implementation WeatherAPITests

- (void)setUp {
    [super setUp];
    
    NSDate *start   = [NSDate dateWithTimeInterval:1 * 24 * 60 * 60 sinceDate:[NSDate date]];
    NSDate *end     = [NSDate dateWithTimeInterval:7 * 24 * 60 * 60 sinceDate:[NSDate date]];
    
    [[WeatherAPI sharedInstance] getLatLongFromAddress: @"Los Angeles" start:start end:end];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    XCTAssert(YES, @"Pass");
}

@end
