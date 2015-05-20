//
//  Pant.h
//  PackManager
//
//  Created by Alex Sanciangco on 5/19/15.
//
//

#import "Packable.h"

@interface Pant : Packable

/**
 Enum that determines the type of pants
 */
typedef enum PantType
{
    SHORTS,
    JEANS,
    LONGPANTS,
} PantType;

/**
 The type of pants
 */
@property PantType pantType;

/**
 Enhanced initializer to handle type as well as quantity.
 
 @param quantity The quantity of this type of pant
 @param type The type of pant, as defined by PantType
 */
- (instancetype) initWithQuantity:(NSUInteger)quantity andType:(PantType)type;

@end
