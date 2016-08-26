//
//  RouteShareViewController.m
//  officialDemo2D
//
//  Created by xiaoming han on 15/10/29.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "RouteShareViewController.h"

#define kStartTitle     @"起点"
#define kEndTitle       @"终点"

@interface RouteShareViewController ()

@property (nonatomic, assign) NSInteger shareRouteType;

/* 起始点经纬度. */
@property (nonatomic, assign) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic, assign) CLLocationCoordinate2D destinationCoordinate;

@end

@implementation RouteShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shareRouteType = 0;
    self.startCoordinate        = CLLocationCoordinate2DMake(39.910267, 116.370888);
    self.destinationCoordinate  = CLLocationCoordinate2DMake(39.989872, 116.481956);
    
    [self addDefaultAnnotations];
    
    [self initToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

#pragma mark - 

- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    /* 类型. */
    UISegmentedControl *searchTypeSegCtl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             @"  驾 车  ",
                                             @"  公 交  ",
                                             @"  步 行  ",
                                             nil]];
    [searchTypeSegCtl setSelectedSegmentIndex:0];
    searchTypeSegCtl.segmentedControlStyle = UISegmentedControlStyleBar;
    [searchTypeSegCtl addTarget:self action:@selector(shareRouteTypeAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *searchTypeItem = [[UIBarButtonItem alloc] initWithCustomView:searchTypeSegCtl];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, searchTypeItem, flexbleItem, nil];
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
    AMapRouteShareSearchRequest *request = [[AMapRouteShareSearchRequest alloc] init];

    request.startCoordinate = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    request.destinationCoordinate = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude];
    
    request.startName = kStartTitle;
    request.destinationName = kEndTitle;
    
    request.type = self.shareRouteType;
//    request.strategy = 0;
    
    [self.search AMapRouteShareSearch:request];
}

/* 切换路径规划搜索类型. */
- (void)shareRouteTypeAction:(UISegmentedControl *)segmentedControl
{
    self.shareRouteType = segmentedControl.selectedSegmentIndex;
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
