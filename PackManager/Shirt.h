//
//  Shirt.h
//  PackManager
//
//  Created by Alex Sanciangco on 5/19/15.
//
//

#import <Foundation/Foundation.h>
#import "Packable.h"

@interface Shirt : Packable

/**
 Enum that determines the type of shirt
 */
typedef enum ShirtType
{
    TSHIRT,
    LONGSLEEVE,
    FORMAL,
    TANKTOP,
} ShirtType;

/**
 The type of shirt
 */
@property ShirtType shirtType;

/**
 Enhanced initializer to handle type as well as quantity.
 
 @param quantity The quantity of this type of shirt
 @param type The type of shirt, as defined by ShirtType
 */
- (instancetype) initWithQuantity:(NSUInteger)quantity andType:(ShirtType)type;

@end
