//
//  PackingListViewController.m
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "PackingListViewController.h"
#import "LayeredRightDetailCell.h"
#import "PackingListItemCell.h"
#import "WeatherReportViewController.h"
#import "NewTripViewController.h"

@interface PackingListViewController ()

@end

@implementation PackingListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.trip.name;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.trip.packingList getNumberOfUniqueItems];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //weather report row
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"weatherReportCell";
        LayeredRightDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
            cell = [[LayeredRightDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mainTextLabel.text = @"Weather Report";
        cell.upperDetailTextLabel.text = [NSString stringWithFormat:@"%li", (long)[self.trip.weatherReport getOverallHigh]];
        cell.lowerDetailTextLabel.text = [NSString stringWithFormat:@"%li", (long)[self.trip.weatherReport getOverallLow]];
        return cell;
    }
    //packing list item row
    else
    {
        static NSString *CellIdentifier = @"ListItemCell";
        PackingListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
            cell = [[PackingListItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        Packable *item = [self.trip.packingList getPackableForIndex:(indexPath.row-1)];
        
        if( item.quantity > 0)
        {
            cell.itemTextLabel.text = item.name;
            cell.quantityTextLabel.text = [NSString stringWithFormat:@"x%li", (long)item.quantity];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            cell.hidden = YES;
        }

        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"showWeatherReport" sender:self];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showWeatherReport"])
    {
        WeatherReportViewController *weatherReportVC = [segue destinationViewController];
        weatherReportVC.trip = self.trip;
    }
    else if([segue.identifier isEqualToString:@"editTrip"])
    {
        NewTripViewController *newTripVC = [segue destinationViewController];
        newTripVC.trip = self.trip;
    }
}


@end
