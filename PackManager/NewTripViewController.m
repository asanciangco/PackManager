//
//  NewTripViewController.m
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "NewTripViewController.h"

@interface NewTripViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addStopButton;
@property (weak, nonatomic) IBOutlet UIButton *generateListButton;
@property (weak, nonatomic) IBOutlet UITextField *tripNameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *currLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *currDurationTextField;

- (IBAction)startDatePicked:(id)sender;
- (IBAction)addStopButtonPress:(id)sender;
- (IBAction)generateListButtonPress:(id)sender;
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
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:self.trip.startDate];
    }
    else if([indexPath isEqual:startDatePickerIndexPath])
    {
        cell.hidden = !startDatePickerShowing;
    }
    else if(indexPath.row > startDatePickerIndexPath.row && indexPath.row < currLocationIndexPath.row)
    {
        //TODO use [self.trip.duration count] to decide when to show
        cell.hidden = YES;
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
    
    if([indexPath isEqual:startDateIndexPath])
    {
        startDatePickerShowing = !startDatePickerShowing;
        [self.tableView reloadData];
    }
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

#pragma mark - date picked action

- (IBAction)startDatePicked:(id)sender {
    self.trip.startDate = self.startDatePicker.date;
    [self.tableView reloadData];
}

#pragma mark - button actions

- (IBAction)addStopButtonPress:(id)sender {
}

- (IBAction)generateListButtonPress:(id)sender {
}

@end
