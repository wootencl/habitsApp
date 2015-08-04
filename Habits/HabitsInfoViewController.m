//
//  HabitsInfoViewController.m
//  Habit
//
//  Created by Carter Wooten on 6/23/14.
//  Copyright (c) 2014 Carter. All rights reserved.
//

#import "HabitsInfoViewController.h"

@interface HabitsInfoViewController ()

@end

@implementation HabitsInfoViewController
@synthesize habit;
@synthesize habitInfoNavBar;
@synthesize habitInfoCreationDate;
@synthesize habitStance;
@synthesize habitDays;
@synthesize habitEndLocation;
@synthesize habitStartLocation;
@synthesize achievedDistance;
@synthesize achievedTime;

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


- (IBAction)back:(id)sender {
    //code to send back to table view controller
    [self.navigationController popViewControllerAnimated:YES];
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
    // Do any additional setup after loading the view.
    habitInfoNavBar.title = [habit valueForKey:@"name"];
    habitStance.text = [habit valueForKey:@"goodNeutralBad"];
    habitStartLocation.text = [habit valueForKey:@"startLocationText"];
    habitEndLocation.text = [habit valueForKey:@"endLocationText"];
    NSNumber* tempVar1 = [habit valueForKey:@"achievedDays"];
    NSInteger achievedDays = [tempVar1 intValue];
    NSNumber* tempVar2 = [habit valueForKey:@"daysAWeek"];
    NSInteger daysAWeek = [tempVar2 intValue];
    habitDays.text = [NSString stringWithFormat:@"%d / %d",achievedDays, daysAWeek];
    NSNumber* tempVar3 = [habit valueForKey:@"achievedDistance"];
    NSInteger achievedDistanceTemp = [tempVar3 intValue];
    achievedDistance.text = [NSString stringWithFormat:@"%d", achievedDistanceTemp];
    NSNumber* tempVar4 = [habit valueForKey:@"achievedTime"];
    NSInteger achievedTimeTemp = [tempVar4 intValue];
    achievedTime.text = [NSString stringWithFormat:@"%d", achievedTimeTemp];
    habitInfoCreationDate.text = [habit valueForKey:@"creationDate"];
    
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
