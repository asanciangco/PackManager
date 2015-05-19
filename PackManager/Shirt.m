
//
//  Shirt.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/19/15.
//
//

#import "Shirt.h"

@implementation Shirt

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

@end
