//
//  Destination.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/21/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Destination : NSObject <NSCoding>

/**
 Duration of the trip, positive value
 */
@property NSInteger duration;

/**
 ZIP Code for the given location
 */
@property NSInteger zip;

// TODO: Establish consistent naming scheme, perhaps store country / state code separately?
@property (nonatomic, strong) NSString *name;

// Returns true if location is a valid place (i.e. it exists)
// false otherwise
- (BOOL) valid;

/**
 Method to validate given ZIP code.
 @param zip ZIP code in question
 @returns TRUE if zip is a valid zip code, false otherwise.
 */
- (BOOL) isValidZIP:(NSInteger)zip;

@end
