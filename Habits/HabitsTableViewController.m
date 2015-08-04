//
//  HabitsTableViewController.m
//  Habits
//
//  Created by Carter Wooten on 6/10/14.
//  Copyright (c) 2014 Carter. All rights reserved.
//

#import "HabitsTableViewController.h"
#import "HabitsInfoViewController.h"
#import "HabitsViewController.h"

@interface HabitsTableViewController ()

@end

@implementation HabitsTableViewController
@synthesize habits;
@synthesize habitStanceCountGood;
@synthesize habitStanceCountNeutral;
@synthesize habitStanceCountBad;
@synthesize tableHiearchy;
@synthesize goodCount;
@synthesize neutralCount;
@synthesize badCount;
@synthesize startTime;
@synthesize habitStartComparisonVar;
@synthesize habitStartComparisonIndex;
@synthesize habitEndComparisonVar;
@synthesize habitEndComparisonIndex;


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
    //Notification sent every week to reset Achieved days.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(triggerAction:) name:@"resetAchievedDays" object:nil];
}

//reset achievedDays
-(void) triggerAction:(NSNotification *) notification
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSString *tempString = [notification object];
    for (NSInteger a=0;a<habits.count;a++)
    {
        NSManagedObject *habit = [habits objectAtIndex:a];
        if ([[habit valueForKey:@"name"] isEqualToString:tempString]){
            [habit setValue:0 forKey:@"achievedDays"];
            NSError *error = nil;
            // Save the context
            if (![context save:&error]) {
                NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
            }
        }
    }
}

