//
//  HabitsMapViewController.h
//  Habits
//
//  Created by Carter Wooten on 6/16/14.
//  Copyright (c) 2014 Carter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface HabitsMapViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic,strong) CLPlacemark *placeMark;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) NSString *startOrEnd;
@property (strong, nonatomic) IBOutlet UINavigationItem *mapNavigationBar;


@end
