//
//  FormalShirt.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/6/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "FormalShirt.h"

@implementation FormalShirt

- (instancetype) init
{
    if (self = [super init])
    {
        self.name = @"Formal Shirt";
        self.quantity = 0;
    }
    return self;
}

@end
