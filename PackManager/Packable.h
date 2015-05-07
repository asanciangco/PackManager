//
//  Packable.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#ifndef PackManager_Packable_h
#define PackManager_Packable_h

#import <Foundation/Foundation.h>

/**
 Simple class to represent packable objects (i.e. T-shirts, pants, etc)
 */
@interface Packable : NSObject <NSCoding>

/**
  The name of the packable object
*/
@property (nonatomic, strong) NSString *name;

/**
  The quantity of that packable object
*/
@property NSInteger quantity;

/**
 Initialize a packable item with an initial quantity
 @param quantity The quantity to store
 */
- (instancetype) initWithQuantity:(NSUInteger)quantity;

@end

#endif
