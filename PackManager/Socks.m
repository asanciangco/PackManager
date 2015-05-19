//
//  Socks.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/19/15.
//
//

#import "Socks.h"

@implementation Socks

- (instancetype) initWithQuantity:(NSUInteger)quantity
{
    if (self = [super initWithQuantity:quantity])
    {
        self.name = @"Socks";
    }
    return self;
}

@end
