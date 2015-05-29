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
#import "GooglePlacesAPI.h"

#import "WeatherAPI.h"

@interface NewTripViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addStopButton;
@property (weak, nonatomic) IBOutlet UIButton *generateListButton;
@property (weak, nonatomic) IBOutlet UITextField *tripNameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *currLocationTextField;
@property (weak, nonatomic) IBOutlet UITableView *locationSuggestionsTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *currDurationTextField;

- (IBAction)startDatePicked:(id)sender;
- (IBAction)addStopButtonPress:(id)sender;

@end

@implementation NewTripViewController{
    NSIndexPath *tripNameIndexPath;
    NSIndexPath *startDateIndexPath;
    NSIndexPath *startDatePickerIndexPath;
    NSIndexPath *currLocationIndexPath;
    NSIndexPath *locationSuggestionsIndexPath;
    NSIndexPath *mapIndexPath;
    NSIndexPath *currDurationIndexPath;
    NSInteger numStopsPossible;
    NSArray *searchResults;
    NSString *currSearch;
    CGFloat lat;
    CGFloat lng;
    BOOL startDatePickerShowing;
    BOOL locationSuggestionsShowing;
    BOOL mapShowing;
    
    BOOL unwindSegue;
}

#pragma mark - Initializer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view load / disappear
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.trip)
    {
        self.tripNameTextField.text = self.trip.name;
        if ([self.trip.destinations count] > 0)
        {
            Destination *dest = [self.trip.destinations objectAtIndex:[self.trip.destinations count] -1];
            self.currLocationTextField.text = dest.name;
            self.currDurationTextField.text = [NSString stringWithFormat:@"%li", (long)dest.duration];
            lat = dest.lat;
            lng = dest.lon;
            [self.trip.destinations removeLastObject];
        }
    }
    else
    {
        lat = NSIntegerMin;
        lng = NSIntegerMin;
        self.trip = [[Trip alloc] initNewTrip];
    }
    
    unwindSegue = NO;
    
    tripNameIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    startDateIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    startDatePickerIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    numStopsPossible = 5;
    currLocationIndexPath = [NSIndexPath indexPathForRow:2+numStopsPossible*2 inSection:0];
    locationSuggestionsIndexPath = [NSIndexPath indexPathForRow:3+numStopsPossible*2 inSection:0];
    mapIndexPath = [NSIndexPath indexPathForRow:4+numStopsPossible*2 inSection:0];
    currDurationIndexPath = [NSIndexPath indexPathForRow:5+numStopsPossible*2 inSection:0];
    
    startDatePickerShowing = NO;
    locationSuggestionsShowing = NO;
    mapShowing = NO;
    
    //both buttons start off non-operational
    self.addStopButton.enabled = NO;
    self.generateListButton.enabled = NO;

    // Do any additional setup after loading the view.
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (![self.currLocationTextField.text isEqualToString:@""] && ![self.currDurationTextField.text isEqualToString:@""] && !unwindSegue)
    {
        Destination *dest = [[Destination alloc] init];
        dest.name = self.currLocationTextField.text;
        dest.duration = self.currDurationTextField.text.integerValue;
        dest.lat = lat;
        dest.lon = lng;
        [self.trip.destinations addObject:dest];
        
        lat = NSIntegerMin;
        lng = NSIntegerMin;
        
        unwindSegue = NO;
    }
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
    if(tableView == self.locationSuggestionsTableView)
        return [searchResults count];
    else
        return [super tableView:tableView numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.locationSuggestionsTableView)
    {
        UITableViewCell *cell = [self.locationSuggestionsTableView dequeueReusableCellWithIdentifier:@"SugesstionCell"];
        cell.textLabel.text = searchResults[indexPath.row][@"name"];
        return cell;
    }
    else
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
        else if([indexPath isEqual:locationSuggestionsIndexPath])
        {
            cell.hidden = !locationSuggestionsShowing;
        }
        else if([indexPath isEqual:mapIndexPath])
        {
            //trying to remove cell separator for map (only does below
            //cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
            cell.hidden = !mapShowing;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.locationSuggestionsTableView)
    {
        return 44.0f;
    }
    else
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
        else if([indexPath isEqual:locationSuggestionsIndexPath])
        {
            height = locationSuggestionsShowing ? 200.0f : 0.0f;
        }
        else if([indexPath isEqual:mapIndexPath])
        {
            height = mapShowing ? 100.0f : 0.0f;
        }
        return height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.locationSuggestionsTableView)
    {
        //TODO: show map, stop showing results
        if(searchResults[indexPath.row][@"lat"] && searchResults[indexPath.row][@"lng"])
        {
            lat = [searchResults[indexPath.row][@"lat"] floatValue];
            lng = [searchResults[indexPath.row][@"lng"] floatValue];
        }
        mapShowing = (lat != 200 && lng != 200);
        locationSuggestionsShowing = NO;
        self.currLocationTextField.text = searchResults[indexPath.row][@"name"];
        [self.tableView reloadData];
        [self updateMapViewToLat:lat Long:lng];
    }
    else
    {
        BOOL needToReload = NO;
        if(![indexPath isEqual:startDatePickerIndexPath] && ![indexPath isEqual:startDateIndexPath])
        {
            startDatePickerShowing = NO;
            needToReload = YES;
        }
        if(![indexPath isEqual:currLocationIndexPath] && locationSuggestionsShowing)
        {
            locationSuggestionsShowing = NO;
            needToReload = YES;
        }
        if(needToReload)
            [self.tableView reloadData];
        
        if([indexPath isEqual:startDateIndexPath])
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
}

