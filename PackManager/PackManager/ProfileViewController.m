//
//  ProfileViewController.m
//  PackManager
//
//  Created by Heather Blockhus on 4/15/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserPreferences.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tempUnitsSegControl;
@property (weak, nonatomic) IBOutlet UISlider *hotTempSlider;
@property (weak, nonatomic) IBOutlet UILabel *hotTempLabel;
@property (weak, nonatomic) IBOutlet UISlider *warmTempSlider;
@property (weak, nonatomic) IBOutlet UILabel *warmTempLabel;
@property (weak, nonatomic) IBOutlet UISlider *normalTempSlider;
@property (weak, nonatomic) IBOutlet UILabel *normalTempLabel;
@property (weak, nonatomic) IBOutlet UISlider *coolTempSlider;
@property (weak, nonatomic) IBOutlet UILabel *coolTempLabel;
@property (weak, nonatomic) IBOutlet UISlider *coldTempSlider;
@property (weak, nonatomic) IBOutlet UILabel *coldTempLabel;
@property (weak, nonatomic) IBOutlet UISwitch *swimmingPreferenceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rewearJeansPreferenceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *formalPreferenceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *accessToLaundryPreferenceSwitch;


@end

@implementation ProfileViewController

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
    
    //set user preferences from defaults:
    //segmented control
    [self.genderSegmentedControl addTarget:self action:@selector(genderChoiceChange:) forControlEvents:UIControlEventValueChanged];
    self.genderSegmentedControl.selectedSegmentIndex = ([[UserPreferences sharedInstance] getGender] == FEMALE ? 0 : 1);
    
    [self.tempUnitsSegControl addTarget:self action:@selector(tempUnitsChoiceChange:) forControlEvents:UIControlEventValueChanged];
    self.tempUnitsSegControl.selectedSegmentIndex = ([[UserPreferences sharedInstance] getTempFormat] == CELCIUS ? 0 : 1);
    
    //temp sliders and labels
    [self.hotTempSlider addTarget:self action:@selector(hotTempSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.warmTempSlider addTarget:self action:@selector(warmTempSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.normalTempSlider addTarget:self action:@selector(normalTempSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.coolTempSlider addTarget:self action:@selector(coolTempSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.coldTempSlider addTarget:self action:@selector(coldTempSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self refreshTemps];
    
    //trip preferences
    [self.swimmingPreferenceSwitch addTarget:self action:@selector(swimmingSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.swimmingPreferenceSwitch setOn:[[UserPreferences sharedInstance] getSwimmingPreference]];
    
    [self.rewearJeansPreferenceSwitch addTarget:self action:@selector(rewearJeansSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.rewearJeansPreferenceSwitch setOn:[[UserPreferences sharedInstance] getRewearJeansPreference]];
    
    [self.formalPreferenceSwitch addTarget:self action:@selector(formalSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.formalPreferenceSwitch setOn:[[UserPreferences sharedInstance] getFormalPreference]];
    
    [self.accessToLaundryPreferenceSwitch addTarget:self action:@selector(accessToLaundrySwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.accessToLaundryPreferenceSwitch setOn:[[UserPreferences sharedInstance] getAccessToLaundryPreference]];
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [super tableView:self.tableView numberOfRowsInSection:section];
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
#pragma mark - helper functions
-(void) refreshTemps
{
    self.hotTempSlider.value = [[UserPreferences sharedInstance] getHotTemp];
    self.hotTempLabel.text = [NSString stringWithFormat:@"%.0f", [[UserPreferences sharedInstance] getHotTemp]];
    self.warmTempSlider.value = [[UserPreferences sharedInstance] getWarmTemp];
    self.warmTempLabel.text = [NSString stringWithFormat:@"%.0f", [[UserPreferences sharedInstance] getWarmTemp]];
    self.normalTempSlider.value = [[UserPreferences sharedInstance] getNormalTemp];
    self.normalTempLabel.text = [NSString stringWithFormat:@"%.0f", [[UserPreferences sharedInstance] getNormalTemp]];
    self.coolTempSlider.value = [[UserPreferences sharedInstance] getCoolTemp];
    self.coolTempLabel.text = [NSString stringWithFormat:@"%.0f", [[UserPreferences sharedInstance] getCoolTemp]];
    self.coldTempSlider.value = [[UserPreferences sharedInstance] getColdTemp];
    self.coldTempLabel.text = [NSString stringWithFormat:@"%.0f", [[UserPreferences sharedInstance] getColdTemp]];
}


#pragma mark - Segmented Control
-(void) genderChoiceChange:(id)sender{
    Gender gender = self.genderSegmentedControl.selectedSegmentIndex ? FEMALE : MALE;
    [[UserPreferences sharedInstance] setGender:gender];
}

-(void) tempUnitsChoiceChange:(id)sender{
    TempFormat tempUnits = self.tempUnitsSegControl.selectedSegmentIndex ? CELCIUS : FARENHEIGHT;
    [[UserPreferences sharedInstance] setTempFormat:tempUnits];
    [self refreshTemps];
}

#pragma mark - Slider Control
- (void)hotTempSliderChanged:(UISlider *)slider {
    if([[UserPreferences sharedInstance] setHotTemp:slider.value])
        self.hotTempLabel.text = [NSString stringWithFormat:@"%.0f", slider.value];
    else
        self.hotTempSlider.value = [[UserPreferences sharedInstance] getHotTemp];
}

- (void)warmTempSliderChanged:(UISlider *)slider {
    if([[UserPreferences sharedInstance] setWarmTemp:slider.value])
        self.warmTempLabel.text = [NSString stringWithFormat:@"%.0f", slider.value];
    else
        self.warmTempSlider.value = [[UserPreferences sharedInstance] getWarmTemp];
}

- (void)normalTempSliderChanged:(UISlider *)slider {
    if([[UserPreferences sharedInstance] setNormalTemp:slider.value])
        self.normalTempLabel.text = [NSString stringWithFormat:@"%.0f", slider.value];
    else
        self.normalTempSlider.value = [[UserPreferences sharedInstance] getNormalTemp];
}

- (void)coolTempSliderChanged:(UISlider *)slider {
    if([[UserPreferences sharedInstance] setCoolTemp:slider.value])
        self.coolTempLabel.text = [NSString stringWithFormat:@"%.0f", slider.value];
    else
        self.coolTempSlider.value = [[UserPreferences sharedInstance] getCoolTemp];
}

- (void)coldTempSliderChanged:(UISlider *)slider {
    if([[UserPreferences sharedInstance] setColdTemp:slider.value])
        self.coldTempLabel.text = [NSString stringWithFormat:@"%.0f", slider.value];
    else
        self.coldTempSlider.value = [[UserPreferences sharedInstance] getColdTemp];
}

#pragma mark - switch control
-(void) swimmingSwitchChanged:(id)sender{
    [[UserPreferences sharedInstance] setSwimmingPreference:self.swimmingPreferenceSwitch.on];
}

-(void) rewearJeansSwitchChanged:(id)sender{
    [[UserPreferences sharedInstance] setRewearJeansPreference:self.rewearJeansPreferenceSwitch.on];
}

-(void) formalSwitchChanged:(id)sender{
    [[UserPreferences sharedInstance] setFormalPreference:self.formalPreferenceSwitch.on];
}

-(void) accessToLaundrySwitchChanged:(id)sender{
    [[UserPreferences sharedInstance] setAccessToLaundryPreference:self.accessToLaundryPreferenceSwitch.on];
}

@end
