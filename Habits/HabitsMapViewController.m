//
//  HabitsMapViewController.m
//  Habits
//
//  Created by Carter Wooten on 6/16/14.
//  Copyright (c) 2014 Carter. All rights reserved.
//

#import "HabitsMapViewController.h"


@interface HabitsMapViewController ()

@end

@implementation HabitsMapViewController
@synthesize placeMark;
@synthesize mapView;
@synthesize startOrEnd;
@synthesize mapNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (IBAction)confirmMap:(id)sender {
    if ([startOrEnd isEqualToString:@"start"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE_THE_IMAGE1" object:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE_THE_IMAGE2" object:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)cancelMap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    if ([startOrEnd isEqualToString:@"start"]) {
        mapNavigationBar.title =@"Start Location";
    }
    else {
        mapNavigationBar.title =@"End Location";
    }
    MKCoordinateRegion region;
    region=MKCoordinateRegionMakeWithDistance(placeMark.location.coordinate, 200, 200);
    [self.mapView setRegion:region animated:YES];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = placeMark.location.coordinate;
    point.title = @"Is this the correct location?";
    [self.mapView addAnnotation:point];
    [mapView selectAnnotation:point animated:NO];
    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
//                                          initWithTarget:self action:@selector(handleLongPress:)];
//    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
//    [self.mapView addGestureRecognizer:lpgr];
    
}

//- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
//        return;
//    
//    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
//    CLLocationCoordinate2D touchMapCoordinate =
//    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
//    
//    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
//    annot.coordinate = touchMapCoordinate;
//    [self.mapView addAnnotation:annot];
//}

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
