//
//  OpenURLOnlineNavigationViewController.m
//  OfficialDemo3D
//
//  Created by 刘博 on 14-2-20.
//  Copyright (c) 2014年 songjian. All rights reserved.
//

#import "OpenURLOnlineNavigationViewController.h"

/* 高德地图注册scheme:iosamap */
#define AMAPScheme @"iosamap://"

/* 高德地图URL调用方法及参数参照 http://api.amap.com/uri/uriios */
#define NavigationURL   @"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=&poiid=&lat=36.547901&lon=104.258354&dev=1&style=2"


@implementation OpenURLOnlineNavigationViewController

#pragma mark - Handle URL Scheme

- (void)openAMAPURL
{
    if ([self canOpenAMAPScheme])
    {
        NSString *appName   = [self getApplicationName];
        NSString *scheme    = [self getApplicationScheme];
        NSString *naviURL   = [NSString stringWithFormat:NavigationURL,appName,scheme];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:naviURL]];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您未安装\"高德地图\"App"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)canOpenAMAPScheme
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:AMAPScheme]];
}

- (NSString *)getApplicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"];
}

- (NSString *)getApplicationScheme
{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    
    NSString *scheme;
    for (NSDictionary *dic in URLTypes)
    {
        NSString *URLName = [dic valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:bundleIdentifier])
        {
            scheme = [[dic valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            break;
        }
    }
    
    return scheme;
}

#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleView *accuracyCircleView = [[MACircleView alloc] initWithCircle:overlay];
        
        accuracyCircleView.lineWidth   = 2.f;
        accuracyCircleView.strokeColor = [UIColor lightGrayColor];
        accuracyCircleView.fillColor   = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return accuracyCircleView;
    }
    
    return nil;
}

#pragma mark - Override

- (void)returnAction
{
    [super returnAction];
    
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
    
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
}

#pragma mark - Initialization

- (void)initToolBar
{
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    
    UIBarButtonItem *navigationItem = [[UIBarButtonItem alloc] initWithTitle:@"调用\"高德地图\"App在线导航"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(openAMAPURL)];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexble, navigationItem, flexble, nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

@end
