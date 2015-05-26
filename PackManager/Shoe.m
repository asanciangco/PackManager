//
//  Shoe.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/19/15.
//
//

#import "Shoe.h"

@implementation Shoe

#pragma mark - Initializer
- (instancetype) initWithQuantity:(NSUInteger)quantity andType:(ShoeType)type
{
    if (self = [super initWithQuantity:quantity])
    {
        self.shoeType = type;
    }
    return self;
}

- (NSString *) imageName
{
    switch (self.shoeType) {
        case FLIPFLOP:
            return @"clothing_openToedShoes_flipFlops";
        case SANDAL:
            return @"clothing_openToedShoe_sandal";
        case CLOSEDTOE:
            return @"clothing_casualShoes_2";
        case FORMALSHOE:
            return @"clothing_dressShoesMen_4";
        case RAINBOOTS:
            return @"clothing_boots_7";
            
        default:
            return @"clothing_casualShoes_2";
    }
}

/**
 For decoding purposes, convert name into type
 @param name Name of object
 @returns type referring to specific name. -1 if unrecognized name.
 */
- (ShoeType) shoeTypeFromName:(NSString *)name
{
    if ([name isEqualToString:@"Flip Flops"])
        return FLIPFLOP;
    else if ([name isEqualToString:@"Sandals"])
        return SANDAL;
    else if ([name isEqualToString:@"Closed-Toed Shoes"])
        return CLOSEDTOE;
    else if ([name isEqualToString:@"Formal Shoes"])
        return FORMALSHOE;
    else if ([name isEqualToString:@"Rain Boots"])
        return RAINBOOTS;
    else
        return -1;
}

#pragma mark - Overridden Methods
/**
 Overrides getter from parent class.
 @returns NSString name of item, depending on object's ShoeType.
 */
- (NSString *) name
{
    switch (self.shoeType) {
        case FLIPFLOP:
            return @"Flip Flops";
        case SANDAL:
            return @"Sandals";
        case CLOSEDTOE:
            return @"Closed-Toed Shoes";
        case FORMALSHOE:
            return @"Formal Shoes";
        case RAINBOOTS:
            return @"Rain Boots";
            
        default:
            return @"Shoes";
    }
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.quantity = [aDecoder decodeIntegerForKey:@"quantity"];
        self.shoeType = [self shoeTypeFromName:self.name];
    }
    return self;
}

@end
