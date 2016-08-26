//
//  CircleOverlayViewController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/10.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "CircleOverlayViewController.h"
@interface CircleOverlayViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSArray *circles;

@end

@implementation CircleOverlayViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCircles];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.mapView addOverlays:self.circles];
}

#pragma mark - Initialization
- (void)initCircles {
    NSMutableArray *arr = [NSMutableArray array];
    /* Circle. */
    MACircle *circle1 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.996441, 116.411146) radius:15000];
    [arr addObject:circle1];
    
    
    MACircle *circle2 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(40.096441, 116.511146) radius:12000];
    [arr addObject:circle2];
    
    MACircle *circle3 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.896441, 116.311146) radius:9000];
    [arr addObject:circle3];
    
    
    self.circles = [NSArray arrayWithArray:arr];
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth   = 4.f;
        circleRenderer.strokeColor = [UIColor blueColor];
        
        NSInteger index = [self.circles indexOfObject:overlay];
        if(index == 0) {
            circleRenderer.fillColor   = [[UIColor redColor] colorWithAlphaComponent:0.3];
        } else if(index == 1) {
            circleRenderer.fillColor   = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        } else if(index == 2) {
            circleRenderer.fillColor   = [[UIColor blueColor] colorWithAlphaComponent:0.3];
        } else {
            circleRenderer.fillColor   = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
        }
        
        return circleRenderer;
    }
    
    return nil;
}
@end
