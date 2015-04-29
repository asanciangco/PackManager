//
//  PackingList.m
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "PackingList.h"

@interface PackingList ()

@property (nonatomic, strong) NSMutableDictionary *list;

@end

@implementation PackingList

#pragma mark - MetaData
- (NSInteger) getNumberOfUniqueItems
{
    return [self.list count];
}

#pragma mark - Helpers
- (NSString *) stringForItemType:(PackingItems)item
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
