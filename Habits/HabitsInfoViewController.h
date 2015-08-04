//
//  HabitsInfoViewController.h
//  Habit
//
//  Created by Carter Wooten on 6/23/14.
//  Copyright (c) 2014 Carter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HabitsInfoViewController : UIViewController

@property (strong) NSManagedObject *habit;
@property (strong, nonatomic) IBOutlet UINavigationItem *habitInfoNavBar;
@property (strong, nonatomic) IBOutlet UILabel *habitInfoCreationDate;
@property (strong, nonatomic) IBOutlet UILabel *habitStance;
@property (strong, nonatomic) IBOutlet UILabel *habitDays;
@property (strong, nonatomic) IBOutlet UILabel *achievedTime;
@property (strong, nonatomic) IBOutlet UILabel *achievedDistance;
@property (strong, nonatomic) IBOutlet UILabel *habitStartLocation;
@property (strong, nonatomic) IBOutlet UILabel *habitEndLocation;



@end
