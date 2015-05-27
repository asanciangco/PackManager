//
//  WeatherAPITests.m
//  PackManager
//
//  Created by NIck Westman on 5/26/15.
//
//

#import <XCTest/XCTest.h>
#import <Nocilla/Nocilla.h>
#import <objc/runtime.h>
#import "WeatherAPI.h"

@interface WeatherAPITests : XCTestCase

@property (nonatomic,strong) NSDate *start;
@property (nonatomic,strong) NSDate *end;

@property (nonatomic,strong) WeatherAPI *instance;

@property (nonatomic, strong) NSDate *mockDate;

@property (nonatomic) Method mockDateMethod;
@property (nonatomic) Method originalDateMethod;



@end

@implementation WeatherAPITests

- (void)setUp {
    [super setUp];
    
    [self setUpFakeDate];
    
    // Set up properties
    
    self.start   = [NSDate dateWithTimeInterval:1 * 24 * 60 * 60 sinceDate:[NSDate date]];
    self.end     = [NSDate dateWithTimeInterval:7 * 24 * 60 * 60 sinceDate:[NSDate date]];
    
    self.instance = [WeatherAPI sharedInstance];
    
    
    
    // Set up mocks
    
    [[LSNocilla sharedInstance] start]; //Start nocilla
    stubRequest(@"GET", @"http://www.google.com").andReturn(201).withBody(@"Hello Mocks");
    stubRequest(@"GET", @"https://maps.googleapis.com/maps/api/geocode/json?address=Los+Angeles&key=AIzaSyDUwWOuEWRMEHuXuQVwNbUkzXSpxgpyJoA").andReturn(200).withBody([self getSampleJSON:@"googlemaps"]);
    stubRequest(@"GET", @"https://maps.googleapis.com/maps/api/geocode/json?latlng=34.052235,-118.243683&key=AIzaSyDUwWOuEWRMEHuXuQVwNbUkzXSpxgpyJoA").andReturn(200).withBody([self getSampleJSON:@"googlemaps2"]);
    stubRequest(@"GET", @"http://api.openweathermap.org/.*".regex).andReturn(200).withBody([self getSampleJSON:@"openWeatherMap"]);
    stubRequest(@"GET", @"http://www.ncdc.noaa.gov/.*".regex).andReturn(200).withBody([self getSampleJSON:@"historical"]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [self tearDownFakeDate];
    
    [[LSNocilla sharedInstance] stop];
}

#pragma mark Helpers

- (NSString *) getSampleJSON:(NSString*)name {
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSString *sampleJSON = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    return sampleJSON;
}

- (void)setUpFakeDate
{
    // Save these as instance variables so test teardown can swap the implementation back
    self.originalDateMethod = class_getClassMethod([NSDate class], @selector(date));
    self.mockDateMethod = class_getInstanceMethod([self class], @selector(mockDateSwizzle));
    method_exchangeImplementations(self.originalDateMethod, self.mockDateMethod);
}

- (void)tearDownFakeDate
{
    // Revert the swizzle
    method_exchangeImplementations(self.mockDateMethod, self.originalDateMethod);
}

// Mock Method, replaces [NSDate date]
- (NSDate *)mockDateSwizzle {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *mock = [formatter dateFromString:@"2015-04-23 02:34:27"];
    return mock;
}

#pragma mark Tests

- (void)testNocillaMock {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.google.com"]];
    [request setHTTPMethod:@"GET"];

    NSURLResponse* response;
    NSError* error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    NSString* body = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    
    XCTAssert([body isEqualToString:@"Hello Mocks"]);
    
    /* //Async Version
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch"];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil]; */
}

- (void)testMockDate {
    NSDate *d = [NSDate date];
    
    XCTAssert(true);
}

- (void)testGetLatLongFromAddress { //TODO: reduce fragility of requests
    GLfloat lat;
    GLfloat lon;
    NSString *zip;
    
    [self.instance getLatLongFromAddress:@"Los Angeles" lat:&lat lon:&lon zip:&zip];
    
    XCTAssertEqualWithAccuracy(lat, 34.0, 1.0);
    XCTAssertEqualWithAccuracy(lon, -118, 1.0);
    XCTAssert([zip isEqualToString:@"90012"]);
}

- (void)testGetWeatherFromPresent {
    //WeatherReport *report = [[WeatherReport alloc] init];
    NSMutableArray *weather = [self.instance getWeatherFromPresent:34.0522346 lng:-118.243683 start:self.start end:self.end];
    
    XCTAssertEqual([weather count], 7);
}

- (void)testGetWeatherFromHistorical {
    //WeatherReport *report = [[WeatherReport alloc] init];
    NSMutableArray *weather = [self.instance getWeatherFromHistorical:@"90012" start:self.start end:self.end];
    
    XCTAssertEqual([weather count], 7);
}

- (void)testGetWeatherReportPresentOnly {
    WeatherReport *report = [self.instance getWeatherReport:@"Los Angeles" start:self.start end:self.end];
    
    GLfloat high = [report getOverallHigh];
    GLfloat low = [report getOverallLow];
    
    XCTAssertEqual(high, 82);
    XCTAssertEqual(low, 48);
}



@end
