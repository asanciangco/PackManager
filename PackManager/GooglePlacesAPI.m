//
//  GooglePlacesAPI.m
//  PackManager
//
//  Created by Heather Blockhus on 5/26/15.
//
//

#import "GooglePlacesAPI.h"

static GooglePlacesAPI *sharedInstance;

//two keys so we can switch back and forth when reach daily limit
//static NSString *googlePlacesAPIKey = @"AIzaSyA7THdVP0SwlyTidfjYeElYCLqtZLQPZ4k";
static NSString *googlePlacesAPIKey = @"AIzaSyDUwWOuEWRMEHuXuQVwNbUkzXSpxgpyJoA";

static NSString *googlePlacesURL = @"https://maps.googleapis.com/maps/api/place/textsearch/json?";

@implementation GooglePlacesAPI

// Get the shared instance //
/////////////////////////////
#pragma mark - Accessing sharedInstance
+ (instancetype) sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [GooglePlacesAPI initWithDefaults];
    }
    return sharedInstance;
}

+ (instancetype) initWithDefaults
{
    GooglePlacesAPI *instance;
    
    if (!instance)
    {
        instance = [[GooglePlacesAPI alloc] init];
    }
    return instance;
}

- (NSArray *) getLocationSuggestions:(NSString *)query
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    
    NSString *escapedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *queryURL = [NSString stringWithFormat:@"%@query=%@&key=%@", googlePlacesURL, escapedQuery, googlePlacesAPIKey];
    
    //Check which API to use based on number of days until end of trip. Should me moved out.
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:queryURL]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:3.0];
    
    NSURLResponse* response;
    NSError* error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    if (error || (result == nil)) {
        return @[];
    }
    
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
    
    if(error) {
        return @[];/* do nothing */
    }
    
    NSArray *results = [jsonResult objectForKey:@"results"];
    
    for( NSDictionary *r in results)
    {
        if(r[@"name"] && r[@"geometry"] && r[@"geometry"][@"location"])
        {
            NSMutableDictionary *sugesstion = r[@"geometry"][@"location"];
            [sugesstion setObject:r[@"name"] forKey:@"name"];
            [retVal addObject:sugesstion];
        }
    }
    
    return [retVal copy];
}

@end


