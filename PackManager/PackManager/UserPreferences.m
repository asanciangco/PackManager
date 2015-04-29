//
//  UserPreferences.m
//  PackManager
//
//  Created by Heather Blockhus on 4/21/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPreferences.h"

static UserPreferences *sharedInstance;

NSInteger defaultHotTemp    = 90;
NSInteger defaultWarmTemp   = 80;
NSInteger defaultNormalTemp = 70;
NSInteger defaultCoolTemp   = 60;
NSInteger defaultColdTemp   = 50;

@implementation UserPreferences

// Get the shared instance //
/////////////////////////////
#pragma mark - Accessing sharedInstance
+ (instancetype) sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [UserPreferences initWithDefaults];
    }
    return sharedInstance;
}

+ (instancetype) initWithDefaults
{
    UserPreferences *preferences;
    
    if ((preferences = [[UserPreferences alloc] init]))
    {
        if ([preferences getHotTemp] == 0)
            [[NSUserDefaults standardUserDefaults] setFloat:defaultHotTemp forKey:@"hotTemp"];
        
        if ([preferences getWarmTemp] == 0)
            [[NSUserDefaults standardUserDefaults] setFloat:defaultWarmTemp forKey:@"warmTemp"];
        
        if ([preferences getNormalTemp] == 0)
            [[NSUserDefaults standardUserDefaults] setFloat:defaultNormalTemp forKey:@"normalTemp"];
        
        if ([preferences getCoolTemp] == 0)
            [[NSUserDefaults standardUserDefaults] setFloat:defaultCoolTemp forKey:@"coolTemp"];
        
        if ([preferences getColdTemp] == 0)
            [[NSUserDefaults standardUserDefaults] setFloat:defaultColdTemp forKey:@"coldTemp"];
        
//        [preferences setHotTemp:defaultHotTemp];
//        [preferences setWarmTemp:defaultWarmTemp];
//        [preferences setNormalTemp:defaultNormalTemp];
//        [preferences setCoolTemp:defaultCoolTemp];
//        [preferences setColdTemp:defaultColdTemp];
        
        [preferences setSwimmingPreference:NO];
        [preferences setFormalPreference:NO];
        [preferences setRewearJeansPreference:NO];
        [preferences setAccessToLaundryPreference:NO];
    }
    return preferences;
}

#pragma mark - Temperature Settings
// Temperature Settings //
//////////////////////////
- (float) getHotTemp
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"hotTemp"];
}

- (float) getWarmTemp;
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"warmTemp"];
}

- (float) getNormalTemp
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"normalTemp"];
}

- (float) getCoolTemp
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"coolTemp"];
}

- (float) getColdTemp
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"coldTemp"];
}

- (BOOL) setHotTemp:(float)temp
{
    [[NSUserDefaults standardUserDefaults] setFloat:temp forKey:@"hotTemp"];
    if (temp >= [self getWarmTemp]
        && temp >= [self getNormalTemp]
        && temp >= [self getCoolTemp]
        && temp >= [self getColdTemp])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) setWarmTemp:(float)temp
{
    [[NSUserDefaults standardUserDefaults] setFloat:temp forKey:@"warmTemp"];
    if (temp <= [self getHotTemp]
        && temp >= [self getNormalTemp]
        && temp >= [self getCoolTemp]
        && temp >= [self getColdTemp])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) setNormalTemp:(float)temp
{
    [[NSUserDefaults standardUserDefaults] setFloat:temp forKey:@"normalTemp"];
    if (temp <= [self getHotTemp]
        && temp <= [self getWarmTemp]
        && temp >= [self getCoolTemp]
        && temp >= [self getColdTemp])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) setCoolTemp:(float)temp
{
    [[NSUserDefaults standardUserDefaults] setFloat:temp forKey:@"coolTemp"];
    if (temp <= [self getHotTemp]
        && temp <= [self getWarmTemp]
        && temp <= [self getNormalTemp]
        && temp >= [self getColdTemp])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) setColdTemp:(float)temp
{
    [[NSUserDefaults standardUserDefaults] setFloat:temp forKey:@"coldTemp"];
    if (temp <= [self getHotTemp]
        && temp <= [self getWarmTemp]
        && temp <= [self getNormalTemp]
        && temp <= [self getCoolTemp])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Default Settings
// Default Settings //
//////////////////////
- (BOOL) getSwimmingPreference
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"swimmingPreference"];
}

- (BOOL) getFormalPreference
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"formalPreference"];
}

- (BOOL) getRewearJeansPreference
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"rewearJeansPreference"];
}

- (BOOL) getAccessToLaundryPreference
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"accessToLaundryPreference"];
}

- (void) setSwimmingPreference:(BOOL)pref
{
    [[NSUserDefaults standardUserDefaults] setBool:pref forKey:@"swimmingPreference"];
}

- (void) setFormalPreference:(BOOL)pref
{
    [[NSUserDefaults standardUserDefaults] setBool:pref forKey:@"formalPreference"];
}

- (void) setRewearJeansPreference:(BOOL)pref
{
    [[NSUserDefaults standardUserDefaults] setBool:pref forKey:@"rewearJeansPreference"];
}

- (void) setAccessToLaundryPreference:(BOOL)pref
{
    [[NSUserDefaults standardUserDefaults] setBool:pref forKey:@"accessToLaundryPreference"];
}

#pragma mark - User Info
// User Info //
///////////////
- (Gender) getGender
{
    return (Gender)[[NSUserDefaults standardUserDefaults] integerForKey:@"userGender"];
}

- (void) setGender:(Gender)gen
{
    // Sanity check
    if (gen != MALE && gen != FEMALE)
        return;
    
    [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)gen forKey:@"userGender"];
}

- (TempFormat) getTempFormat
{
    return (TempFormat)[[NSUserDefaults standardUserDefaults] integerForKey:@"tempFormat"];
}

- (void) setTempFormat:(TempFormat)format
{
    // Sanity check
    if (format != FAHRENHEIT && format != CELSIUS)
        return;
    
    if([self getTempFormat] != format)
        [self convertTempsToFormat:format];
    [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)format forKey:@"tempFormat"];
}

- (void) convertTempsToFormat:(TempFormat)format
{
    switch (format) {
        case CELSIUS:
        {
            [self setHotTemp:(([self getHotTemp] - 32.0) * 5.0/9.0)];
            [self setWarmTemp:(([self getWarmTemp] - 32.0) * 5.0/9.0)];
            [self setNormalTemp:(([self getNormalTemp] - 32.0) * 5.0/9.0)];
            [self setCoolTemp:(([self getCoolTemp] - 32.0) * 5.0/9.0)];
            [self setColdTemp:(([self getColdTemp] - 32.0) * 5.0/9.0)];
        }
            break;
        case FAHRENHEIT:
        {
            [self setHotTemp:([self getHotTemp] * 9.0/5.0 + 32.0)];
            [self setWarmTemp:([self getWarmTemp] * 9.0/5.0 + 32.0)];
            [self setNormalTemp:([self getNormalTemp] * 9.0/5.0 + 32.0)];
            [self setCoolTemp:([self getCoolTemp] * 9.0/5.0 + 32.0)];
            [self setColdTemp:([self getColdTemp] * 9.0/5.0 + 32.0)];
        }
            break;
        default:
            break;
    }
}

@end