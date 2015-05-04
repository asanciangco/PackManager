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

- (IBAction)addStopButtonPress:(id)sender;
- (IBAction)generateListButtonPress:(id)sender;
@end

@implementation NewTripViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3 + (self.trip.numStops * 2);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    //TODO: configure cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//TODO
#pragma mark - button actions

- (IBAction)addStopButtonPress:(id)sender {
}

- (IBAction)generateListButtonPress:(id)sender {
}
@end
