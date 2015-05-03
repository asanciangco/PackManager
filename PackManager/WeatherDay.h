//
//  WeatherDay.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDay : NSObject

@property NSInteger high;
@property NSInteger low;
@property CGFloat   precipitaion;

- (instancetype) initWithHigh:(NSInteger)high
                          low:(NSInteger)low
                precipitation:(CGFloat)prec;

@end
