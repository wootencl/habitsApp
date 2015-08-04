//
//  HabitsViewController.h
//  Habits
//
//  Created by Carter Wooten on 6/10/14.
//  Copyright (c) 2014 Carter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "HabitsMapViewController.h"

@interface HabitsViewController : UIViewController <CLLocationManagerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textFieldName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldLocationStart;
@property (strong, nonatomic) IBOutlet UITextField *textFieldLocationEnd;
@property (strong, nonatomic) IBOutlet UITextField *habitDistance;
@property (strong) NSManagedObject *habit;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (nonatomic,strong) CLPlacemark *startLocationAttempt;
@property (nonatomic,strong) CLPlacemark *endLocationAttempt;
@property (strong, nonatomic) IBOutlet UIImageView *confirmImageView1;
@property (strong, nonatomic) IBOutlet UIImageView *confirmImageView2;
@property (strong, nonatomic) IBOutlet UISegmentedControl *Segment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *daySegment;
@property (nonatomic) NSString *habitStanceChoice;
@property (nonatomic) NSString *startLocationText;
@property (nonatomic) NSString *endLocationText;
@property (nonatomic, assign) BOOL startLocationBool;
@property (nonatomic, assign) BOOL endLocationBool;
@property (nonatomic, assign) NSInteger numOfHabitDays;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
 