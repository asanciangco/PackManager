//
//  NewTripViewController.h
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Trip.h"

@interface NewTripViewController : UITableViewController <UITextFieldDelegate, MKMapViewDelegate>

@property (nonatomic, strong) Trip *trip;

@end
