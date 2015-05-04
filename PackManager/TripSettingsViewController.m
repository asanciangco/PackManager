//
//  TripSettingsViewController.m
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "TripSettingsViewController.h"
#import "UserPreferences.h"

@interface TripSettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *swimmingPreferenceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *FormalPreferenceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *accessToLaundrySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *willingToRewearJeansSwitch;

@end

@implementation TripSettingsViewController

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
    
    //trip preferences
    [self.swimmingPreferenceSwitch addTarget:self action:@selector(swimmingSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.swimmingPreferenceSwitch setOn:self.trip.swimmingPreference];
    
    [self.willingToRewearJeansSwitch addTarget:self action:@selector(rewearJeansSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.willingToRewearJeansSwitch setOn:self.trip.rewearJeansPreference];
    
    [self.FormalPreferenceSwitch addTarget:self action:@selector(formalSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.FormalPreferenceSwitch setOn:self.trip.formalPreference];
    
    [self.accessToLaundrySwitch addTarget:self action:@selector(accessToLaundrySwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.accessToLaundrySwitch setOn:self.trip.accessToLaundryPreference];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [super tableView:tableView numberOfRowsInSection:section];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - switch control
-(void) swimmingSwitchChanged:(id)sender{
    self.trip.swimmingPreference = self.swimmingPreferenceSwitch.on;
}

-(void) rewearJeansSwitchChanged:(id)sender{
    self.trip.rewearJeansPreference = self.willingToRewearJeansSwitch.on;
}

-(void) formalSwitchChanged:(id)sender{
    self.trip.formalPreference = self.FormalPreferenceSwitch.on;
}

-(void) accessToLaundrySwitchChanged:(id)sender{
    self.trip.accessToLaundryPreference = self.accessToLaundrySwitch.on;
}

@end
