//
//  NewTripViewController.m
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "NewTripViewController.h"

@interface NewTripViewController ()
@property (weak, nonatomic) IBOutlet UITableView *newTripInfoTableView;

@end

@implementation NewTripViewController
{
    NSIndexPath *tripNameIndexPath;
    NSIndexPath *firstLocationIndexPath;
    NSIndexPath *startDateIndexPath;
    NSIndexPath *startDatePickerIndexPath;
    NSIndexPath *firstDurationIndexPath;
    NSInteger numStops;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trip = [[Trip alloc] initNewTrip];
    
    tripNameIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    firstLocationIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    startDateIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    startDatePickerIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    firstDurationIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    
    numStops = 1;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView functions


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
