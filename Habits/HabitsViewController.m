//
//  HabitsViewController.m
//  Habits
//
//  Created by Carter Wooten on 6/10/14.
//  Copyright (c) 2014 Carter. All rights reserved.
//

#import "HabitsViewController.h"
#import "HabitsTableViewController.h"

@interface HabitsViewController ()

@end

@implementation HabitsViewController
@synthesize textFieldName;
@synthesize textFieldLocationEnd;
@synthesize textFieldLocationStart;
@synthesize habit;
@synthesize geocoder;
@synthesize startLocationAttempt;
@synthesize endLocationAttempt;
@synthesize confirmImageView1;
@synthesize confirmImageView2;
@synthesize Segment;
@synthesize daySegment;
@synthesize habitStanceChoice;
@synthesize startLocationBool;
@synthesize endLocationBool;
@synthesize habitDistance;
@synthesize numOfHabitDays;
@synthesize locationManager;
@synthesize startLocationText;
@synthesize endLocationText;




// we need this to retreive managed object context and later save the device data.
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

//This makes sure that if the user changes the start location that it cannot be saved until they have confirmed it again.
- (IBAction)textFieldLocationStart:(id)sender {
    [textFieldLocationStart addTarget:self
                  action:@selector(changeTheStartLocationBool)
        forControlEvents:UIControlEventEditingChanged];
}
//This makes sure that if the user changes the end location that it cannot be saved until they have confirmed it again.
- (IBAction)textFieldLocationEnd:(id)sender {
    [textFieldLocationEnd addTarget:self
                               action:@selector(changeTheEndLocationBool)
                     forControlEvents:UIControlEventEditingChanged];
}

//method that resests achieved days when timer is called.
-(void) callAfterWeek: (NSTimer*) t
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"resetAchievedDays" object:[t userInfo]];
}

