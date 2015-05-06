//
//  FirstViewController.m
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "TripsViewController.h"
#import "Trip.h"
#import "TripsData.h"
#import "PackingListViewController.h"
#import "NewTripViewController.h"

@interface TripsViewController ()

@end

@implementation TripsViewController {
    Trip *trip;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView delagate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[TripsData sharedInstance] numberOfTrips];
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     static NSString *CellIdentifier = @"TripCell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if ( cell == nil ) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
     }
     
     trip = [[TripsData sharedInstance] getTrip:indexPath.row];
     
     cell.textLabel.text = trip.name;
     cell.detailTextLabel.text = [NSString stringWithFormat:@"%li days", (long)[trip totalDuration]];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     
     return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    trip = [[TripsData sharedInstance] getTrip:indexPath.row];
    [self performSegueWithIdentifier:@"showPackingList" sender:self];
}

#pragma mark - Navagation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showPackingList"])
    {
        PackingListViewController *plistVC = [segue destinationViewController];
        plistVC.trip = trip;
    }
}

@end
