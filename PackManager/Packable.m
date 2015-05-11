//
//  Packable.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/4/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Packable.h"


@implementation Packable

- (instancetype) initWithQuantity:(NSUInteger)quantity
{
    if (self = [self init])
    {
        self.quantity = quantity;
    }
    return self;
}

#pragma mark - Encoding / Decoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.quantity forKey:@"quantity"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.quantity = [aDecoder decodeIntegerForKey:@"quantity"];
    }
    return self;
}

@end