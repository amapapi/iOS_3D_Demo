//
//  OfflineViewController.m
//  Category_demo
//
//  Created by songjian on 13-7-9.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "OfflineViewController.h"
#import "OfflineDetailViewController.h"

@interface OfflineViewController()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation OfflineViewController
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"城市列表"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(detailAction)];

    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 11;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.907728, 116.397968);
    [self.view addSubview:self.mapView];
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailAction
{
    OfflineDetailViewController *detailViewController = [[OfflineDetailViewController alloc] init];
    detailViewController.mapView = self.mapView;
    detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [self presentViewController:navi animated:YES completion:nil];
}

@end
