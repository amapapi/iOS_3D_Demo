//
//  CloudPlaceIDSearchViewController.m
//  officialDemoCloud
//
//  Created by 刘博 on 14-3-14.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "CloudPOIIDSearchViewController.h"
#import "AMapCloudPOIDetailViewController.h"
#import "CloudPOIAnnotation.h"

#define kCloudSearchPOIID   1

@interface CloudPOIIDSearchViewController ()<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation CloudPOIIDSearchViewController

#pragma mark - life cycle
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
    
    [self cloudPlaceIDSearch];
}

#pragma mark - action handle
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Utility

- (void)addAnnotationsWithPOIs:(NSArray *)pois
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (AMapCloudPOI *aPOI in pois)
    {
//        NSLog(@"%@", [aPOI formattedDescription]);
        
        CloudPOIAnnotation *ann = [[CloudPOIAnnotation alloc] initWithCloudPOI:aPOI];
        [self.mapView addAnnotation:ann];
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

- (void)gotoDetailForCloudPOI:(AMapCloudPOI *)cloudPOI
{
    if (cloudPOI != nil)
    {
        AMapCloudPOIDetailViewController *cloudPOIDetailViewController = [[AMapCloudPOIDetailViewController alloc] init];
        cloudPOIDetailViewController.cloudPOI = cloudPOI;
        
        [self.navigationController pushViewController:cloudPOIDetailViewController animated:YES];
    }
}

#pragma mark - Cloud Search

- (void)cloudPlaceIDSearch
{
    AMapCloudPOIIDSearchRequest *placeID = [[AMapCloudPOIIDSearchRequest alloc] init];
    [placeID setTableID:(NSString *)TableID];
    [placeID setUid:kCloudSearchPOIID];
    
    [self.search AMapCloudPOIIDSearch:placeID];
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)onCloudSearchDone:(AMapCloudSearchBaseRequest *)request response:(AMapCloudPOISearchResponse *)response
{
    [self addAnnotationsWithPOIs:[response POIs]];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CloudPOIAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"PlaceIDSearchIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = NO;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[CloudPOIAnnotation class]])
    {
        [self gotoDetailForCloudPOI:[(CloudPOIAnnotation *)view.annotation cloudPOI]];
    }
}

@end
