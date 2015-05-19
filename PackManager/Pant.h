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

@end
