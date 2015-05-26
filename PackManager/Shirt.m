
//
//  Shirt.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/19/15.
//
//

#import "Shirt.h"

@implementation Shirt

#pragma mark - Initializer
- (instancetype) initWithQuantity:(NSUInteger)quantity andType:(ShirtType)type
{
    if (self = [super initWithQuantity:quantity])
    {
        self.shirtType = type;
    }
    return self;
}

- (NSString *) imageName
{
    switch (self.shirtType)
    {
        case TSHIRT:
            return @"clothing_tshirt_1";
        case LONGSLEEVE:
            return @"clothing_longsleeve_4";
        case FORMAL:
            // TODO change to basic image
            return @"clothing_dressShirt_6";
        case TANKTOP:
            return @"clothing_tanktop_3";
            
        default:
            return @"clothing_tshirt_1";
    }
}

/**
 For decoding purposes, convert name into type
 @param name Name of object
 @returns type referring to specific name. -1 if unrecognized name.
 */
- (ShirtType) shirtTypeFromName:(NSString *)name
{
    if ([name isEqualToString:@"T-Shirt"])
        return TSHIRT;
    else if ([name isEqualToString:@"Long Sleeve Shirt"])
        return LONGSLEEVE;
    else if ([name isEqualToString:@"Formal Shirt"])
        return FORMAL;
    else if ([name isEqualToString:@"Tanktop"])
        return TANKTOP;
    else
        return -1;
}

#pragma mark - Overridden Methods
/**
 Overrides getter from parent class.
 @returns NSString name of item, depending on object's shirtType.
 */
- (NSString *) name
{
    switch (self.shirtType)
    {
        case TSHIRT:
            return @"T-Shirt";
        case LONGSLEEVE:
            return @"Long Sleeve Shirt";
        case FORMAL:
            return @"Formal Shirt";
        case TANKTOP:
            return @"Tanktop";
            
        default:
            return @"Shirt";
    }
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.quantity = [aDecoder decodeIntegerForKey:@"quantity"];
        self.shirtType = [self shirtTypeFromName:self.name];
    }
    return self;
}

@end