//the following methods are thrown when the locationManager detects the entering or exiting of a monitored zone.
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    habitStartComparisonVar =@"";
    NSString *compID = region.identifier;
    for (NSInteger a=0;a<habits.count;a++)
    {
        NSManagedObject *habit = [habits objectAtIndex:a];
        if ([[habit valueForKey:@"startLocation"] isEqualToString:compID]){
            habitStartComparisonIndex = a;
            break;
        }
    }
    NSManagedObject *habit = [habits objectAtIndex:habitStartComparisonIndex];
    habitStartComparisonVar = [habit valueForKey:@"name"];
    NSManagedObjectContext *context = [self managedObjectContext];
    if (habitEndComparisonVar == habitStartComparisonVar) {
        CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
        [habit setValue:[NSNumber numberWithInt:elapsedTime] forKey:@"achievedTime"];
        NSError *error = nil;
        // Save the context
        if (![context save:&error]) {
            NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
        }
        
        
    }

}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    habitEndComparisonVar =@"";
    NSString *compID = region.identifier;
    for (NSInteger a=0;a<habits.count;a++)
    {
        NSManagedObject *habit = [habits objectAtIndex:a];
        if ([[habit valueForKey:@"startLocation"] isEqualToString:compID]){
            habitEndComparisonIndex = a;
            break;
        }
    }
    NSManagedObject *habit = [habits objectAtIndex:habitEndComparisonIndex];
    NSManagedObjectContext *context = [self managedObjectContext];
    habitEndComparisonVar = [habit valueForKey:@"name"];
    if (habitStartComparisonVar == habitEndComparisonVar) {
        startTime = CACurrentMediaTime();
        NSDecimalNumber* tempVar1 = [habit valueForKey:@"distance"];
        NSDecimal tempVar2 = [tempVar1 decimalValue];
        NSDecimal tempDist;
        NSDecimalAdd(&tempDist, &tempVar2, &tempVar2, NSRoundBankers);
        [habit setValue:[NSDecimalNumber decimalNumberWithDecimal:tempDist] forKey:@"achievedDistance"];
        NSError *error = nil;
        // Save the context
        if (![context save:&error]) {
            NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
        }

        
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // here we get the habits from the persistent data store (or the database)
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Habits"];
    habits = [[moc  executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableHiearchy == nil)
    {
        tableHiearchy = [[NSMutableArray alloc] init];
    }
    [tableHiearchy removeAllObjects];
    goodCount = 0;
    neutralCount = 0;
    badCount = 0;
    habitStanceCountGood = 0;
    habitStanceCountNeutral = 0;
    habitStanceCountBad = 0;
    for (NSInteger a=0;a<habits.count;a++)
    {
        NSManagedObject *habit = [habits objectAtIndex:a];
        if ([[habit valueForKey:@"goodNeutralBad"] isEqualToString:@"good"]){
            goodCount++;
        }
        else if ([[habit valueForKey:@"goodNeutralBad"] isEqualToString:@"neutral"]){
            neutralCount++;
        }
        else {
            badCount++;
        }
            
    }
    if (section==0)
    {
        return goodCount;
    }
    else if(section==1)
    {
        return neutralCount;
    }
    else {
        return badCount;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
    {
        return @"Good";
    }
    else if(section == 1)
    {
        return @"Neutral";
    }
    else {
        return @"Bad";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cells...
    if (indexPath.section==0) {
        while (habitStanceCountGood<habits.count)
        {
            NSManagedObject *habit = [habits objectAtIndex:habitStanceCountGood];
            if ([[habit valueForKey:@"goodNeutralBad"] isEqualToString:@"good"]){
                [cell.textLabel setText:[NSString stringWithFormat:@"%@", [habit valueForKey:@"name"]]];
                [cell.detailTextLabel setText:nil];
                NSNumber* intWrapped = [NSNumber numberWithInt:habitStanceCountGood];
                [tableHiearchy addObject:intWrapped];
                habitStanceCountGood++;
                break;
            }
            habitStanceCountGood++;
        }
    }
    else if(indexPath.section==1) {
        while (habitStanceCountNeutral<habits.count)
        {
            NSManagedObject *habit = [habits objectAtIndex:habitStanceCountNeutral];
            if ([[habit valueForKey:@"goodNeutralBad"] isEqualToString:@"neutral"]){
                [cell.textLabel setText:[NSString stringWithFormat:@"%@", [habit valueForKey:@"name"]]];
                [cell.detailTextLabel setText:nil];
                NSNumber* intWrapped = [NSNumber numberWithInt:habitStanceCountNeutral];
                [tableHiearchy addObject:intWrapped];
                habitStanceCountNeutral++;
                break;
            }
            habitStanceCountNeutral++;
        }
    }
    else{
        while (habitStanceCountBad<habits.count)
        {
            NSManagedObject *habit = [habits objectAtIndex:habitStanceCountBad];
            if ([[habit valueForKey:@"goodNeutralBad"] isEqualToString:@"bad"]){
                [cell.textLabel setText:[NSString stringWithFormat:@"%@", [habit valueForKey:@"name"]]];
                [cell.detailTextLabel setText:nil];
                NSNumber* intWrapped = [NSNumber numberWithInt:habitStanceCountBad];
                [tableHiearchy addObject:intWrapped];
                habitStanceCountBad++;
                break;
            }
            habitStanceCountBad++;
        }
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //I know there has to be a better way to do this, but being new to xCode and objective-C this was the only way i could think of as of the moment. Essentially there is a 'master' hiearchy array that keeps track of how the rows are oriented to the data-store(database) and uses that to delete them. Don't hesitate to ask further how it works.
        NSInteger section = [indexPath section];
        NSInteger hiearchy = 0;
        if (section == 0) {
            hiearchy = [[tableHiearchy objectAtIndex:indexPath.row] intValue];
            [tableHiearchy removeObjectAtIndex:indexPath.row];
            // Delete the row from the data source
            [context deleteObject:[habits objectAtIndex:hiearchy]];
            // invode the save method to commit the change
            NSError *error = nil;
            // Save the context
            if (![context save:&error]) {
                NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
            }
            // Remove habit from table view
            [habits removeObjectAtIndex:hiearchy];
            //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (section == 1) {
            hiearchy = [[tableHiearchy objectAtIndex:(indexPath.row+goodCount)] intValue];
            [tableHiearchy removeObjectAtIndex:indexPath.row];
            // Delete the row from the data source
            [context deleteObject:[habits objectAtIndex:hiearchy]];
            // invode the save method to commit the change
            NSError *error = nil;
            // Save the context
            if (![context save:&error]) {
                NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
            }
            // Remove habit from table view
            [habits removeObjectAtIndex:hiearchy];
            //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        }
        else {
            hiearchy = [[tableHiearchy objectAtIndex:(indexPath.row+goodCount+neutralCount)] intValue];
            [tableHiearchy removeObjectAtIndex:indexPath.row];
            // Delete the row from the data source
            [context deleteObject:[habits objectAtIndex:hiearchy]];
            // invode the save method to commit the change
            NSError *error = nil;
            // Save the context
            if (![context save:&error]) {
                NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
            }
            // Remove habit from table view
            [habits removeObjectAtIndex:hiearchy];
            //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.tableView reloadData];
    }
}

//Prepares for the segue to the 'confirmation' map
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"habitInfo"]) {
        //this uses the same 'master' hiearchy that the delete uses. overly complex: yes. does it work: also yes. so i can't complain 
        NSInteger section = [[self.tableView indexPathForSelectedRow] section];
        NSInteger hiearchy = 0;
        if (section == 0) {
            hiearchy = [[tableHiearchy objectAtIndex:([self.tableView indexPathForSelectedRow].row)] intValue];
            NSManagedObject *selectedHabit = [habits objectAtIndex:hiearchy];
            HabitsInfoViewController *destViewController = segue.destinationViewController;
            destViewController.habit = selectedHabit;
        }
        else if (section == 1) {
            hiearchy = [[tableHiearchy objectAtIndex:([self.tableView indexPathForSelectedRow].row)+goodCount] intValue];
            NSManagedObject *selectedHabit = [habits objectAtIndex:hiearchy];
            HabitsInfoViewController *destViewController = segue.destinationViewController;
            destViewController.habit = selectedHabit;
        }
        else {
            hiearchy = [[tableHiearchy objectAtIndex:([self.tableView indexPathForSelectedRow].row)+goodCount+neutralCount] intValue];
            NSManagedObject *selectedHabit = [habits objectAtIndex:hiearchy];
            HabitsInfoViewController *destViewController = segue.destinationViewController;
            destViewController.habit = selectedHabit;
        }
    }
}

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

@end
