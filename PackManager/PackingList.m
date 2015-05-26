//
//  PackingList.m
//  PackManager
//
//  Created by Alex Sanciangco on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "PackingList.h"
#import "NSCodingHelper.h"
#import "UserPreferences.h"

#import "Packable.h"
#import "Shirt.h"
#import "Pant.h"
#import "Jacket.h"
#import "Shoe.h"

@interface PackingList ()

@property (nonatomic, strong) NSMutableArray *list; // of Packable

@end

@implementation PackingList
{
    // tops
    CGFloat lightShirts;
    CGFloat heavyShirts;
    CGFloat tankTops;
    
    // formal wear
    CGFloat formalShirts;
    CGFloat formalPants;
    
    // bottoms
    CGFloat lightPants;
    CGFloat heavyPants;
    
    // shoes
    CGFloat flipFlops;
    CGFloat closedToeShoes;
    
    // Jacket
    CGFloat regularJacket;
    
    // clothing accessories
    CGFloat underwear;
    CGFloat regularSocks;
    
    // rain
    CGFloat rain;
}

#pragma mark - Initializer
- (instancetype) initPackingListForTrip:(Trip *)trip
{
    if (self = [super init])
    {
        self.trip = trip;
        self.list = [NSMutableArray array];
        
        lightShirts = 0;
        heavyShirts = 0;
        tankTops = 0;
        
        formalShirts = 0;
        formalPants  = 0;
        
        lightPants = 0;
        heavyPants = 0;
        
        flipFlops = 0;
        closedToeShoes = 0;
        
        regularJacket = 0;
        
        underwear = 0;
        regularSocks = 0;
        
        rain = 0;
    }
    return self;
}

- (instancetype) initExamplePackingListForTrip:(Trip *)trip 
{
    if (self = [super init])
    {
        self.trip = trip;
        self.list = [NSMutableArray array];
        
        // TODO: update this part for new packable item subclassing
        //
//        [self.list addObjectsFromArray:@[[[Shirt alloc] initWithQuantity:4],
//                                         [[LongSleeveShirt alloc] initWithQuantity:3],
//                                         [[FormalShirt alloc]initWithQuantity:1],
//                                         [[Shorts alloc] initWithQuantity:4],
//                                         ]];
        
        [self generatePackingList];
    }
    return self;
}

#pragma mark - Packing Algorithm
/**
 The algorithm that will generate the packing list. It must already be determined that the trip has a valid weather report since this algorithm will depend on it. This function will populate the PackingList's 'list' member variable with Packable items. 
 */
- (void) generatePackingList
{
    WeatherReport *report   = self.trip.weatherReport;
    
    // Loop through the days, calling
    //      update tops
    //      update pants
    //      update accessories
    // for each day
    for (NSInteger dayIndex = 0; dayIndex < [report numberOfDays]; dayIndex++)
    {
        WeatherDay *day = [report.weatherDays objectAtIndex:dayIndex];

        [self updateTopsForDay:day];
        [self updatePantsForDay:day];
        [self updateAccessoriesForDay:day];
    }
    
    // Populate list with necessary items //
    ////////////////////////////////////////
    [self populateShirts];
    [self populatePants];
    [self populateAccessories];
}

/**
 Updates the running variables responsible for maintaining state through packing algorithm, specifically for shirts.
 @param day The weatherDay object being used for current calculations.
 */
- (void) updateTopsForDay:(WeatherDay *)day
{
    NSInteger averageTemp = [day averageTemp];
    TempRange range = [[UserPreferences sharedInstance] tempRangeForTemp:averageTemp];
    
    if (self.trip.formalPreference)
    {
        formalShirts += 0.75;
    }
    
    // Regular shirts and jackets
    switch (range)
    {
        case COLD:
        {
            heavyShirts += 1;
            lightShirts += 0;
            
            regularJacket += 0.25;      // 1 jacket per 4 days
        }
            break;
        case COOL:
        {
            heavyShirts += 0.75;
            lightShirts += 0.25;
            
            regularJacket += 0.125;     // 1 jacket per 8 days
        }
            break;
        case NORMAL:
        {
            heavyShirts += 0.5;
            lightShirts += 0.5;
        }
            break;
        case WARM:
        {
            heavyShirts += 0.25;
            lightShirts += 0.75;
        }
            break;
        case HOT:
        {
            heavyShirts += 0;
            lightShirts += 0.5;
            tankTops    += 0.5;
        }
            break;
    }
}

/**
 Updates the running variables responsible for maintaining state through packing algorithm, specifically for pants.
 @param day The weatherDay object being used for current calculations.
 */
- (void) updatePantsForDay:(WeatherDay *)day
{
    NSInteger averageTemp = [day averageTemp];
    TempRange range = [[UserPreferences sharedInstance] tempRangeForTemp:averageTemp];
    
    // Formal Wear
    if (self.trip.formalPreference)
    {
        formalPants += 0.75;
    }
    
    // Regualr pants
    switch (range)
    {
        case COLD:
        {
            heavyPants += 1;
            lightPants += 0;
        }
            break;
        case COOL:
        {
            heavyPants += 0.75;
            lightPants += 0.25;
        }
            break;
        case NORMAL:
        {
            heavyPants += 0.5;
            lightPants += 0.5;
        }
            break;
        case WARM:
        {
            heavyPants += 0.25;
            lightPants += 0.75;
        }
            break;
        case HOT:
        {
            heavyPants += 0;
            lightPants += 1;
        }
            break;
    }
}

