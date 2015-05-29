//
//  FirstViewController.m
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "TripsViewController.h"
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

-(void) viewDidAppear:(BOOL)animated
{
    if(self.tripToPass)
    {
        [self performSegueWithIdentifier:@"showPackingList" sender:self];
    }
    else
    {
        [self.tableView reloadData];
    }
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

<<<<<<< HEAD


=======
>>>>>>> b9a646db5cf6356fe43c9d775f024548b048dd36
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
<<<<<<< HEAD
        
        [[TripsData sharedInstance] removeTripAtIndex:indexPath.row];
        [self.tableView reloadData];
        
=======
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [[TripsData sharedInstance] removeTripAtIndex:indexPath.row];
        [self.tableView reloadData];
>>>>>>> b9a646db5cf6356fe43c9d775f024548b048dd36
    }
}

#pragma mark - Navagation
-(IBAction)UnwindOnGenerateList:(UIStoryboardSegue *)segue {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showPackingList"])
    {
        PackingListViewController *plistVC = [segue destinationViewController];
        plistVC.trip = (self.tripToPass) ? self.tripToPass : trip;
        self.tripToPass = nil;
    }
}

@end
