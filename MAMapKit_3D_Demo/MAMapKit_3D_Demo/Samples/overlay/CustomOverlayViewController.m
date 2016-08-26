//
//  CustomOverlayViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomOverlayViewController.h"
#import "FaceOverlay.h"
#import "FaceOverlayRenderer.h"

@interface CustomOverlayViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) FaceOverlay *faceOverlay;

@end

@implementation CustomOverlayViewController

#pragma mark - MAMapVieDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[FaceOverlay class]])
    {
        FaceOverlayRenderer *overlayRenderer = [[FaceOverlayRenderer alloc] initWithFaceOverlay:overlay];
        
        overlayRenderer.lineWidth    = 6.f;
        overlayRenderer.strokeColor  = [UIColor blueColor];
        overlayRenderer.fillColor    = [[UIColor redColor] colorWithAlphaComponent:0.4];
        overlayRenderer.lineDash     = YES;
        
        return overlayRenderer;
    }
    
    return nil;
}

#pragma mark - Initialization

- (void)initOverlay
{
    CLLocationCoordinate2D leftEyeCoordinate  = CLLocationCoordinate2DMake(39.933349, 116.315633);
    CLLocationCoordinate2D rightEyeCoordinate = CLLocationCoordinate2DMake(39.948691, 116.492479);
    
    self.faceOverlay = [FaceOverlay faceWithLeftEyeCoordinate:leftEyeCoordinate
                                                leftEyeRadius:5000.f
                                           rightEyeCoordinate:rightEyeCoordinate
                                               rightEyeRadius:5000.f];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initOverlay];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapView addOverlay:self.faceOverlay];
}

#pragma mark - action handling
- (void)returnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
