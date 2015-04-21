//
//  UserPreferences.h
//  PackManager
//
//  Created by Heather Blockhus on 4/21/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPreferences : NSObject

typedef enum
{
    FEMALE = 0,
    MALE = 1,
} Gender;

typedef enum
{
    CELCIUS = 0,
    FARENHEIGHT = 1,
} TempFormat;

// Get the shared instance //
/////////////////////////////
+(instancetype) sharedInstance;

// Temperature Settings //
//////////////////////////
- (float) getHotTemp;
- (float) getWarmTemp;
- (float) getNormalTemp;
- (float) getCoolTemp;
- (float) getColdTemp;

- (BOOL) setHotTemp:(float)temp;
- (BOOL) setWarmTemp:(float)temp;
- (BOOL) setNormalTemp:(float)temp;
- (BOOL) setCoolTemp:(float)temp;
- (BOOL) setColdTemp:(float)temp;

// Default Settings //
//////////////////////
- (BOOL) getSwimmingPreference;
- (BOOL) getFormalPreference;
- (BOOL) getRewearJeansPreference;
- (BOOL) getAccessToLaundryPreference;

- (void) setSwimmingPreference:(BOOL)pref;
- (void) setFormalPreference:(BOOL)pref;
- (void) setRewearJeansPreference:(BOOL)pref;
- (void) setAccessToLaundryPreference:(BOOL)pref;

// User Info //
///////////////
- (Gender) getGender;
- (void) setGender:(Gender)gen;

- (TempFormat) getTempFormat;
- (void) setTempFormat:(TempFormat)format;

@end