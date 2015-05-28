//
//  BackgroundUpdate.m
//  
//
//  Created by Kacey Ryan on 5/27/15.
//
//

//https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/index.html#//apple_ref/occ/intfm/UIApplicationDelegate/application:performFetchWithCompletionHandler:

//https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/BackgroundExecution/BackgroundExecution.html

#import "BackgroundUpdate.h"

static BackgroundUpdate *sharedInstance;

@implementation BackgroundUpdate

#pragma mark - Accessing sharedInstance
+ (instancetype) sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [BackgroundUpdate initWithDefaults];
    }
    return sharedInstance;
}

+ (instancetype) initWithDefaults
{
    BackgroundUpdate *instance;
    
    if (!instance)
    {
        instance = [[BackgroundUpdate alloc] init];
    }
    return instance;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Core Fuctions



@end
