//
//  WeatherDay.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
	Class representing a day's weather
*/
@interface WeatherDay : NSObject <NSCoding>

/**
	The day's high temperature
*/
@property NSInteger high;

/** 
	The day's low temperature
*/
@property NSInteger low;

/** 
	The day's precipitation chance
*/
@property CGFloat precipitaion;

/**
    Custom getter
 */
@property (nonatomic) NSInteger averageTemp;

/**
    Custom getter 
 */
@property (nonatomic) NSInteger range;

@property (nonatomic, strong) NSDate *date;

/**
	Initialize a new DWeatherDay object
	@param high The day's high
	@param low The day's low
	@param prec The days precipitation chance
*/
- (instancetype) initWithHigh:(NSInteger)high
                          low:(NSInteger)low
                precipitation:(CGFloat)prec
                         date:(NSDate*)date;

@end
