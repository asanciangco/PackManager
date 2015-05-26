//
//  Jacket.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/20/15.
//
//

#import "Jacket.h"

@implementation Jacket

#pragma mark - Initializer
- (instancetype) initWithQuantity:(NSUInteger)quantity andType:(JacketType)type
{
    if (self = [super initWithQuantity:quantity])
    {
        self.jacketType = type;
    }
    return self;
}

/**
 For decoding purposes, convert name into type
 @param name Name of object
 @returns type referring to specific name. -1 if unrecognized name.
 */
- (JacketType) shirtTypeFromName:(NSString *)name
{
    if ([name isEqualToString:@"Jacket"])
        return REGULAR_JACKET;
    else if ([name isEqualToString:@"Rain Jacket"])
        return RAIN_JACKET;
    else
        return -1;
}

#pragma mark - Overridden Methods
/**
 Overrides getter from parent class.
 @returns NSString name of item, depending on object's jacketType.
 */
- (NSString *) name
{
    switch (self.jacketType)
    {
        case REGULAR_JACKET:
            return @"Jacket";
        case RAIN_JACKET:
            return @"Rain Jacket";
            
        default:
            return @"Jacket";
    }
}

- (NSString *) imageName
{
    switch (self.jacketType)
    {
        case REGULAR_JACKET:
            return @"clothing_jacket_11";
        case RAIN_JACKET:
            return @"clothing_jacket_10";
            
        default:
            return @"Jacket";
    }
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.quantity = [aDecoder decodeIntegerForKey:@"quantity"];
        self.jacketType = [self shirtTypeFromName:self.name];
    }
    return self;
}

@end
