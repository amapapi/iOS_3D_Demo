//
//  GeoViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "TipViewController.h"
#import "CommonUtility.h"
#import "AMapTipAnnotation.h"
#import "BusStopAnnotation.h"
#import "POIAnnotation.h"
#import "BusStopDetailViewController.h"
#import "PoiDetailViewController.h"
#import "TipDetailViewController.h"

#define TipPlaceHolder @"名称"
#define BusLinePaddingEdge 20

@interface TipViewController ()<MAMapViewDelegate, AMapSearchDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayController;

@property (nonatomic, strong) NSMutableArray *tips;

@property (nonatomic, strong) NSMutableArray *busLines;

@end

@implementation TipViewController
@synthesize tips = _tips;
@synthesize searchBar = _searchBar;
@synthesize displayController = _displayController;

#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.tips = [NSMutableArray array];
        self.busLines = [NSMutableArray array];
    }
    
    return self;
}

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
    
    [self initSearchBar];
    
    [self initSearchDisplay];
}

#pragma mark - action handling
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Utility

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    tips.city     = @"北京";
    //    tips.cityLimit = YES; 是否限制城市
    
    [self.search AMapInputTipsSearch:tips];
}

/* 清除annotations & overlays */
- (void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (void)clearAndShowAnnotationWithTip:(AMapTip *)tip
{
    /* 清除annotations & overlays */
    [self clear];
    
    if (tip.uid != nil && tip.location != nil) /* 可以直接在地图打点  */
    {
        AMapTipAnnotation *annotation = [[AMapTipAnnotation alloc] initWithMapTip:tip];
        [self.mapView addAnnotation:annotation];
        [self.mapView setCenterCoordinate:annotation.coordinate];
        [self.mapView selectAnnotation:annotation animated:YES];
    }
    else if (tip.uid != nil && tip.location == nil)/* 公交路线，显示出来*/
    {
        AMapBusLineIDSearchRequest *request = [[AMapBusLineIDSearchRequest alloc] init];
        request.city                        = @"北京";
        request.uid                         = tip.uid;
        request.requireExtension            = YES;
        
        [self.search AMapBusLineIDSearch:request];
    }
    else if(tip.uid == nil && tip.location == nil)/* 品牌名，进行POI关键字搜索 */
    {
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        
        request.keywords         = tip.name;
        request.city             = @"010";
        request.requireExtension = YES;
        [self.search AMapPOIKeywordsSearch:request];
    }
}

/* 展示公交线路 */
- (void)presentCurrentBusLine
{
    AMapBusLine *busLine = [self.busLines firstObject];
    
    if (busLine == nil)
    {
        return;
    }
    
    NSMutableArray *busStopAnnotations = [NSMutableArray array];
    
    [busLine.busStops enumerateObjectsUsingBlock:^(AMapBusStop *busStop, NSUInteger idx, BOOL *stop) {
        BusStopAnnotation *annotation = [[BusStopAnnotation alloc] initWithBusStop:busStop];
        
        [busStopAnnotations addObject:annotation];
    }];
    
    [self.mapView addAnnotations:busStopAnnotations];
    
    MAPolyline *polyline = [CommonUtility polylineForBusLine:busLine];
    
    [self.mapView addOverlay:polyline];
    
    [self.mapView setVisibleMapRect:polyline.boundingMapRect edgePadding:UIEdgeInsetsMake(BusLinePaddingEdge, BusLinePaddingEdge, BusLinePaddingEdge, BusLinePaddingEdge) animated:YES];
}

- (void)gotoDetailForTip:(AMapTip *)tip
{
    if (tip != nil)
    {
        TipDetailViewController *tipDetailViewController = [[TipDetailViewController alloc] init];
        tipDetailViewController.tip                      = tip;
        
        [self.navigationController pushViewController:tipDetailViewController animated:YES];
    }
}

- (void)gotoDetailForBusStop:(AMapBusStop *)busStop
{
    if (busStop != nil)
    {
        BusStopDetailViewController *busStopDetailViewController = [[BusStopDetailViewController alloc] init];
        busStopDetailViewController.busStop                      = busStop;
        
        [self.navigationController pushViewController:busStopDetailViewController animated:YES];
    }
}

- (void)gotoDetailForPoi:(AMapPOI *)poi
{
    if (poi != nil)
    {
        PoiDetailViewController *detail = [[PoiDetailViewController alloc] init];
        detail.poi                      = poi;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[AMapTipAnnotation class]])
    {
        [self gotoDetailForTip:[(AMapTipAnnotation *)view.annotation tip]];
    }
    else if ([view.annotation isKindOfClass:[BusStopAnnotation class]])
    {
        [self gotoDetailForBusStop:[(BusStopAnnotation*)view.annotation busStop]];
    }
    else if ([view.annotation isKindOfClass:[POIAnnotation class]])
    {
        [self gotoDetailForPoi:[(POIAnnotation *)view.annotation poi]];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[AMapTipAnnotation class]])
    {
        static NSString *tipIdentifier = @"tipIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:tipIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:tipIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    else if ([annotation isKindOfClass:[BusStopAnnotation class]])
    {
        static NSString *busStopIdentifier = @"busStopIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:busStopIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:busStopIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    else if ([annotation isKindOfClass:[POIAnnotation class]])
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

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 4.f;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    
    [self.displayController.searchResultsTableView reloadData];
}

/* 公交搜索回调. */
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    if (response.buslines.count != 0)
    {
        [self.busLines setArray:response.buslines];
        
        [self presentCurrentBusLine];
    }
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
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

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *key = searchBar.text;
    /* 按下键盘enter, 搜索poi */
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords         = key;
    request.city             = @"010";
    request.requireExtension = YES;
    [self.search AMapPOIKeywordsSearch:request];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = key;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchTipsWithKey:searchString];
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
        cell.imageView.image = [UIImage imageNamed:@"locate"];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    if (tip.location == nil)
    {
        cell.imageView.image = [UIImage imageNamed:@"search"];
    }
    
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.address;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapTip *tip = self.tips[indexPath.row];
    
    [self clearAndShowAnnotationWithTip:tip];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = tip.name;
}

#pragma mark - Initialization

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    self.searchBar.barStyle     = UIBarStyleBlack;
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    
    self.searchBar.placeholder  = TipPlaceHolder;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:self.searchBar];
}

- (void)initSearchDisplay
{
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.displayController.delegate                = self;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsDelegate   = self;
    self.displayController.searchContentsController.edgesForExtendedLayout = UIRectEdgeNone;
}

@end
