//
//  GeodesicViewController.m
//  officialDemo2D
//
//  Created by 刘博 on 13-10-24.
//  Copyright (c) 2013年 AutoNavi. All rights reserved.
//

#import "GeodesicViewController.h"

@interface GeodesicViewController ()

@property (nonatomic, strong) MAGeodesicPolyline *geodesicPolyline;

@end

@implementation GeodesicViewController

@synthesize geodesicPolyline = _geodesicPolyline;

#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAGeodesicPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 4.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
        return polylineView;
    }
    
    return nil;
}

#pragma mark - Initialization

- (void)initGeodesicPolyline
{
    CLLocationCoordinate2D geodesicCoords[2];
    
    geodesicCoords[0].latitude  = 39.905151;
    geodesicCoords[0].longitude = 116.401726;
    
    geodesicCoords[1].latitude  = 38.905151;
    geodesicCoords[1].longitude = 70.401726;
    
    self.geodesicPolyline = [MAGeodesicPolyline polylineWithCoordinates:geodesicCoords
                                                                  count:(sizeof(geodesicCoords)/sizeof(CLLocationCoordinate2D))];
}

#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initGeodesicPolyline];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mapView addOverlay:self.geodesicPolyline];
    
    [self.mapView setVisibleMapRect:self.geodesicPolyline.boundingMapRect animated:NO];
}

@end
