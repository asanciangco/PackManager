//
//  NSCodingHelper.h
//  PackManager
//
//  Created by Alex Sanciangco on 5/6/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCodingHelper : NSObject

/**
 Converts an array into NSData object for ease of storage in NSUserDefaults. Must make sure that array's objects conform to NSCoding protocol.
 @param array The array you want to convert
 @returns data object
 */
+ (NSData *) dataForArray:(NSArray*)array;

/**
 Converts NSData object from NSUserDefaults back to an NSMutableArray. If there's a problem with the conversion (e.g. the resulting array is null), an empty mutable array is returned.
 @param data The data object to be converted
 @returns array correspdonding to data object, or new empty array
 */
+ (NSMutableArray *) mutableArrayFromData:(NSData*)data;

@end
