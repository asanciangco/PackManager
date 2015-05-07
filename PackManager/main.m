//
//  main.m
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherAPI.h"
#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    [[WeatherAPI sharedInstance] getWeatherFromCity: @"Los Angeles" country: @"US" start:[NSDate date] end:[NSDate dateWithTimeInterval:7 * 24 * 60 * 60 sinceDate:[NSDate date]]];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
