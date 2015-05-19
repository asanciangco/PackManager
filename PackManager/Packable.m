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

#pragma marg - Initializer
- (instancetype) initWithQuantity:(NSUInteger)quantity
{
    if (self = [self init])
    {
        self.quantity = quantity;
    }
    return self;
}

#pragma mark - Helpers
- (NSString *) imageName
{
    return nil;
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

@end // Packable implementation

#pragma mark - Umbrella
@implementation Umbrella

- (instancetype) initWithQuantity:(NSUInteger)quantity
{
    if (self = [super initWithQuantity:quantity])
    {
        self.name = @"Umbrella";
    }
    return self;
}

@end // Umbrella implementation

#pragma mark - Sunscreen
@implementation Sunscreen

- (instancetype) initWithQuantity:(NSUInteger)quantity
{
    if (self = [super initWithQuantity:quantity])
    {
        self.name = @"Sunscreen";
    }
    return self;
}

@end // Sunscreen implementation
