//
//  TShirt.m
//  PackManager
//
//  Created by Alex Sanciangco on 5/3/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "TShirt.h"

@implementation TShirt

- (instancetype) init
{
    if (self = [super init])
    {
        self.name = @"TShirt";
        self.quantity = 0;
    }
    return self;
}

@end
