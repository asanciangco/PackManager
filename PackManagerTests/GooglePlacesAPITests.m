//
//  GooglePlacesAPITests.m
//  PackManager
//
//  Created by NIck Westman on 5/27/15.
//
//

#import <XCTest/XCTest.h>
#import <Nocilla/Nocilla.h>
#import "GooglePlacesAPI.h"

@interface GooglePlacesAPITests : XCTestCase

@property (nonatomic, strong) GooglePlacesAPI *instance;

@end

@implementation GooglePlacesAPITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.instance = [GooglePlacesAPI sharedInstance];
    
    [[LSNocilla sharedInstance] start];
    [[LSNocilla sharedInstance] clearStubs];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [[LSNocilla sharedInstance] stop];
}

- (void)testTimeout {
    stubRequest(@"GET", @"https://maps\\.googleapis\\.com/.*".regex)
        .andFailWithError([NSError errorWithDomain:NSURLErrorDomain code:-1001 userInfo:nil]); //This is a stock timeout error
    
    NSArray *locations = [self.instance getLocationSuggestions:@"Los Angeles"];
    
    XCTAssertEqualObjects(locations, @[]);
}

- (void)testEmptyResponse {
    stubRequest(@"GET", @"https://maps\\.googleapis\\.com/.*".regex).andReturn(200).withBody(@"");
    
    NSArray *locations = [self.instance getLocationSuggestions:@"Los Angeles"];
    
    XCTAssertEqualObjects(locations, @[]);
}

- (void)testMalformedJSON {
    stubRequest(@"GET", @"https://maps\\.googleapis\\.com/.*".regex).andReturn(200).withBody(@"{{");
    
    NSArray *locations = [self.instance getLocationSuggestions:@"Los Angeles"];
    
    XCTAssertEqualObjects(locations, @[]);
}

@end
