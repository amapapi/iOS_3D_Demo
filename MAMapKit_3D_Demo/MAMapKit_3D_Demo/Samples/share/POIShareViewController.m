//
//  POIShareViewController.m
//  officialDemo2D
//
//  Created by xiaoming han on 15/10/29.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "POIShareViewController.h"
#import "POIAnnotation.h"

@interface POIShareViewController ()
{
    AMapPOI *_poi;
}
@end

@implementation POIShareViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self searchPoiByID];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiShareIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        poiAnnotationView.canShowCallout = YES;
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    _poi = response.pois[0];
    
    /* 将结果以annotation的形式加载到地图上. */
    POIAnnotation *anno = [[POIAnnotation alloc] initWithPOI:_poi];
    [self.mapView addAnnotation:anno];
    [self.mapView selectAnnotation:anno animated:YES];
}


#pragma mark -

- (void)shareAction
{
    if (_poi == nil)
    {
        NSLog(@"尚未获取POI信息！");
        return;
    }
    
    AMapPOIShareSearchRequest *request = [[AMapPOIShareSearchRequest alloc] init];
    request.uid = _poi.uid;
    request.location = _poi.location;
    request.name = _poi.name;
    request.address = _poi.address;
    [self.search AMapPOIShareSearch:request];
}

- (void)searchPoiByID
{
    AMapPOIIDSearchRequest *request = [[AMapPOIIDSearchRequest alloc] init];
    
    request.uid                 = @"B000A7ZQYC";
    request.requireExtension    = YES;
    
    [self.search AMapPOIIDSearch:request];
    
}


@end
