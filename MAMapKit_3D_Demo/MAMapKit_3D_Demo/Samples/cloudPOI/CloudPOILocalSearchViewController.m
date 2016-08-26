//
//  CloudPlaceLocalSearchViewController.m
//  officialDemoCloud
//
//  Created by LiuX on 14-9-11.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "CloudPOILocalSearchViewController.h"
#import "AMapCloudPOIDetailViewController.h"
#import "CloudPOIAnnotation.h"

#define kCloudSearchCity   @"北京"

@interface CloudPOILocalSearchViewController ()<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation CloudPOILocalSearchViewController

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
    
    [self cloudPlaceLocalSearch];
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
//      NSLog(@"%@", [aPOI formattedDescription]);
        
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

- (void)cloudPlaceLocalSearch
{
    AMapCloudPOILocalSearchRequest *placeLocal = [[AMapCloudPOILocalSearchRequest alloc] init];
    [placeLocal setTableID:(NSString *)TableID];
    [placeLocal setCity:kCloudSearchCity];
    [placeLocal setKeywords:@""];
    
//  NSArray *filters = [[NSArray alloc] initWithObjects:@"name:1",nil];
//  [placeLocal setFilter:filters];
    
//  NSArray *filters = [[NSArray alloc] initWithObjects:@"_id:[1,100]",@"type:2",nil];
    
//  [placeLocal setFilter:filters];
    

    [self.search AMapCloudPOILocalSearch:placeLocal];
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
        static NSString *pointReuseIndetifier = @"PlaceAroundSearchIndetifier";
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
