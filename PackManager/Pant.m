//
//  Pant.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/19/15.
//
//

#import "Pant.h"

@implementation Pant

#pragma mark - Initializer
- (instancetype) initWithQuantity:(NSUInteger)quantity andType:(PantType)type
{
    if (self = [super initWithQuantity:quantity])
    {
        self.pantType = type;
    }
    return self;
}

/**
 For decoding purposes, convert name into type
 @param name Name of object
 @returns type referring to specific name. -1 if unrecognized name.
 */
- (PantType) pantTypeFromName:(NSString *)name
{
    if ([name isEqualToString:@"Shors"])
        return SHORTS;
    else if ([name isEqualToString:@"Jeans"])
        return JEANS;
    else if ([name isEqualToString:@"Long Pants"])
        return LONGPANTS;
    else
        return -1;
}

#pragma mark - Overridden Methods
/**
 Overrides getter from parent class.
 @returns NSString name of item, depending on object's pantType.
 */
- (NSString *) name
{
    switch (self.pantType)
    {
        case SHORTS:
            return @"Shorts";
        case JEANS:
            return @"Jeans";
        case LONGPANTS:
            return @"Long Pants";
            
        default:
            return @"Pants";
    }
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.quantity = [aDecoder decodeIntegerForKey:@"quantity"];
        self.pantType = [self pantTypeFromName:self.name];
    }
    return self;
}

@end