#pragma mark - textfield methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL needToReload = NO;
    if(startDatePickerShowing)
    {
        startDatePickerShowing = NO;
        needToReload = YES;
    }
    if(locationSuggestionsShowing && textField != self.currLocationTextField)
    {
        locationSuggestionsShowing = NO;
        needToReload = YES;
    }
    if(needToReload)
        [self.tableView reloadData];
    
    return YES;
}

-(void) hideSearch
{
    locationSuggestionsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[locationSuggestionsIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

-(void) showSearch
{
    locationSuggestionsShowing = YES;
    [self.tableView reloadData];
    self.currLocationTextField.text = currSearch;
    [self.currLocationTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    [self.locationSuggestionsTableView reloadData];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.currLocationTextField)
    {
        NSString *searchString = [NSString stringWithString:textField.text];
        searchString = [searchString stringByReplacingCharactersInRange:range withString:string];
        searchString = [searchString stringByReplacingOccurrencesOfString:@"\u00a0" withString:@" "];
        currSearch = searchString;
        searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];

        //when to show results
        if(searchString.length > 0)
        {
            [self.tableView scrollToRowAtIndexPath:currLocationIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            searchResults = [[GooglePlacesAPI sharedInstance] getLocationSuggestions:searchString];
            if(!locationSuggestionsShowing && [searchResults count])
                [self showSearch];
            else if([searchResults count])
                [self.locationSuggestionsTableView reloadData];
                
        }
        else if(locationSuggestionsShowing)
        {
            [self hideSearch];
            [self.currLocationTextField becomeFirstResponder];
        }
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
    dest.lat = lat;
    dest.lon = lng;
    [self.trip.destinations addObject:dest];
    
    self.currLocationTextField.text = @"";
    self.currDurationTextField.text = @"";
    lat = NSIntegerMin;
    lng = NSIntegerMin;
    
    [self.tableView reloadData];
}

- (void)updateMapViewToLat:(CLLocationDegrees)latitude Long:(CLLocationDegrees)longetide{
    
    // create a region and pass it to the Map View
    mapShowing = YES;
    MKCoordinateRegion region;
    region.center.latitude = latitude;
    region.center.longitude = longetide;
    region.span.latitudeDelta = 0.00005;
    region.span.longitudeDelta = 0.00005;
    
    [self.mapView setRegion:region animated:NO];
}

#pragma mark - Navigation

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"unwindSegue"])
    {
        unwindSegue = YES;
        
        self.trip.name = self.tripNameTextField.text;
        if(![self.currLocationTextField.text isEqual:@""] && ![self.currDurationTextField.text isEqual:@""])
        {
            Destination *dest = [[Destination alloc] init];
            dest.name = self.currLocationTextField.text;
            dest.duration = [self.currDurationTextField.text integerValue];
            dest.lat = lat;
            dest.lon = lng;
            [self.trip.destinations addObject:dest];
        }
        
        //Generate packing list
        
        @try
        {
            [self generateWeatherReport];
        }
        @catch (NSException *exception) {
            NSString *name = @"";
            NSString *reason = @"";
            
            if ([exception.name containsString:@"NSInvalid"])
            {
                name = @"Oops!";
                reason = @"Something went wrong when trying to contact the interwebz. Please check your internet connect and trip parameters and try again";
            }
            else
            {
                name = exception.name;
                reason = exception.reason;
            }
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:name message:reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        @finally {}
        
        [self.trip generatePackingList];
    }
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // this one unwinds then goes to the packing list
    if([segue.identifier isEqualToString:@"unwindSegue"])
    {
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

- (void) generateWeatherReport
{
    WeatherReport *report;
    NSInteger dayOffset = 0;
    
    for (Destination* dest in self.trip.destinations)
    {
        NSDate *startDate = ([self.trip.startDate dateByAddingTimeInterval:60*60*24*dayOffset]);
        NSDate *endDate = [startDate dateByAddingTimeInterval:60*60*24*(dest.duration - 1)];
        
        WeatherReport *tempReport = [[WeatherAPI sharedInstance] getWeatherReport:dest.name
                                                                            start:startDate
                                                                              end:endDate
                                                                              lat:dest.lat
                                                                              lon:dest.lon];
        if (!report)
            report = tempReport;
        else
            [report mergeWeatherReport:tempReport];
        
        dayOffset += dest.duration;
    }
    self.trip.weatherReport = report;
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
