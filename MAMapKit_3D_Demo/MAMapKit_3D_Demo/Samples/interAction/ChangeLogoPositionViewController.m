//
//  ChangeLogoPositionViewController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/16.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "ChangeLogoPositionViewController.h"
#import "UIView+Toast.h"

@interface ChangeLogoPositionViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation ChangeLogoPositionViewController

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
    
    [self changeLogoPosition];
}

- (void)changeLogoPosition {
    CGPoint oldCenter = self.mapView.logoCenter;
    self.mapView.logoCenter = CGPointMake(self.mapView.bounds.size.width - oldCenter.x, oldCenter.y);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view makeToast:@"logo被移到右下角了" duration:1.5];
}
#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
