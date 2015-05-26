//
//  Shoe.h
//  PackManager
//
//  Created by Alex Sanciangco on 5/19/15.
//
//

#import "Packable.h"

@interface Shoe : Packable

typedef enum ShoeType
{
    FLIPFLOP,
    SANDAL,
    CLOSEDTOE,
    FORMALSHOE,
    RAINBOOTS
} ShoeType;

@property ShoeType shoeType;

- (instancetype) initWithQuantity:(NSUInteger)quantity andType:(ShoeType)type;

@end
