//
//  ChangeCenterViewController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/16.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "ChangeCenterViewController.h"


@interface ChangeCenterViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation ChangeCenterViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 11;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.907728, 116.397968);
    [self.view addSubview:self.mapView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    label.textColor = [UIColor whiteColor];
    label.text = @"点击地图改变地图中心点";
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:label];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CLLocationCoordinate2D newLoc = CLLocationCoordinate2DMake(39.957995, 116.454246);
    [self changeCenterTo:newLoc];
}

- (void)changeCenterTo:(CLLocationCoordinate2D)newLoc
{
    [self.mapView setCenterCoordinate:newLoc animated:YES];
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - mapView Delegate
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self changeCenterTo:coordinate];
}

@end
