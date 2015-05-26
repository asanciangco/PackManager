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

@property (nonatomic,strong) NSDate *start;
@property (nonatomic,strong) NSDate *end;

@property (nonatomic,strong) WeatherAPI *instance;

@end

@implementation WeatherAPITests

- (void)setUp {
    [super setUp];
    
    self.start   = [NSDate dateWithTimeInterval:1 * 24 * 60 * 60 sinceDate:[NSDate date]];
    self.end     = [NSDate dateWithTimeInterval:7 * 24 * 60 * 60 sinceDate:[NSDate date]];
    
    self.instance = [WeatherAPI sharedInstance];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWeatherFromPresent {
    
}

- (void)testParseJSONForPresent {
    
    // bloopity bloo, need a proper nsdict here
    
    NSMutableArray* days = [self.instance parseJSONforPresent:nil start:self.start end:self.end];
    
    XCTAssert(YES, @"Pass");
}

@end
