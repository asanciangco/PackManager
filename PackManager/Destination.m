//
//  Destination.m
//  PackManager
//
//  Created by Alex Sanciangco on 4/21/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "Destination.h"

/**
 Destination class maintains stops for a trip. It is responsible for maintaining destination location and duration of stay at said location.
 */
@implementation Destination


/**
 Add validation logic to set (should not be negative!)
 */

@synthesize duration = _duration;  //Must do this

//Setter method
- (void) setDuration:(NSInteger)duration{
    if (duration < 0) {
        @throw [NSException exceptionWithName:@"Negative Duration" reason:@"" userInfo:nil];
    }
    
    _duration = duration;
}


#pragma mark - Meta and Helper Functions
// TODO: Implement this
- (BOOL) valid
{
    return YES;
}

- (BOOL) isValidZIP:(NSInteger)zip
{
    return YES;
}

#pragma mark - Encoding / Decoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.duration forKey:@"duration"];
    [aCoder encodeInteger:self.zip forKey:@"zip"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.duration = [aDecoder decodeIntegerForKey:@"duration"];
        self.zip = [aDecoder decodeIntegerForKey:@"zip"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}



@end
