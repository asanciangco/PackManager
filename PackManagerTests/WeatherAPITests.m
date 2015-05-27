//
//  WeatherAPITests.m
//  PackManager
//
//  Created by NIck Westman on 5/26/15.
//
//

#import <XCTest/XCTest.h>
#import <Nocilla/Nocilla.h>
#import "WeatherAPI.h"

@interface WeatherAPITests : XCTestCase

@property (nonatomic,strong) NSDate *start;
@property (nonatomic,strong) NSDate *end;

@property (nonatomic,strong) WeatherAPI *instance;

@end

@implementation WeatherAPITests

- (void)setUp {
    [super setUp];
    
    // Set up properties
    
    self.start   = [NSDate dateWithTimeInterval:1 * 24 * 60 * 60 sinceDate:[NSDate date]];
    self.end     = [NSDate dateWithTimeInterval:7 * 24 * 60 * 60 sinceDate:[NSDate date]];
    
    self.instance = [WeatherAPI sharedInstance];
    
    // Set up mocks
    
    [[LSNocilla sharedInstance] start];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [[LSNocilla sharedInstance] stop];
}

#pragma mark Tests

- (void)testNocillaMock {
    //[self.instance getLatLongFromAddress:@"Los Angeles" start:self.start end:self.end];
    
    stubRequest(@"GET", @"http://www.google.com").andReturn(201).withBody(@"Hello Mocks");
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

- (void)testParseJSONForPresent {
    
    // bloopity bloo, need a proper nsdict here
    
    /* NSMutableArray* days = [self.instance parseJSONforPresent:nil start:self.start end:self.end]; */
    
    XCTAssert(YES, @"Pass");
}

@end
