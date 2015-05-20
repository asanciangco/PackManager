//
//  Jacket.h
//  PackManager
//
//  Created by Alex Sanciangco on 5/20/15.
//
//

#import "Packable.h"

@interface Jacket : Packable

/**
 Enum that determines the type of jacket
 */
typedef enum JacketType
{
    REGULAR_JACKET,
    RAIN_JACKET,
} JacketType;

/**
 The type of jacket
 */
@property JacketType jacketType;

/**
 Enhanced initializer to handle type as well as quantity.
 
 @param quantity The quantity of this type of Jacket
 @param type The type of jacket, as defined by JacketType
 */
- (instancetype) initWithQuantity:(NSUInteger)quantity andType:(JacketType)type;

@end
