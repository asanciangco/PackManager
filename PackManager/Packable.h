//
//  Packable.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#ifndef PackManager_Packable_h
#define PackManager_Packable_h

#import <Foundation/Foundation.h>

@interface Packable : NSObject

@property (nonatomic, strong) NSString *name;
@property NSInteger quantity;

@end

#endif
