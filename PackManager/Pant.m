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

@end
