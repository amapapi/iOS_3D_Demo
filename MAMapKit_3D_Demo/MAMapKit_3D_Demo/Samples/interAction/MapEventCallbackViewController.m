//
//  MapEventCallbackViewController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/12.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "MapEventCallbackViewController.h"
#import "UIView+Toast.h"

@interface MapEventCallbackViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation MapEventCallbackViewController

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
    [self.view addSubview:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.mapView.delegate = self;
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Map Delegate
/**
 *  地图移动结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    [self.view makeToast:[NSString stringWithFormat:@"did moved, newCenter = {%f, %f}", self.mapView.centerCoordinate.latitude,
                          self.mapView.centerCoordinate.longitude]];
}

/**
 *  地图缩放结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    [self.view makeToast:[NSString stringWithFormat:@"new zoomLevel = %.2f", self.mapView.zoomLevel]];
}

/**
 *  单击地图底图调用此接口
 *
 *  @param mapView    地图View
 *  @param coordinate 点击位置经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.view makeToast:[NSString stringWithFormat:@"coordinate =  {%f, %f}", coordinate.latitude, coordinate.longitude]];
}

/**
 *  长按地图底图调用此接口
 *
 *  @param mapView    地图View
 *  @param coordinate 长按位置经纬度
 */
- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSString *msg = [NSString stringWithFormat:@"coordinate =  {%f, %f}", coordinate.latitude, coordinate.longitude];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
