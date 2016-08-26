//
//  NaviShareViewController.m
//  officialDemo2D
//
//  Created by xiaoming han on 15/10/29.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "NaviShareViewController.h"

#define kStartTitle     @"起点"
#define kEndTitle       @"终点"

@interface NaviShareViewController ()

/* 起始点经纬度. */
@property (nonatomic, assign) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic, assign) CLLocationCoordinate2D destinationCoordinate;

@end

@implementation NaviShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.startCoordinate        = CLLocationCoordinate2DMake(39.910267, 116.370888);
    self.destinationCoordinate  = CLLocationCoordinate2DMake(39.989872, 116.481956);
    
    [self addDefaultAnnotations];

}

- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = kStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = kEndTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

- (void)shareAction
{
    AMapNavigationShareSearchRequest *request = [[AMapNavigationShareSearchRequest alloc] init];
    request.startCoordinate = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    request.destinationCoordinate = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude];
//    request.strategy = 0;
    
    [self.search AMapNavigationShareSearch:request];
}

#pragma mark - 

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        /* 起点. */
        if ([[annotation title] isEqualToString:(NSString*)kStartTitle])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
        }
        /* 终点. */
        else if([[annotation title] isEqualToString:(NSString*)kEndTitle])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
        }

        
        return poiAnnotationView;
    }
    
    return nil;
}

@end
