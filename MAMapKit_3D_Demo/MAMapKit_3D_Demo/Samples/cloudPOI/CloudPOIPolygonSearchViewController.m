//
//  CloudPlacePolygonSearchViewController.m
//  AMapCloudDemo
//
//  Created by 刘博 on 14-3-14.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "CloudPOIPolygonSearchViewController.h"
#import "AMapCloudPOIDetailViewController.h"
#import "CloudPOIAnnotation.h"
#import "APIKey.h"

@interface CloudPOIPolygonSearchViewController ()<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation CloudPOIPolygonSearchViewController


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
    
    [self cloudPlacePolygonSearch];
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

- (void)addMAPolygonWithPoints:(NSArray *)points
{
    unsigned long count = [points count];
    CLLocationCoordinate2D coordinates[count];
    for (int i = 0; i < count; i++)
    {
        coordinates[i] = CLLocationCoordinate2DMake([[points objectAtIndex:i] latitude], [[points objectAtIndex:i] longitude]);
    }
    
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:count];
    [self.mapView addOverlay:polygon];
}

#pragma mark - Cloud Search
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)cloudPlacePolygonSearch
{
    AMapCloudPOIPolygonSearchRequest *placePolygon = [[AMapCloudPOIPolygonSearchRequest alloc] init];
    [placePolygon setTableID:(NSString *)TableID];
    
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:0];
    AMapGeoPoint *point1 = [AMapGeoPoint locationWithLatitude:39.941711 longitude:116.382248];
    AMapGeoPoint *point2 = [AMapGeoPoint locationWithLatitude:39.884882 longitude:116.359566];
    AMapGeoPoint *point3 = [AMapGeoPoint locationWithLatitude:39.878120 longitude:116.437630];
    [points addObject:point1];
    [points addObject:point2];
    [points addObject:point3];
    [points addObject:point1];
    [placePolygon setPolygon:[AMapGeoPolygon polygonWithPoints:points]];
    [placePolygon setOffset:50];
    
    [self.search AMapCloudPOIPolygonSearch:placePolygon];
    
    [self addMAPolygonWithPoints:points];
}

#pragma mark - AMapCloudSearchDelegate

- (void)onCloudSearchDone:(AMapCloudSearchBaseRequest *)request response:(AMapCloudPOISearchResponse *)response
{
    [self addAnnotationsWithPOIs:[response POIs]];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CloudPOIAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"PlacePolygonSearchIndetifier";
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
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polygonRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        
        polygonRenderer.lineWidth       = 1.f;
        polygonRenderer.lineDash = YES;
        polygonRenderer.strokeColor     = [UIColor blueColor];
        polygonRenderer.fillColor       = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return polygonRenderer;
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
