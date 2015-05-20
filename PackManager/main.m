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

int main(int argc, char * argv[])
{
    
    Trip *trip = [[Trip alloc] initNewTrip];
    [trip generatePackingListExample];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
