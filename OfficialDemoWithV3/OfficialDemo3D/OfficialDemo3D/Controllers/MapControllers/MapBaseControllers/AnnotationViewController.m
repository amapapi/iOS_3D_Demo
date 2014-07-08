//
//  AnnotationViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "AnnotationViewController.h"

enum {
    AnnotationViewControllerAnnotationTypeRed = 0,
    AnnotationViewControllerAnnotationTypeGreen,
    AnnotationViewControllerAnnotationTypePurple
};

@interface AnnotationViewController ()

@property (nonatomic, strong) NSMutableArray *annotations;

@end

@implementation AnnotationViewController
@synthesize annotations = _annotations;

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.pinColor                     = [self.annotations indexOfObject:annotation];
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Initialization

- (void)initAnnotations
{
    self.annotations = [NSMutableArray array];
    
    /* Red annotation. */
    MAPointAnnotation *red = [[MAPointAnnotation alloc] init];
    red.coordinate = CLLocationCoordinate2DMake(39.911447, 116.406026);
    red.title      = @"Red";
    [self.annotations insertObject:red atIndex:AnnotationViewControllerAnnotationTypeRed];
    
    /* Green annotation. */
    MAPointAnnotation *green = [[MAPointAnnotation alloc] init];
    green.coordinate = CLLocationCoordinate2DMake(39.909698, 116.296248);
    green.title      = @"Green";
    [self.annotations insertObject:green atIndex:AnnotationViewControllerAnnotationTypeGreen];
    
    /* Purple annotation. */
    MAPointAnnotation *purple = [[MAPointAnnotation alloc] init];
    purple.coordinate = CLLocationCoordinate2DMake(40.045837, 116.460577);
    purple.title      = @"Purple";
    [self.annotations insertObject:purple atIndex:AnnotationViewControllerAnnotationTypePurple];
}

#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initAnnotations];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapView addAnnotations:self.annotations];
}

@end
