//
//  ChangeZoomViewController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/16.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "ChangeZoomViewController.h"


@interface ChangeZoomViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation ChangeZoomViewController

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
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.907728, 116.397968);
    [self.view addSubview:self.mapView];
    
    UIView *zoomPannelView = [self makeZoomPannelView];
    zoomPannelView.center = CGPointMake(self.view.bounds.size.width -  CGRectGetMidX(zoomPannelView.bounds) - 10,
                                        self.view.bounds.size.height -  CGRectGetMidY(zoomPannelView.bounds) - 10);
    
    zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:zoomPannelView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
}

@end
