//
//  WeatherDay.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDay : NSObject

@property NSInteger high;   // to float
@property NSInteger low;    // to float
@property CGFloat   precipitaion;
@property (nonatomic, strong) NSDate *date;

// corresponding floats here
- (instancetype) initWithHigh:(NSInteger)high
                          low:(NSInteger)low
                precipitation:(CGFloat)prec
                         date:(NSDate*)date;

@end
