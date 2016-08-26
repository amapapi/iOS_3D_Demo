//
//  DistanceCalculateViewController2.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/12.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "DistanceCalculateViewController2.h"
#import "UIView+Toast.h"
#import "CommonUtility.h"

@interface DistanceCalculateViewController2 ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) MAPolyline *line;

@end

@implementation DistanceCalculateViewController2
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
    
    [self.view addSubview:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    //line 1
    CLLocationCoordinate2D line1Points[2];
    line1Points[0].latitude = 39.925539;
    line1Points[0].longitude = 116.0;
    
    line1Points[1].latitude = 39.925539;
    line1Points[1].longitude = 116.5;
    
    MAPolyline *line1 = [MAPolyline polylineWithCoordinates:line1Points count:2];
    [self.mapView addOverlay:line1];
    self.line = line1;
    
    MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
    a1.title = @"拖动我哦";
    a1.coordinate =  CLLocationCoordinate2DMake(39.992520, 116.336170);
    [self.mapView addAnnotation:a1];
    
    [self.mapView selectAnnotation:a1 animated:YES];
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        annotationView.rightCalloutAccessoryView    = nil;
        annotationView.pinColor                     = MAPinAnnotationColorRed;
        
        return annotationView;
    }
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.strokeColor = [UIColor blueColor];
        polylineRenderer.lineWidth   = 2.f;
        polylineRenderer.lineDash = NO;
        
        return polylineRenderer;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState {
    if(newState == MAAnnotationViewDragStateEnding) {
        CLLocationCoordinate2D loc = view.annotation.coordinate;
        MAMapPoint p = MAMapPointForCoordinate(loc);
        double distance = [CommonUtility distanceToPoint:p fromLineSegmentBetween:self.line.points[0] and:self.line.points[1]];

        [self.view makeToast:[NSString stringWithFormat:@"%f", distance] duration:1.0];
    }
}
@end
