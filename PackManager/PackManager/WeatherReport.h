//
//  WeatherReport.h
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherReport : NSObject

// Returns highest temp for entire report
- (NSInteger) getOverallHigh;

// Returns lowest temp for entire report
- (NSInteger) getOverallLow;



@end