/**
 Updates the running variables responsible for maintaining state through packing algorithm.
 @param day The weatherDay object being used for current calculations.
 */
- (void) updateAccessoriesForDay:(WeatherDay *)day
{
    NSInteger averageTemp = [day averageTemp];
    TempRange range = [[UserPreferences sharedInstance] tempRangeForTemp:averageTemp];
    CGFloat prec = [day precipitaion];
    
    underwear    += (8.0 / 7.0);    // extra pair of underwear for every week
    regularSocks += (8.0 / 7.0);    // extra pair of socks per week
    
    rain += prec / 2.0;
    
    // Shoes
    // Notice the specific breaks, this utilizes fall-through of switch blocks
    switch (range)
    {
        case COLD:
        case COOL:
        case NORMAL:
        {
            closedToeShoes += 0.25;
        }
            break;
        case WARM:
        {
            closedToeShoes += 0.1;
        }
        case HOT:
        {
            flipFlops += 0.25;
        }
            break;
    }
}

/**
 Pupulates the packing list with shirts based on previous calculations. This is a helper method called from within generatePackingList.
 */
- (void) populateShirts
{
    if (lightShirts > 0)
    {
        [self.list addObject:[[Shirt alloc] initWithQuantity:ceilf(lightShirts)
                                                     andType:TSHIRT]];
    }
    if (heavyShirts > 0)
    {
        [self.list addObject:[[Shirt alloc] initWithQuantity:ceilf(heavyShirts)
                                                     andType:LONGSLEEVE]];
    }
    if (formalShirts > 0)
    {
        [self.list addObject:[[Shirt alloc] initWithQuantity:formalShirts
                                                     andType:FORMAL]];
    }
}

/**
 Pupulates the packing list with pants based on previous calculations. This is a helper method called from within generatePackingList.
 */
- (void) populatePants
{
    if (lightPants > 0)
    {
        [self.list addObject:[[Pant alloc] initWithQuantity:ceilf(lightPants)
                                                    andType:SHORTS]];
    }
    if (heavyPants > 0)
    {
        [self.list addObject:[[Pant alloc] initWithQuantity:ceilf(heavyPants)
                                                   andType:LONGPANTS]];
    }
    if (formalPants > 0)
    {
        [self.list addObject:[[Pant alloc] initWithQuantity:formalPants
                                                    andType:FORMALPANTS]];
    }
}

/**
 Pupulates the packing list with accessories based on previous calculations. This is a helper method called from within generatePackingList.
 */
- (void) populateAccessories
{
    // JACKET
    if (regularJacket > 0)
    {
        [self.list addObject:[[Jacket alloc] initWithQuantity:ceilf(regularJacket)
                                                      andType:REGULAR_JACKET]];
    }
    
    // RAIN GEAR
    if (rain > 0.2)
    {
        [self.list addObject:[[Jacket alloc] initWithQuantity:1 andType:RAIN_JACKET]];
    }
    if (rain >= 0.5)
    {
        // UMBRELLA gets added in addition to a rain jacket
        [self.list addObject:[[Umbrella alloc] initWithQuantity:1]];
        // RAIN BOOTS also get added
        [self.list addObject:[[Shoe alloc] initWithQuantity:1 andType:RAINBOOTS]];
    }
    
    if (rain < 1)
    {
        [self.list addObject:[[Sunscreen alloc] initWithQuantity:1]];
    }
    
    // UNDERWEAR
    if (underwear > 0)
    {
        [self.list addObject:[[Underwear alloc] initWithQuantity:ceilf(underwear)]];
    }
    
    // REGULAR SOCKS
    if (regularSocks > 0)
    {
        [self.list addObject:[[Socks alloc] initWithQuantity:ceilf(regularSocks)]];
    }
}

#pragma mark - Getters
- (NSInteger) getNumberOfUniqueItems
{
    return [self.list count];
}

- (Packable *) getPackableForIndex:(NSInteger)index
{
    if (!self.list || index < 0 || index >= [self.list count])
        return NULL;
    
    return [self.list objectAtIndex:index];
}

- (void) removeItemForIndex:(NSInteger)index
{
    [self.list removeObjectAtIndex:index];
}

- (void) changeQuantityForIndex:(NSInteger)index to:(NSInteger)q
{
    Packable *item = [self.list objectAtIndex:index];
    item.quantity = q;
}

#pragma mark - Helpers
- (NSInteger) quantityForItemAtIndex:(NSInteger)index
{
    Packable *item = [self getPackableForIndex:index];
    if (item)
        return item.quantity;
    else
        return -1;
}

#pragma mark - Encoding / Decoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSCodingHelper dataForArray:self.list] forKey:@"list"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.list = [NSCodingHelper mutableArrayFromData:[aDecoder decodeObjectForKey:@"list"]];
    }
    return self;
}

#pragma mark - Testing
- (void) printList
{
    NSLog(@"Packing List:");
    
    for (Packable *item in self.list)
    {
        NSLog(@"\tItem: %@; \tQuantity: %ld", item.name, (long)item.quantity);
    }
    
}

@end
