//
//  PackingListViewController.h
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface PackingListViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) Trip *trip;

@end
