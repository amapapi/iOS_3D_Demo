//
//  InvertGeoViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "InvertGeoViewController.h"
#import "InvertGeoDetailViewController.h"
#import "ReGeocodeAnnotation.h"
#import "CommonUtility.h"
#import "MANaviAnnotationView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#define RightCallOutTag 1
#define LeftCallOutTag 2

@interface InvertGeoViewController ()<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL isSearchFromDragging;
@property (nonatomic, strong) ReGeocodeAnnotation *annotation;

@end

@implementation InvertGeoViewController

- (void)gotoDetailForReGeocode:(AMapReGeocode *)reGeocode
{
    if (reGeocode != nil)
    {
        InvertGeoDetailViewController *invertGeoDetailViewController = [[InvertGeoDetailViewController alloc] init];
        
        invertGeoDetailViewController.reGeocode = reGeocode;
        
        [self.navigationController pushViewController:invertGeoDetailViewController animated:YES];
    }
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];

    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    _isSearchFromDragging = NO;
    [self searchReGeocodeWithCoordinate:coordinate];
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        if ([control tag] == RightCallOutTag)
        {
            [self gotoDetailForReGeocode:[(ReGeocodeAnnotation*)view.annotation reGeocode]];
        }
        else if([control tag] == LeftCallOutTag)
        {
            AMapNaviConfig * config = [[AMapNaviConfig alloc] init];
            config.destination    = view.annotation.coordinate;
            config.appScheme      = [CommonUtility getApplicationScheme];
            config.appName        = [CommonUtility getApplicationName];
            config.strategy       = AMapDrivingStrategyShortest;
            
            if(![AMapURLSearch openAMapNavigation:config])
            {
                [AMapURLSearch getLatestAMapApp];
            }
        }
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        static NSString *invertGeoIdentifier = @"invertGeoIdentifier";
        
        MANaviAnnotationView *poiAnnotationView = (MANaviAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:invertGeoIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MANaviAnnotationView alloc] initWithAnnotation:annotation
                                                                 reuseIdentifier:invertGeoIdentifier];
        }
        
        poiAnnotationView.animatesDrop   = YES;
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.draggable      = YES;
        
        //show detail by right callout accessory view.
        poiAnnotationView.rightCalloutAccessoryView     = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        poiAnnotationView.rightCalloutAccessoryView.tag = RightCallOutTag;

        //call online navi by left accessory.
        poiAnnotationView.leftCalloutAccessoryView.tag  = LeftCallOutTag;
        
        return poiAnnotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState
{
    if (newState == MAAnnotationViewDragStateEnding)
    {
        _isSearchFromDragging = YES;
        
        CLLocationCoordinate2D coordinate = view.annotation.coordinate;
        self.annotation = view.annotation;
        
        [self searchReGeocodeWithCoordinate:coordinate];
    }
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil && _isSearchFromDragging == NO)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate
                                                                                         reGeocode:response.regeocode];
        
        [self.mapView addAnnotation:reGeocodeAnnotation];
        [self.mapView selectAnnotation:reGeocodeAnnotation animated:YES];
    }
    else /* from drag search, update address */
    {
        [self.annotation setAMapReGeocode:response.regeocode];
        [self.mapView selectAnnotation:self.annotation animated:YES];
    }
}

#pragma mark - Initialization

- (void)initToolBar
{
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    
    UILabel *prompts = [[UILabel alloc] init];
    prompts.text            = @"长按添加标注";
    prompts.textAlignment   = NSTextAlignmentCenter;
    prompts.backgroundColor = [UIColor clearColor];
    prompts.textColor       = [UIColor whiteColor];
    prompts.font            = [UIFont systemFontOfSize:20];
    [prompts sizeToFit];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:prompts];
    self.toolbarItems     = [NSArray arrayWithObjects:flexble, item, flexble, nil];
}

#pragma mark - action handle
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    
    [self initToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

@end
