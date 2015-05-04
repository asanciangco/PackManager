//
//  Trip.h
//  
//
//  Created by Alex Sanciangco on 4/21/15.
//
//

#import <Foundation/Foundation.h>
#import "Destination.h"
#import "PackingList.h"
#import "WeatherReport.h"

@class PackingList;

@interface Trip : NSObject <NSCoding>

// Basic Trip Info
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSMutableArray *destinations; // of Destination
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *durations;    // of NSIntegers (NSNumber's of days)

@property (nonatomic, strong) PackingList *packingList;
@property (nonatomic, strong) WeatherReport *weatherReport;

// Preferences
@property BOOL swimmingPreference;
@property BOOL formalPreference;
@property BOOL rewearJeansPreference;
@property BOOL accessToLaundryPreference;

// Initializers //
//////////////////
- (instancetype) initWithStartDate:(NSDate *)start
                              name:(NSString *)name;

- (instancetype) initNewTrip;

// Helpers //
/////////////
- (NSDate *) endDate;
- (NSInteger) totalDuration;

// This is the big one. Returns true if everything went OK and
// the packing list is created, false otherwise.
//
// Examples for why it might return false:
//      - invalid destination
//      - invalid or NULL weather report
//      - start date / duration is NULL
- (BOOL) generatePackingList;

@end
