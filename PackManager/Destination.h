//
//  Destination.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/21/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
	Adds some convenience methods to the Destination class
*/
@interface Destination : NSObject <NSCoding>

/** 
	Tests to see if a destination is a valid location
    @Return returns TRUE if location is a valid place (i.e. it exists), otherwise returns FALSE
*/ 
- (BOOL) valid;

@end
