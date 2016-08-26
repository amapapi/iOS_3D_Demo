//
//  RoutePlanBusViewController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/12.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "RoutePlanBusViewController.h"
#import "RouteDetailViewController.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"

static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface RoutePlanBusViewController ()<MAMapViewDelegate, AMapSearchDelegate>
/* 路径规划类型 */
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) AMapRoute *route;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;

@end

@implementation RoutePlanBusViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.startCoordinate        = CLLocationCoordinate2DMake(39.910267, 116.370888);
    self.destinationCoordinate  = CLLocationCoordinate2DMake(39.989872, 116.481956);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"详情"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(detailAction)];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    
    [self initToolBar];
    [self addDefaultAnnotations];
    [self updateCourseUI];
    [self updateDetailUI];
    
    [self searchRoutePlanningBus];
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

#pragma mark - do search
- (void)searchRoutePlanningBus
{
    self.startAnnotation.coordinate = self.startCoordinate;
    self.destinationAnnotation.coordinate = self.destinationCoordinate;
    
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.city             = @"beijing";
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapTransitRouteSearch:navi];
}

#pragma mark - action handle
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

/* 切到上一个方案路线. */
- (void)previousCourseAction
{
    if ([self decreaseCurrentCourse])
    {
        [self clear];
        
        [self updateCourseUI];
        
        [self presentCurrentCourse];
    }
}

/* 切到下一个方案路线. */
- (void)nextCourseAction
{
    if ([self increaseCurrentCourse])
    {
        [self clear];
        
        [self updateCourseUI];
        
        [self presentCurrentCourse];
    }
}

/* 进入详情页面. */
- (void)detailAction
{
    if (self.route == nil)
    {
        return;
    }
    
    [self gotoDetailForRoute:self.route type:AMapRoutePlanningTypeBus];
}

#pragma mark - Utility
/* 更新"上一个", "下一个"按钮状态. */
- (void)updateCourseUI
{
    /* 上一个. */
    self.previousItem.enabled = (self.currentCourse > 0);
    
    /* 下一个. */
    self.nextItem.enabled = (self.currentCourse < self.totalCourse - 1);
}

/* 更新"详情"按钮状态. */
- (void)updateDetailUI
{
    self.navigationItem.rightBarButtonItem.enabled = self.route != nil;
}

- (void)updateTotal
{
    self.totalCourse = self.route.transits.count;
}

- (BOOL)increaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse < self.totalCourse - 1)
    {
        self.currentCourse++;
        
        result = YES;
    }
    
    return result;
}

- (BOOL)decreaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse > 0)
    {
        self.currentCourse--;
        
        result = YES;
    }
    
    return result;
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentCourse] startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}

/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
}

/* 进入详情页面. */
- (void)gotoDetailForRoute:(AMapRoute *)route type:(AMapRoutePlanningType)type
{
    RouteDetailViewController *routeDetailViewController = [[RouteDetailViewController alloc] init];
    routeDetailViewController.route      = route;
    routeDetailViewController.routePlanningType = type;
    
    [self.navigationController pushViewController:routeDetailViewController animated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth  = 8;
        polylineRenderer.lineDash = YES;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 10;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
}

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
        poiAnnotationView.image = nil;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    poiAnnotationView.image = [UIImage imageNamed:@"railway_station"];
                    break;
                    
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    
    [self updateCourseUI];
    [self updateDetailUI];
    
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}

#pragma mark - Initialization
- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    /* 上一个. */
    UIBarButtonItem *previousItem = [[UIBarButtonItem alloc] initWithTitle:@"上一个"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(previousCourseAction)];
    self.previousItem = previousItem;
    
    /* 下一个. */
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"下一个"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(nextCourseAction)];
    self.nextItem = nextItem;
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, previousItem, flexbleItem, nextItem, flexbleItem, nil];
}

- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    self.destinationAnnotation = destinationAnnotation;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}


@end