//
//  Destination.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/21/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Destination : NSObject <NSCoding>

// Returns true if location is a valid place (i.e. it exists)
// false otherwise
- (BOOL) valid;

@end
