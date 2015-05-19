//
//  UserPreferences.h
//  PackManager
//
//  Created by Heather Blockhus on 4/21/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
	Class to represent user preferences
*/
@interface UserPreferences : NSObject

/**
	An enumeration of user's gender
*/
typedef enum
{
    FEMALE = 0, /**< Female user */
    MALE = 1, /**< Male user */
} Gender;

typedef enum TempRange
{
    COLD,
    COOL,
    NORMAL,
    WARM,
    HOT,
} TempRange;

/**
	An enumeration of temperature format
*/
typedef enum
{
    CELSIUS = 0, /**< User prefers Celsius */
    FAHRENHEIT = 1, /**< User prefers Farenheit */
} TempFormat;

// Get the shared instance //
/////////////////////////////
/**
	Get the shared instance
	@returns a shared instance of the UserPreferences
*/
+(instancetype) sharedInstance;

// Temperature Settings //
//////////////////////////
/**
	Get what user defines as a hot temperature
	@returns a float representing the user's hot temperature
*/
- (float) getHotTemp;

/**
	Get what user defines as a warm temperature
	@returns a float representing the user's warm temperature
*/
- (float) getWarmTemp;

/**
	Get what user defines as a normal temperature
	@returns a float representing the user's normal temperature
*/
- (float) getNormalTemp;

/**
	Get what user defines as a cool temperature
	@returns a float representing the user's cool temperature
*/
- (float) getCoolTemp;

/**
	Get what user defines as a cold temperature
	@returns a float representing the user's cold temperature
*/
- (float) getColdTemp;

/**
	Set the user's defined hot temperature
	@param temp A float representing a temperature
	@returns returns TRUE is succeeds, otherwise FALSE
*/
- (BOOL) setHotTemp:(float)temp;

/**
	Set the user's defined warm temperature
	@param temp A float representing a temperature
	@returns returns TRUE is succeeds, otherwise FALSE
*/
- (BOOL) setWarmTemp:(float)temp;

/**
	Set the user's defined normal temperature
	@param temp A float representing a temperature
	@returns returns TRUE is succeeds, otherwise FALSE
*/
- (BOOL) setNormalTemp:(float)temp;

/**
	Set the user's defined cool temperature
	@param temp A float representing a temperature
	@returns returns TRUE is succeeds, otherwise FALSE
*/
- (BOOL) setCoolTemp:(float)temp;

/**
	Set the user's defined cold temperature
	@param temp A float representing a temperature
	@returns returns TRUE is succeeds, otherwise FALSE
*/
- (BOOL) setColdTemp:(float)temp;

/**
 Determine the user's set range for a given temperature.
 @param temp the temperature being queried.
 @returns an enum representing the range of the the given temperature
 */
- (TempRange) tempRangeForTemp:(NSInteger)temp;

// Default Settings //
//////////////////////
/**
	Get user's swimming preference
	@returns returns TRUE if user will be swimming, FALSE otherwise
*/
- (BOOL) getSwimmingPreference;

/**
	Get user's Formal clothing preference
	@returns returns TRUE if user will need Formal wear, FALSE otherwise
*/
- (BOOL) getFormalPreference;

/**
	Get user's rewearing of unwashed jeans preference
	@returns returns TRUE if user will wear unwashed jeans, FALSE otherwise
*/
- (BOOL) getRewearJeansPreference;

/**
	Get user's access to laundry
	@returns returns TRUE if user will do laundry on the trip, FALSE otherwise
*/
- (BOOL) getAccessToLaundryPreference;

/**
	Set the user's swimming preference
	@param pref A bool representing if the user is going to swim or not
*/
- (void) setSwimmingPreference:(BOOL)pref;

/**
	Set the user's Formal wear preference
	@param pref A bool representing if the user is going to wear formal clothing
*/
- (void) setFormalPreference:(BOOL)pref;

/**
	Set the user's rewear of jeans preference
	@param pref A bool representing if the user is ok with wearing unwashed jeans
*/
- (void) setRewearJeansPreference:(BOOL)pref;

/**
	Set the user's laundry preference
	@param pref A bool representing if the user is going to do laundry during the trip
*/
- (void) setAccessToLaundryPreference:(BOOL)pref;

// User Info //
///////////////
- (Gender) getGender;

/**
	Set the user's gender
	@param gen The users gender
*/
- (void) setGender:(Gender)gen;

- (TempFormat) getTempFormat;

/**
	Set the temperature format
	@param format The users temperature format
*/
- (void) setTempFormat:(TempFormat)format;

@end