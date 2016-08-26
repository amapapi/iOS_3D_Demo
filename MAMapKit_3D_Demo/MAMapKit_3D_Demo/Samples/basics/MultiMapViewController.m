//
//  MultiMapViewController.m
//  OfficialDemo3D
//
//  Created by 翁乐 on 11/6/15.
//  Copyright © 2015 songjian. All rights reserved.
//

#import "MultiMapViewController.h"

@interface MultiMapViewController()<MAMapViewDelegate>
{
    MAMapView *_mapview1;
    MAMapView *_mapview2;
}

@end

@implementation MultiMapViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    _mapview1 = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2.0)];
    _mapview1.delegate = self;
    [self.view addSubview:_mapview1];
    
    [self createMapview2];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
}

- (void)dealloc
{
    _mapview1 = nil;
    _mapview2 = nil;
    NSLog(@"dealloc");
}

- (void)createMapview2
{
    _mapview2 = [[MAMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapview1.frame) + 10, self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_mapview1.frame) - 10)];
    _mapview2.delegate = self;
    
    [self.view addSubview:_mapview2];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _mapview1.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2.0);
    _mapview2.frame = CGRectMake(0, CGRectGetMaxY(_mapview1.frame) + 10, self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_mapview1.frame) - 10);
}

#pragma mark - action handling
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
