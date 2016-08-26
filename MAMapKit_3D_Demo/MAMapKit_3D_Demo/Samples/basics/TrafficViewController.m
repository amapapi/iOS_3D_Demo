//
//  TrafficViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "TrafficViewController.h"

@interface TrafficViewController() <MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation TrafficViewController

#pragma mark - Action Handle

- (void)trafficAction:(UISwitch *)switcher
{
    self.mapView.showTraffic = switcher.on;
}

- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    UISwitch *trafficSwitch = [[UISwitch alloc] init];
    [trafficSwitch addTarget:self action:@selector(trafficAction:) forControlEvents:UIControlEventValueChanged];
    trafficSwitch.on = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:trafficSwitch];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
    
     self.mapView.showTraffic = YES;
}

@end
