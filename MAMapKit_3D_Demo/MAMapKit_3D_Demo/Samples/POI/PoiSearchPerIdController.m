//
//  PoiSearchPerIdController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/11.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "PoiSearchPerIdController.h"
#import "POIAnnotation.h"
#import "PoiDetailViewController.h"
#import "CommonUtility.h"

#define kPoiIdentifier @"B000A7ZQYC"

@interface PoiSearchPerIdController ()<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation PoiSearchPerIdController
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
    
    [self searchPoiByID:kPoiIdentifier];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MAAnnotation> annotation = view.annotation;
    
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;
        
        PoiDetailViewController *detail = [[PoiDetailViewController alloc] init];
        detail.poi = poiAnnotation.poi;
        
        /* 进入POI详情页面. */
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
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

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:NO];
    }
}

#pragma mark - Utility

/* 根据ID来搜索POI. */
- (void)searchPoiByID:(NSString *)poiId
{
    AMapPOIIDSearchRequest *request = [[AMapPOIIDSearchRequest alloc] init];
    
    request.uid                 = poiId;
    request.requireExtension    = YES;
    
    [self.search AMapPOIIDSearch:request];
    
}

#pragma mark - Handle Action

- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
