//
//  GeoViewController.m
//  officialDemo2D
//
//  Created by PC on 15/8/27.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "GeoViewController.h"
#import "GeocodeAnnotation.h"
#import "GeoDetailViewController.h"
#import "CommonUtility.h"

@interface GeoViewController() <MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UIButton *tapButton;

@end

@implementation GeoViewController

#pragma mark - Utility

- (void)gotoDetailForGeocode:(AMapGeocode *)geocode
{
    if (geocode != nil)
    {
        GeoDetailViewController *geoDetailViewController = [[GeoDetailViewController alloc] init];
        geoDetailViewController.geocode = geocode;
        
        [self.navigationController pushViewController:geoDetailViewController animated:YES];
    }
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[GeocodeAnnotation class]])
    {
        [self gotoDetailForGeocode:[(GeocodeAnnotation*)view.annotation geocode]];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[GeocodeAnnotation class]])
    {
        static NSString *geoCellIdentifier = @"geoCellIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:geoCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:geoCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    
    return nil;
}


#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
        
        [annotations addObject:geocodeAnnotation];
    }];
    
    if (annotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[annotations[0] coordinate] animated:YES];
    }
    else
    {
        [self.mapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:annotations]
                               animated:YES];
    }
    
    [self.mapView addAnnotations:annotations];
}

#pragma mark - HandleAction

- (void)tapAction
{
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = self.tapButton.titleLabel.text;

    [self.search AMapGeocodeSearch:geo];
}

- (void)returnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Initailization

- (void)initTapButton
{
    self.tapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*0.9, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height*0.1)];
    [self.tapButton setTitle:@"北京市朝阳区阜荣街10号" forState:UIControlStateNormal];
    [self.tapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tapButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    self.tapButton.backgroundColor = [UIColor blackColor];
    [self.tapButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    self.tapButton.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:self.tapButton];
}


#pragma mark - Life Cycle

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
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initTapButton];
}

@end
