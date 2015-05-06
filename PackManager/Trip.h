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

/**
	A class to represent a trip
*/
@interface Trip : NSObject <NSCoding>

// Basic Trip Info
/**
	The start date of the trip
*/
@property (nonatomic, strong) NSDate *startDate;

/**
	The trip's destinations
 */
@property (nonatomic, strong) NSMutableArray *destinations; // of Destination

/**
	The name of the trip
 */
@property (nonatomic, strong) NSString *name;

/**
	The packing list for the trip
*/
@property (nonatomic, strong) PackingList *packingList;

/**
	The weather report for the trip
*/
@property (nonatomic, strong) WeatherReport *weatherReport;

/////////////////////////////////////////////////////////////////////// Preferences //////////////////////////////////////////////////////////////////////////////////////////////////
/**
	Bool: Will the user be swimming on the trip
*/
@property BOOL swimmingPreference;

/**
	Bool: Will the user require formal clothing
*/
@property BOOL formalPreference;

/**
	Bool: Will the user rewear unwashed jeans
*/
@property BOOL rewearJeansPreference;

/**
	Bool: Will the user be able to do laundry on the trip
*/
@property BOOL accessToLaundryPreference;

/////////////////////////////////////////////////////////////////////// Initializers ////////////////////////////////////////////////////////////////////////////////////
/**
	Initialize a new Trip object
	@param start The trip start date
	@param name The trip name
	@returns a newly initialized object
*/
- (instancetype) initWithStartDate:(NSDate *)start
                              name:(NSString *)name;

/**
	Initialize a new Trip object
	@returns a newly initialized object
*/
- (instancetype) initNewTrip;

///////////////////////////////////////////////////////////////////////// Helpers ////////////////////////////////////////////////////////////////////////////
/**
	Helper Function:
		Returns end date of trip
	@returns date of trip's end
*/
- (NSDate *) endDate;
- (NSInteger) totalDuration;

/** This is the big one. Returns true if everything went OK and
    the packing list is created, false otherwise.

   Examples for why it might return false:
        - invalid destination
        - invalid or NULL weather report
        - start date / duration is NULL
    @returns TRUE if everything went ok, otherwise returns FALSE
*/
- (BOOL) generatePackingList;

@end
