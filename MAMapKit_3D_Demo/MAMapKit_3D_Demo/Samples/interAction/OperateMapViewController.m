//
//  OperateMapViewController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/16.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "OperateMapViewController.h"

@interface OperateMapViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation OperateMapViewController

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
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.907728, 116.397968);
    [self.view addSubview:self.mapView];
    
    //使用手势不能改变camera的角度，但通过接口还是可以改变的
    self.mapView.rotateCameraEnabled = NO;
    
    UIView *switchsPannelView = [self makeSwitchsPannelView];
    switchsPannelView.center = CGPointMake( CGRectGetMidX(switchsPannelView.bounds) + 10,
                                        self.view.bounds.size.height -  CGRectGetMidY(switchsPannelView.bounds) - 20);
    
    switchsPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:switchsPannelView];
    
    
    UIView *zoomPannelView = [self makeMapDegreePannelView];
    zoomPannelView.center = CGPointMake(self.view.bounds.size.width -  CGRectGetMidX(zoomPannelView.bounds) - 10,
                                        self.view.bounds.size.height -  CGRectGetMidY(zoomPannelView.bounds) - 10);
    
    zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:zoomPannelView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UIView *)makeMapDegreePannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(cameraDegreePlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(cameraDegreeMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}


- (UIView *)makeSwitchsPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectZero];
    ret.backgroundColor = [UIColor whiteColor];
    
    
    UISwitch *swt1 = [[UISwitch alloc] init];
    UISwitch *swt2 = [[UISwitch alloc] init];
    UISwitch *swt3 = [[UISwitch alloc] init];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, CGRectGetHeight(swt1.bounds))];
    label1.text = @"drag:";
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame) + 5, 70, CGRectGetHeight(swt1.bounds))];
    label2.text = @"zoom:";
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame) + 5, 70, CGRectGetHeight(swt1.bounds))];
    label3.text = @"rotate:";
   
    [ret addSubview:label1];
    [ret addSubview:swt1];
    [ret addSubview:label2];
    [ret addSubview:swt2];
    [ret addSubview:label3];
    [ret addSubview:swt3];
    
    // layout
    CGRect tempFrame = swt1.frame;
    tempFrame.origin.x = CGRectGetMaxX(label1.frame) + 5;
    swt1.frame = tempFrame;
    
    tempFrame = swt2.frame;
    tempFrame.origin.x = CGRectGetMaxX(label2.frame) + 5;
    tempFrame.origin.y = CGRectGetMinY(label2.frame);
    swt2.frame = tempFrame;
    
    tempFrame = swt3.frame;
    tempFrame.origin.x = CGRectGetMaxX(label3.frame) + 5;
    tempFrame.origin.y = CGRectGetMinY(label3.frame);
    swt3.frame = tempFrame;
    
    
    //
    [swt1 addTarget:self action:@selector(enableDrag:) forControlEvents:UIControlEventValueChanged];
    [swt2 addTarget:self action:@selector(enableZoom:) forControlEvents:UIControlEventValueChanged];
    [swt3 addTarget:self action:@selector(enableRotate:) forControlEvents:UIControlEventValueChanged];
    
    [swt1 setOn:self.mapView.isScrollEnabled];
    [swt2 setOn:self.mapView.isZoomEnabled];
    [swt3 setOn:self.mapView.isRotateEnabled];
    
    ret.bounds = CGRectMake(0, 0, CGRectGetMaxX(swt3.frame), CGRectGetMaxY(label3.frame));
    
    return ret;
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enableDrag:(UISwitch *)sender
{
    self.mapView.scrollEnabled = sender.isOn;
}

- (void)enableZoom:(UISwitch *)sender
{
    self.mapView.zoomEnabled = sender.isOn;
}

- (void)enableRotate:(UISwitch *)sender
{
    self.mapView.rotateEnabled = sender.isOn;
}

- (void)cameraDegreePlusAction {
    self.mapView.cameraDegree += 5;
}

- (void)cameraDegreeMinusAction {
    self.mapView.cameraDegree -= 5;
}

@end
