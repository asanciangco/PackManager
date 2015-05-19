//
//  Shoe.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/19/15.
//
//

#import "Shoe.h"

@implementation Shoe

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
        case FORMAL:
            return @"Formal Shoes";
        case RAINBOOTS:
            return @"Rain Boots";
            
        default:
            return @"Shoes";
    }
}

@end
