//
//  WeatherDayTests.m
//  PackManager
//
//  Created by Nick Westman on 5/20/15.
//
//

#import <XCTest/XCTest.h>
#import "WeatherDay.h"

@interface WeatherDayTests : XCTestCase

@property (nonatomic,strong) WeatherDay *bob;

@end

@implementation WeatherDayTests

- (void)setUp {
    [super setUp];
    
    self.bob = [[WeatherDay alloc] initWithHigh:100 low:50 precipitation:0.5 date:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAverage {
    XCTAssertEqual(self.bob.averageTemp, 75);
}

- (void)testRange {
    XCTAssertEqual(self.bob.range, 50);
}

@end
