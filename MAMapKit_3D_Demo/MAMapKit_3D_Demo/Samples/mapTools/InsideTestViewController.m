//
//  InsideTestViewController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/12.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "InsideTestViewController.h"
#import "UIView+Toast.h"

@interface InsideTestViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) MAPolygon *polygon;

@end

@implementation InsideTestViewController
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
    
    CLLocationCoordinate2D coordinates[4];
    coordinates[0].latitude = 39.881892;
    coordinates[0].longitude = 116.293413;
    
    coordinates[1].latitude = 39.887600;
    coordinates[1].longitude = 116.391842;
    
    coordinates[2].latitude = 39.833187;
    coordinates[2].longitude = 116.417932;
    
    coordinates[3].latitude = 39.804653;
    coordinates[3].longitude = 116.338255;
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:4];
    
    [self.mapView addOverlay:polygon];
    
    self.polygon = polygon;
    
    MAPointAnnotation *pin1 = [[MAPointAnnotation alloc] init];
    pin1.title = @"拖动我哦";
    pin1.coordinate =  CLLocationCoordinate2DMake(39.992520, 116.336170);
    
    [self.mapView addAnnotation:pin1];
    
    [self.mapView selectAnnotation:pin1 animated:YES];
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

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState {
    if(newState == MAAnnotationViewDragStateEnding) {
        CLLocationCoordinate2D loc1 = view.annotation.coordinate;
        MAMapPoint p1 = MAMapPointForCoordinate(loc1);
        
        if(MAPolygonContainsPoint(p1, self.polygon.points, 4)) {
            [self.view makeToast:@"inside" duration:1.0];
        } else {
            [self.view makeToast:@"not inside" duration:1.0];
        }
    }
}
@end
