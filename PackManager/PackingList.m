//
//  PackingList.m
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "PackingList.h"
#import "NSCodingHelper.h"

#import "Shirt.h"
#import "Pant.h"

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
        self.list = [NSMutableArray array];
    }
    return self;
}

- (instancetype) initExamplePackingListForTrip:(Trip *)trip 
{
    if (self = [super init])
    {
        self.trip = trip;
        self.list = [NSMutableArray array];
        
        // TODO: update this part for new packable item subclassing
        //
//        [self.list addObjectsFromArray:@[[[Shirt alloc] initWithQuantity:4],
//                                         [[LongSleeveShirt alloc] initWithQuantity:3],
//                                         [[FormalShirt alloc]initWithQuantity:1],
//                                         [[Shorts alloc] initWithQuantity:4],
//                                         ]];
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
    if (!self.list || index < 0 || index >= [self.list count])
        return NULL;
    
    return [self.list objectAtIndex:index];
}


#pragma mark - Helpers
- (NSInteger) quantityForItemAtIndex:(NSInteger)index
{
    Packable *item = [self getPackableForIndex:index];
    if (item)
        return item.quantity;
    else
        return -1;
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
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSCodingHelper dataForArray:self.list] forKey:@"list"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.list = [NSCodingHelper mutableArrayFromData:[aDecoder decodeObjectForKey:@"list"]];
    }
    return self;
}

@end
