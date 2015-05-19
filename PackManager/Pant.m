//
//  Pant.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/19/15.
//
//

#import "Pant.h"

@implementation Pant

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
