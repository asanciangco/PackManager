//
//  NSCodingHelper.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/6/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "NSCodingHelper.h"

@implementation NSCodingHelper

+ (NSData *) dataForArray:(NSMutableArray*)array
{
    return [NSKeyedArchiver archivedDataWithRootObject:array];
}

+ (NSMutableArray *) mutableArrayFromData:(NSData*)data
{
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (array)
        return array;
    else
        return [NSMutableArray array];
}

@end
