//
//  CloudPlaceAroundSearchViewController.m
//  AMapCloudDemo
//
//  Created by 刘博 on 14-3-11.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "CloudPOIAroundSearchViewController.h"
#import "AMapCloudPOIDetailViewController.h"
#import "CloudPOIAnnotation.h"
#import "APIKey.h"

#define RADIUS 5000

@interface CloudPOIAroundSearchViewController ()<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation CloudPOIAroundSearchViewController

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
    
    [self cloudPlaceAroundSearch];
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

- (void)addMACircleViewWithCenter:(CLLocationCoordinate2D)center radius:(double)radius
{
    MACircle *circle = [MACircle circleWithCenterCoordinate:center radius:radius];
    
    [self.mapView addOverlay:circle];
}

#pragma mark - Cloud Search

- (void)cloudPlaceAroundSearch
{
    AMapCloudPOIAroundSearchRequest *placeAround = [[AMapCloudPOIAroundSearchRequest alloc] init];
    [placeAround setTableID:(NSString *)TableID];
    
    [placeAround setRadius:RADIUS];
    
    AMapGeoPoint *centerPoint = [AMapGeoPoint locationWithLatitude:39.880172 longitude:116.410588];

    [placeAround setCenter:centerPoint];
    
    [placeAround setKeywords:@""];
    
    //过滤条件数组filters的含义等同于SQL语句:WHERE _address = "北京" AND _id BETWEEN 1 AND 20
   NSArray *filters = [[NSArray alloc] initWithObjects:@"_id:[1,20]", @"_address:北京",nil];
   [placeAround setFilter:filters];
    
   [placeAround setSortFields:@"_id"];
   [placeAround setSortType:AMapCloudSortTypeDESC];
    
    [placeAround setOffset:0];
//  [placeAround setPage:1];
    
    [self.search AMapCloudPOIAroundSearch:placeAround];
    
    [self addMACircleViewWithCenter:CLLocationCoordinate2DMake(centerPoint.latitude, centerPoint.longitude) radius:RADIUS];
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

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth        = 1.f;
        circleRenderer.lineDash  = YES;
        circleRenderer.strokeColor      = [UIColor blueColor];
        circleRenderer.fillColor        = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return circleRenderer;
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
