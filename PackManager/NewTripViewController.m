//
//  NewTripViewController.m
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "NewTripViewController.h"
#import "PackingListViewController.h"
#import "Destination.h"
#import "TripsData.h"
#import "TripsViewController.h"
#import "TripSettingsViewController.h"

@interface NewTripViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addStopButton;
@property (weak, nonatomic) IBOutlet UIButton *generateListButton;
@property (weak, nonatomic) IBOutlet UITextField *tripNameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *currLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *currDurationTextField;

- (IBAction)startDatePicked:(id)sender;
- (IBAction)addStopButtonPress:(id)sender;

@end

@implementation NewTripViewController{
    NSIndexPath *tripNameIndexPath;
    NSIndexPath *startDateIndexPath;
    NSIndexPath *startDatePickerIndexPath;
    NSIndexPath *currLocationIndexPath;
    NSIndexPath *currDurationIndexPath;
    NSInteger numStopsPossible;
    BOOL startDatePickerShowing;
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
    
    if(self.trip)
    {
        self.tripNameTextField.text = self.trip.name;
    }
    else
        self.trip = [[Trip alloc] initNewTrip];
    
    tripNameIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    startDateIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    startDatePickerIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    numStopsPossible = 5;
    currLocationIndexPath = [NSIndexPath indexPathForRow:2+numStopsPossible*2 inSection:0];
    currDurationIndexPath = [NSIndexPath indexPathForRow:3+numStopsPossible*2 inSection:0];
    
    startDatePickerShowing = NO;
    
    //both buttons start off non-operational
    self.addStopButton.enabled = NO;
    self.generateListButton.enabled = NO;

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
    return [super tableView:tableView numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if([indexPath isEqual:startDateIndexPath])
    {
        //get date string for date cell
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:self.trip.startDate];
    }
    else if([indexPath isEqual:startDatePickerIndexPath])
    {
        cell.hidden = !startDatePickerShowing;
    }
    else if(indexPath.row > startDatePickerIndexPath.row && indexPath.row < currLocationIndexPath.row)
    {
        if ((indexPath.row - startDateIndexPath.row) < ([self.trip.destinations count] + 1) * 2)
        {
            cell.hidden = NO;
            
            // Index relative to date picker, so relativeIndex=0 is the first cell below datePicker
            NSInteger relativeIndex = indexPath.row - startDatePickerIndexPath.row - 1;
            // The index for the destination related to any cell
            NSInteger destinationIndex = (relativeIndex) / 2;
            
            // If a destination exists for the given cell...
            if (destinationIndex < [self.trip.destinations count] && destinationIndex >=0)
            {
                Destination *dest = [self.trip.destinations objectAtIndex:destinationIndex];
                
                if (relativeIndex % 2 == 0)
                    cell.detailTextLabel.text = dest.name;
                else
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%li", (long)dest.duration];
            }
        }
        else
        {
            cell.hidden = YES;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if([indexPath isEqual:startDatePickerIndexPath])
    {
        height = startDatePickerShowing ? 162.0f : 0.0f;
    }
    else if(indexPath.row > startDatePickerIndexPath.row && indexPath.row < currLocationIndexPath.row)
    {
        //TODO use [self.trip.duration count] to decide when to show
        if ((indexPath.row - startDateIndexPath.row) < ([self.trip.destinations count] + 1) * 2)
            height = 44.0f;
        else
            height = 0.0f;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![indexPath isEqual:startDatePickerIndexPath] && ![indexPath isEqual:startDateIndexPath])
    {
        startDatePickerShowing = NO;
        [self.tableView reloadData];
    }
    else if([indexPath isEqual:startDateIndexPath])
    {
        startDatePickerShowing = !startDatePickerShowing;
        [self.tableView reloadData];
    }
    else if([indexPath isEqual:tripNameIndexPath])
    {
        [self textFieldShouldBeginEditing:self.currDurationTextField];
    }
    else if([indexPath isEqual:currLocationIndexPath])
    {
        [self textFieldShouldBeginEditing:self.currDurationTextField];
    }
    else if([indexPath isEqual:currDurationIndexPath])
    {
        [self textFieldShouldBeginEditing:self.currDurationTextField];
    }
    
    [self enableButtons];
}

#pragma mark - textfield methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(startDatePickerShowing)
    {
        startDatePickerShowing = NO;
        [self.tableView reloadData];
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self enableButtons];
    
    return YES;
}

#pragma mark - date picked action

- (IBAction)startDatePicked:(id)sender {
    self.trip.startDate = self.startDatePicker.date;
    [self enableButtons];
    [self.tableView reloadData];
}

#pragma mark - button actions

- (IBAction)addStopButtonPress:(id)sender {
    Destination *dest = [[Destination alloc] init];
    dest.name = self.currLocationTextField.text;
    dest.duration = [self.currDurationTextField.text integerValue];
    [self.trip.destinations addObject:dest];
    self.currLocationTextField.text = @"";
    self.currDurationTextField.text = @"";
    [self.tableView reloadData];
}

#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"unwindSegue"])
    {
        self.trip.name = self.tripNameTextField.text;
        if(![self.currLocationTextField.text isEqual:@""] && ![self.currDurationTextField.text isEqual:@""])
        {
            Destination *dest = [[Destination alloc] init];
            dest.name = self.currLocationTextField.text;
            dest.duration = [self.currDurationTextField.text integerValue];
            [self.trip.destinations addObject:dest];
        }
        
        //TODO: change after demo
        //[self.trip generatePackingList];
        [self.trip generatePackingListExample];
        
        TripsViewController *tripsVC = [segue destinationViewController];
        tripsVC.tripToPass = self.trip;
        [[TripsData sharedInstance] addTrip:self.trip];
    }
    else if([segue.identifier isEqualToString:@"viewTripSettings"])
    {
        TripSettingsViewController *TripSettingsVC = [segue destinationViewController];
        TripSettingsVC.trip = self.trip;
    }
}

-(void) enableButtons
{
    if(![self.tripNameTextField.text isEqual:@""] && ![self.currLocationTextField.text isEqual:@""] && ![self.currDurationTextField.text isEqual:@""] && self.trip.startDate)
    {
        self.addStopButton.enabled = YES;
        self.generateListButton.enabled = YES;
    }
}

@end
