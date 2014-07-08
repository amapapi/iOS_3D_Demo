//
//  GroundOverlayViewController.m
//  OfficialDemo3D
//
//  Created by songjian on 13-11-19.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "GroundOverlayViewController.h"

@interface GroundOverlayViewController ()

@property (nonatomic, strong) MAGroundOverlay *groundOverlay;

@end

@implementation GroundOverlayViewController
@synthesize groundOverlay = _groundOverlay;

#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayView *groundOverlayView = [[MAGroundOverlayView alloc] initWithGroundOverlay:overlay];
        
        return groundOverlayView;
    }
    
    return nil;
}

#pragma mark - initialization

- (void)initGroundOverlay
{
    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake(39.939577, 116.388331),
                                                                 CLLocationCoordinate2DMake(39.935029, 116.384377));
    
    self.groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:[UIImage imageNamed:@"GWF"]];
}

#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initGroundOverlay];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView addOverlay:self.groundOverlay];
    
    self.mapView.visibleMapRect = self.groundOverlay.boundingMapRect;
}

@end
