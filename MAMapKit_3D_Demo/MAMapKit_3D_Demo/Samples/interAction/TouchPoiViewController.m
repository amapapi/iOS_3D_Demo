//
//  TouchPoiViewController.m
//  Category_demo
//
//  Created by songjian on 13-7-17.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "TouchPoiViewController.h"

@interface TouchPoiViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAPointAnnotation *poiAnnotation;

@end

@implementation TouchPoiViewController
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    UISwitch *touchPOIEnabledSwitch = [[UISwitch alloc] init];
    [touchPOIEnabledSwitch addTarget:self action:@selector(touchPOIEanbledAction:) forControlEvents:UIControlEventValueChanged];
    touchPOIEnabledSwitch.on = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:touchPOIEnabledSwitch];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.907728, 116.397968);
    self.mapView.showsUserLocation = NO;
    self.mapView.touchPOIEnabled = YES;
    [self.view addSubview:self.mapView];
}


#pragma mark - Utility

/* Convert MATouchPoi to MAPointAnnotation. */
- (MAPointAnnotation *)annotationForTouchPoi:(MATouchPoi *)touchPoi
{
    if (touchPoi == nil)
    {
        return nil;
    }
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    
    annotation.coordinate = touchPoi.coordinate;
    annotation.title      = touchPoi.name;
    
    return annotation;
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *touchPoiReuseIndetifier = @"touchPoiReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:touchPoiReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:touchPoiReuseIndetifier];
        }
        
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop   = NO;
        annotationView.draggable      = NO;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois
{
    if (pois.count == 0)
    {
        return;
    }
    
    MAPointAnnotation *annotation = [self annotationForTouchPoi:pois[0]];
    
    /* Remove prior annotation. */
    [self.mapView removeAnnotation:self.poiAnnotation];
    
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
    
    self.poiAnnotation = annotation;
}

#pragma mark - Action Handle

- (void)touchPOIEanbledAction:(UISwitch *)switcher
{
    self.mapView.touchPOIEnabled = switcher.on;
}

- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
