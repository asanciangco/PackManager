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

#pragma mark - Encoding / Decoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.quantity forKey:@"quantity"];
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.quantity = [aDecoder decodeIntegerForKey:@"quantity"];
        self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
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
        self.imageName = @"clothing_umbrella_5";
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
        self.imageName = @"clothing_sunscreen_4";
    }
    return self;
}

@end // Sunscreen implementation

#pragma mark - Underwear
@implementation Underwear

- (instancetype) initWithQuantity:(NSUInteger)quantity
{
    if (self = [super initWithQuantity:quantity])
    {
        self.name = @"Underwear";
        self.imageName = @"clothing_underwear_1";
    }
    return self;
}

@end // Underwear implementation

#pragma mark - Socks
@implementation Socks

- (instancetype) initWithQuantity:(NSUInteger)quantity
{
    if (self = [super initWithQuantity:quantity])
    {
        self.name = @"Socks";
        self.imageName = @"clothing_socks_2";
    }
    return self;
}

@end // Socks implementation
