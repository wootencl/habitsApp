//
//  HabitsTableViewController.h
//  Habits
//
//  Created by Carter Wooten on 6/10/14.
//  Copyright (c) 2014 Carter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HabitsTableViewController : UITableViewController
@property (strong) NSMutableArray *habits;
@property (nonatomic, assign) NSInteger habitStanceCountGood;
@property (nonatomic, assign) NSInteger habitStanceCountNeutral;
@property (nonatomic, assign) NSInteger habitStanceCountBad;
@property (nonatomic, assign) NSInteger goodCount;
@property (nonatomic, assign) NSInteger neutralCount;
@property (nonatomic, assign) NSInteger badCount;
@property (strong, nonatomic) NSMutableArray *tableHiearchy;
@property (nonatomic, assign) CFTimeInterval startTime;
@property (nonatomic) NSString *habitStartComparisonVar;
@property (nonatomic, assign) NSInteger habitStartComparisonIndex;
@property (nonatomic) NSString *habitEndComparisonVar;
@property (nonatomic, assign) NSInteger habitEndComparisonIndex;

@end