//Savepressed method
- (IBAction)savePressed:(id)sender {
    if (textFieldName.text && textFieldName.text.length > 0)
    {
        if (startLocationBool == TRUE && endLocationBool == TRUE) {
            if (habitDistance.text && habitDistance.text.length > 0) {
                //timer that will reset the total achievedDaysAWeek every week.
                NSTimer* weeklyReset = [NSTimer scheduledTimerWithTimeInterval: 604800.0 target: self
                                                                      selector: @selector(callAfterWeek:) userInfo:textFieldName.text repeats: YES];
                //Detects which segment was chosen in the habit stance options.
                if(Segment.selectedSegmentIndex == 0){
                    habitStanceChoice =@"good";
                }
                else if(Segment.selectedSegmentIndex == 1){
                    habitStanceChoice =@"neutral";
                }
                else if(Segment.selectedSegmentIndex == 2){
                    habitStanceChoice =@"bad";
                }
                //Detects which segment was chosen in the habit days options.
                if(daySegment.selectedSegmentIndex == 0){
                    numOfHabitDays = 1;
                }
                else if(daySegment.selectedSegmentIndex == 1){
                    numOfHabitDays = 2;
                }
                else if(daySegment.selectedSegmentIndex == 2){
                    numOfHabitDays = 3;
                }
                else if(daySegment.selectedSegmentIndex == 3){
                    numOfHabitDays = 4;
                }
                else if(daySegment.selectedSegmentIndex == 4){
                    numOfHabitDays = 5;
                }
                else if(daySegment.selectedSegmentIndex == 5){
                    numOfHabitDays = 6;
                }
                else if(daySegment.selectedSegmentIndex == 6){
                    numOfHabitDays = 7;
                }
                //get the current date and time to log for creationDate
                NSDate *currDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"dd.MM.YYYY HH:mm:ss"];
                NSString *dateString = [dateFormatter stringFromDate:currDate];
                //this will ensure that the geofences are capable to be created
                if(![CLLocationManager locationServicesEnabled])
                {
                    NSLog(@"You need to enable Location Services");
                }
                if(![CLLocationManager isMonitoringAvailableForClass:[CLRegion class]])
                {
                    NSLog(@"Region monitoring is not available for this Class");
                }
                if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
                   [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
                {
                    NSLog(@"You need to authorize Location Services for the APP");
                }
                //Probably the most important part of code in the program. initialize the startRegion and endRegion for your habit.
                CLCircularRegion *startRegion = [[CLCircularRegion alloc] initWithCenter:startLocationAttempt.location.coordinate
                                                                             radius:100
                                                                         identifier:[[NSUUID UUID] UUIDString]];
                CLCircularRegion *endRegion = [[CLCircularRegion alloc] initWithCenter:startLocationAttempt.location.coordinate
                                                                             radius:100
                                                                         identifier:[[NSUUID UUID] UUIDString]];
                [locationManager startMonitoringForRegion:startRegion];
                [locationManager startMonitoringForRegion:endRegion];
                NSManagedObjectContext *context = [self managedObjectContext];
                //create a placeholder
                //NSInteger placeholder = 0;
                // Create a Habit
                NSManagedObject *newHabit = [NSEntityDescription insertNewObjectForEntityForName:@"Habits" inManagedObjectContext:context];
                [newHabit setValue:startLocationText forKey:@"startLocationText"];
                [newHabit setValue:endLocationText forKey:@"endLocationText"];
                [newHabit setValue:textFieldName.text forKey:@"name"];
                [newHabit setValue:0 forKey:@"achievedDays"];
                [newHabit setValue:0 forKey:@"achievedTime"];
                [newHabit setValue:0 forKey:@"achievedDistance"];
                [newHabit setValue:[NSDecimalNumber decimalNumberWithString:habitDistance.text]forKey:@"distance"];
                [newHabit setValue:startRegion.identifier forKey:@"startLocation"];
                [newHabit setValue:endRegion.identifier forKey:@"endLocation"];
                [newHabit setValue:habitStanceChoice forKey:@"goodNeutralBad"];
                [newHabit setValue:[NSNumber numberWithInt: numOfHabitDays] forKey:@"daysAWeek"];
                [newHabit setValue:dateString forKey:@"creationDate"];
                NSError *error = nil;
                // Save the context
                if (![context save:&error]) {
                    NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            }
            else {
                // Create the pop-up to tell the user that they have not entered a name.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Please calculate your distance."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        else {
            // Create the pop-up to tell the user that they have not entered a name.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Make sure both your start and end locations are confirmed (checks in the circle next to the 'confirm' button."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        // Create the pop-up to tell the user that they have not entered a name.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You have not entered a name."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (IBAction)cancelPressed:(id)sender {
    
    // Create the confirmation button so ensure deletion of Habit creation.
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to cancel a new Habit creation?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
    actionSheet.tag = 0;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault; [actionSheet showInView:self.view];
    
}

- (IBAction)confirmEndLocation:(id)sender {
    //make sure the geocode is initialized
    if(geocoder == nil)
    {
        geocoder = [[CLGeocoder alloc] init];
    }
    
    NSString *address = textFieldLocationEnd.text;
    endLocationText = address;
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if(placemarks.count > 0)
        {
            endLocationAttempt = [placemarks objectAtIndex:0];
            [self performSegueWithIdentifier:@"findLocation" sender:sender];
        }
        else
        {
            // Create the pop-up to tell the user that they have entered an invalid start loacation.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"You have entered an invalid location."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }];
}

- (IBAction)confirmStartLocation:(id)sender {
    //make sure the geocode is initialized
    if(geocoder == nil)
                {
                    geocoder = [[CLGeocoder alloc] init];
                }
        
    NSString *address = textFieldLocationStart.text;
    startLocationText = address;
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if(placemarks.count > 0)
                {
                        startLocationAttempt = [placemarks objectAtIndex:0];
                        [self performSegueWithIdentifier:@"findLocation" sender:sender];
                }
        else
        {
            
            // Create the pop-up to tell the user that they have entered an invalid start loacation.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"You have entered an invalid location."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
  
        }
                }];
        
}

//simple method to ensure that the keybpard will minimize when the user touches a non editable area
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//calculates the ditance between start and end location using method below
- (IBAction)habitDistanceCalc:(id)sender {
    if (startLocationBool == TRUE && endLocationBool == TRUE) {
        float tempVar = [self kilometersfromPlace:(startLocationAttempt.location.coordinate) andToPlace:(endLocationAttempt.location.coordinate)];
        habitDistance.text = [NSString stringWithFormat:@"%.3f km", tempVar];
    }
    else {
        // Create the pop-up to tell the user that they haven't entered either a start or end location
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You need to make sure to enter a valid end/start location and to confirm them."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// method to handle action from cancel confiramtion 'pop-up'
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 0: {
            switch (buttonIndex) {
                case 0:
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
            }
            break;
        }
        default:
            break;
    }
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
    //allocate the locationManager
    // Initialize Location Manager
    //make sure that the locationManager is not already initialized
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
    }
    // Configure Location Manager
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //This adds a notification observer that waits for the confirmation press from the HabitsMapViewController to change the image to 'confirmed'
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTheStartImage) name:@"CHANGE_THE_IMAGE1" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTheEndImage) name:@"CHANGE_THE_IMAGE2" object:nil];
    //making the distance textfield non editable. calculation will be done in app.
    habitDistance.enabled=NO;
    //Setting the location booleans to false.
    startLocationBool = FALSE;
    endLocationBool = FALSE;
    // Do any additional setup after loading the view.
    if (habit) {
        [textFieldName setText:[habit valueForKey:@"name"]];
        [textFieldLocationStart setText:[habit valueForKey:@"startLocation"]];
        [textFieldLocationEnd setText:[habit valueForKey:@"endLocation"]];
    }
}

