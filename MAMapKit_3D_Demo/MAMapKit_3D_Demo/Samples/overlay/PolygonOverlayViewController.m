//
//  PolygonOverlayViewController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/10.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "PolygonOverlayViewController.h"

@interface PolygonOverlayViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSArray *polygons;

@end

@implementation PolygonOverlayViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initPolygons];
    
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
    
    [self.mapView addOverlays:self.polygons];
}

#pragma mark - Initialization
- (void)initPolygons {
    NSMutableArray *arr = [NSMutableArray array];
    
    CLLocationCoordinate2D coordinates[4];
    coordinates[0].latitude = 39.781892;
    coordinates[0].longitude = 116.293413;
    
    coordinates[1].latitude = 39.787600;
    coordinates[1].longitude = 116.391842;
    
    coordinates[2].latitude = 39.733187;
    coordinates[2].longitude = 116.417932;
    
    coordinates[3].latitude = 39.704653;
    coordinates[3].longitude = 116.338255;
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:4];
    [arr addObject:polygon];
    
    CLLocationCoordinate2D rectPoints[4];
    rectPoints[0].latitude = 39.887600;
    rectPoints[0].longitude = 116.518932;
    
    rectPoints[1].latitude = 39.781892;
    rectPoints[1].longitude = 116.518932;
    
    rectPoints[2].latitude = 39.781892;
    rectPoints[2].longitude = 116.428932;
    
    rectPoints[3].latitude = 39.887600;
    rectPoints[3].longitude = 116.428932;
    MAPolygon *rectangle = [MAPolygon polygonWithCoordinates:rectPoints count:4];
    [arr addObject:rectangle];
    
    self.polygons = [NSArray arrayWithArray:arr];
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polygonRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polygonRenderer.lineWidth   = 4.f;
        polygonRenderer.strokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
        polygonRenderer.fillColor   = [UIColor redColor];
        
        return polygonRenderer;
    }

    
    return nil;
}
@end