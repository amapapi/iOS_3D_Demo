//
//  DistanceCalculateViewController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/12.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "DistanceCalculateViewController.h"
#import "UIView+Toast.h"

@interface DistanceCalculateViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSArray *lines;

@property (nonatomic, strong) MAPointAnnotation *pin1;
@property (nonatomic, strong) MAPointAnnotation *pin2;

@end

@implementation DistanceCalculateViewController
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
    
    MAPointAnnotation *pin1 = [[MAPointAnnotation alloc] init];
    pin1.coordinate =  CLLocationCoordinate2DMake(39.992520, 116.336170);
    
    MAPointAnnotation *pin2 = [[MAPointAnnotation alloc] init];
    pin2.coordinate =  CLLocationCoordinate2DMake(39.892520, 116.436170);
    pin2.title = @"拖动我哦";
    
    [self.mapView addAnnotations:@[pin1, pin2]];
    self.pin1 = pin1;
    self.pin2 = pin2;
    
    [self.mapView selectAnnotation:pin2 animated:YES];
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

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState {
    if(newState == MAAnnotationViewDragStateEnding) {
        CLLocationCoordinate2D loc1 = self.pin1.coordinate;
        CLLocationCoordinate2D loc2 = self.pin2.coordinate;
        
        MAMapPoint p1 = MAMapPointForCoordinate(loc1);
        MAMapPoint p2 = MAMapPointForCoordinate(loc2);
        
        CLLocationDistance distance =  MAMetersBetweenMapPoints(p1, p2);
        
        [self.view makeToast:[NSString stringWithFormat:@"distance between two pins = %.2f", distance] duration:1.0];
    }
}

@end
