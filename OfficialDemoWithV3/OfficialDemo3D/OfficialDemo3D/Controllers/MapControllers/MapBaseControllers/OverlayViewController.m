//
//  OverlayViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "OverlayViewController.h"

enum{
    OverlayViewControllerOverlayTypeCircle = 0,
    OverlayViewControllerOverlayTypePolyline,
    OverlayViewControllerOverlayTypePolygon
};

@interface OverlayViewController ()

@property (nonatomic, strong) NSMutableArray *overlays;

@end

@implementation OverlayViewController
@synthesize overlays = _overlays;

#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        
        circleView.lineWidth   = 8.f;
        circleView.strokeColor = [UIColor blueColor];
        circleView.fillColor   = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return circleView;
    }
    else if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonView *polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        polygonView.lineWidth   = 8.f;
        polygonView.strokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
        polygonView.fillColor   = [UIColor redColor];
        
        return polygonView;
    }
    else if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 8.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
        return polylineView;
    }
    
    return nil;
}

#pragma mark - Initialization

- (void)initOverlays
{
    self.overlays = [NSMutableArray array];
    
    /* Circle. */
    MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.996441, 116.411146) radius:15000];
    [self.overlays insertObject:circle atIndex:OverlayViewControllerOverlayTypeCircle];
    
    /* Polyline. */
    CLLocationCoordinate2D polylineCoords[4];
    polylineCoords[0].latitude = 39.855539;
    polylineCoords[0].longitude = 116.419037;
    
    polylineCoords[1].latitude = 39.858172;
    polylineCoords[1].longitude = 116.520285;
    
    polylineCoords[2].latitude = 39.795479;
    polylineCoords[2].longitude = 116.520859;
    
    polylineCoords[3].latitude = 39.788467;
    polylineCoords[3].longitude = 116.426786;
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:polylineCoords count:4];
    [self.overlays insertObject:polyline atIndex:OverlayViewControllerOverlayTypePolyline];
    
    /* Polygon. */
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
    [self.overlays insertObject:polygon atIndex:OverlayViewControllerOverlayTypePolygon];
}

#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initOverlays];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapView addOverlays:self.overlays];
}

@end
