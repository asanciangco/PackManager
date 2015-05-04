//
//  TShirt.h
//  PackManager
//
//  Created by Alex Sanciangco on 5/3/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Packable.h"

@interface TShirt : NSObject <Packable>

@property (nonatomic, strong) NSString *name;
@property NSInteger quantity;

@end
