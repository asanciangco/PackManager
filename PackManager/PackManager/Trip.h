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

@interface Trip : NSObject <NSCoding>

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) Destination *destination;
@property (nonatomic, strong) NSString *name;
@property NSInteger duration;   // in days

@property (nonatomic, strong) PackingList *packingList;

// Initializers //
//////////////////
- (instancetype) initWithStartDate:(NSDate *)start
                          duration:(NSInteger)numDays
                       destination:(Destination *)dest
                              name:(NSString *)name;

// Helpers //
/////////////
- (NSDate *) endDate;

@end
