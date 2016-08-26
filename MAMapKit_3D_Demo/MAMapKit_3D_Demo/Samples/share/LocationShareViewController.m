//
//  LocationShareViewController.m
//  officialDemo2D
//
//  Created by xiaoming han on 15/10/29.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "LocationShareViewController.h"

@implementation LocationShareViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.mapView.showsUserLocation = YES;
}

#pragma mark - 

- (void)shareAction
{
    if (self.mapView.userLocation.location == nil)
    {
        NSLog(@"尚未获取位置信息！");
        return;
    }
    
    AMapLocationShareSearchRequest *request = [[AMapLocationShareSearchRequest alloc] init];
    request.name = @"我的位置";
    request.location = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude];
    [self.search AMapLocationShareSearch:request];
}

@end
