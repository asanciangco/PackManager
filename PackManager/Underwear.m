//
//  Underwear.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/19/15.
//
//

#import "Underwear.h"

@implementation Underwear

- (instancetype) initWithQuantity:(NSUInteger)quantity
{
    if (self = [super initWithQuantity:quantity])
    {
        self.name = @"Underwear";
    }
    return self;
}

@end