//calculates the distance from two points in kilometers. Not my code. credit goes to manujmv: http://stackoverflow.com/questions/20492618/trouble-with-finding-distance-between-2-points-with-cllocationcoordinate2d
-(float)kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to  {
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest]/1000;
    
    //NSLog(@"%f",dist);
    NSString *distance = [NSString stringWithFormat:@"%f",dist];
    
    return [distance floatValue];
    
}

// these methods handle the image of the start location confirmation and whether or not it is set. 
- (void)changeTheStartImage {
    //change the confrimation image of the location
    UIImage *image = [UIImage imageNamed: @"mapConfirm"];
    [confirmImageView1 setImage:image];
    startLocationBool = TRUE;
}
- (void)changeTheStartLocationBool {
    //change the confrirmation image of the location
    UIImage *image = [UIImage imageNamed: @"mapUnconfirm"];
    [confirmImageView1 setImage:image];
    habitDistance.text =nil;
    startLocationBool = FALSE;
}
// these methods handle the image of the end location confirmation and whether or not it is set.
- (void)changeTheEndImage {
    //change the confrimation image of the location
    UIImage *image = [UIImage imageNamed: @"mapConfirm"];
    [confirmImageView2 setImage:image];
    endLocationBool = TRUE;
}
- (void)changeTheEndLocationBool {
    //change the confrimation image of the location
    UIImage *image = [UIImage imageNamed: @"mapUnconfirm"];
    [confirmImageView2 setImage:image];
    habitDistance.text =nil;
    endLocationBool = FALSE;
}

//Prepares for the segue to the 'confirmation' map
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"findLocation"]) {
        HabitsMapViewController *destViewController = segue.destinationViewController;
        if ([sender tag] == 0) {
            destViewController.startOrEnd =@"start";
            destViewController.placeMark = startLocationAttempt;
        }
        else {
            destViewController.startOrEnd =@"end";
            destViewController.placeMark = endLocationAttempt;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
