//
//  GooglePlacesAPI.h
//  PackManager
//
//  Created by Heather Blockhus on 5/26/15.
//
//

#import <Foundation/Foundation.h>

@interface GooglePlacesAPI : NSObject

/**
 * Get the shared instance
 *@returns a shared instance of the WeatherAPI
 */
+ (instancetype) sharedInstance;

- (NSArray *) getLocationSuggestions:(NSString *)query;

@end
