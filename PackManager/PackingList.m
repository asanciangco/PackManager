//
//  PackingList.m
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "PackingList.h"

@interface PackingList ()

@property (nonatomic, strong) NSMutableArray *list; // of Packable
@property (nonatomic, strong) Trip* trip;

@end

@implementation PackingList

#pragma mark - Initializer
- (instancetype) initPackingListForTrip:(Trip *)trip
{
    if (self = [super init])
    {
        self.trip = trip;
    }
    return self;
}

#pragma mark - Getters
- (NSInteger) getNumberOfUniqueItems
{
    return [self.list count];
}

- (Packable *) getPackableForIndex:(NSInteger)index
{
    return NULL;
}


#pragma mark - Helpers

// TODO: need to finish design
- (NSInteger) quantityForItemAtIndex:(NSInteger)index
{
    PackingItems itemEnum = (PackingItems)index;
    NSNumber *key = [NSNumber numberWithInt:itemEnum];
    return 0;
}

+ (NSString *) stringForItemType:(PackingItems)item
{
    NSString *itemName;
    
    switch (item)
    {
        case SHORT_SLEEVE_SHIRT:
            itemName = @"T-Shirt";
            break;
        case LONG_SLEEVE_SHIRT:
            itemName = @"Long Sleeve Shirt";
            break;
        case FORMAL_SHIRT:
            itemName = @"Formal Shirt";
            break;
        case SHORT_PANT:
            itemName = @"Shorts";
            break;
        case LONG_PANT:
            itemName = @"pants";
            break;
        case SWIMSUIT:
            itemName = @"Swimsuit";
            break;
        case SUIT:
            itemName = @"Suit";
            break;
        case DRESS:
            itemName = @"Dress";
            break;
        case TIE:
            itemName = @"Tie";
            break;
        default:
            itemName = @"ITEM NOT FOUND";
    }
    
    return itemName;
}

#pragma mark - Encoding / Decoding
// TODO: Implement these
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    return 0;
}

@end
