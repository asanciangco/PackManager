//
//  main.m
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "Trip.h"
#import "WeatherAPI.h"

int main(int argc, char * argv[])
{
    
    NSDate *start   = [NSDate dateWithTimeInterval:11 * 24 * 60 * 60 sinceDate:[NSDate date]];
    NSDate *end     = [NSDate dateWithTimeInterval:18 * 24 * 60 * 60 sinceDate:[NSDate date]];
    
    [[WeatherAPI sharedInstance] getLatLongFromAddress: @"Los Angeles" start:start end:end];

    Trip *trip = [[Trip alloc] initNewTrip];
    [trip generatePackingListExample];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
