//
//  CustomUserLocationStyleViewController.m
//  OfficialDemo3D
//
//  Created by songjian on 14-2-19.
//  Copyright (c) 2014年 songjian. All rights reserved.
//

#import "CustomUserLocationStyleViewController.h"

@interface CustomUserLocationStyleViewController ()

@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@end

@implementation CustomUserLocationStyleViewController
@synthesize userLocationAnnotationView = _userLocationAnnotationView;

#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleView *accuracyCircleView = [[MACircleView alloc] initWithCircle:overlay];
        
        accuracyCircleView.lineWidth   = 2.f;
        accuracyCircleView.strokeColor = [UIColor lightGrayColor];
        accuracyCircleView.fillColor   = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return accuracyCircleView;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        
        self.userLocationAnnotationView = annotationView;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
}

#pragma mark - Override

- (void)returnAction
{
    [super returnAction];
    
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
    
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /* 通过- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay, 自定义定位精度对应的MACircleView. */
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

@end
