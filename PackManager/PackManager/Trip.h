//
//  Trip.h
//  
//
//  Created by Alex Sanciangco on 4/21/15.
//
//

#import <Foundation/Foundation.h>
#import "Destination.h"

@interface Trip : NSObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) Destination *destination;
@property NSInteger duration;   // in days

// Initializer //
/////////////////
- (instancetype) initWithStartDate:(NSDate *)start
                          duration:(NSInteger)numDays
                       destination:(Destination *)dest;

// Helpers //
/////////////
- (NSDate *) endDate;

@end
