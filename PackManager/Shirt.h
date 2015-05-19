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

@end
