//
//  TouchPoiViewController.m
//  Category_demo
//
//  Created by songjian on 13-7-17.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "TouchPoiViewController.h"

@interface TouchPoiViewController ()

@property (nonatomic, strong) MAPointAnnotation *poiAnnotation;

@end

@implementation TouchPoiViewController
@synthesize poiAnnotation = _poiAnnotation;


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

#pragma mark - Override

- (void)returnAction
{
    [super returnAction];
    
    self.mapView.touchPOIEnabled = NO;
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

#pragma mark - Initialization

- (void)initNavigationBar
{
    UISwitch *touchPOIEnabledSwitch = [[UISwitch alloc] init];
    [touchPOIEnabledSwitch addTarget:self action:@selector(touchPOIEanbledAction:) forControlEvents:UIControlEventValueChanged];
    touchPOIEnabledSwitch.on = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:touchPOIEnabledSwitch];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    self.mapView.touchPOIEnabled = YES;
}

@end
