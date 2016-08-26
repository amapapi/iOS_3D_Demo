//
//  TileOverlayViewController.m
//  OfficialDemo3D
//
//  Created by Li Fei on 3/3/14.
//  Copyright (c) 2014 songjian. All rights reserved.
//

#import "TileOverlayViewController.h"

#import "LocalTileOverlay.h"

//#define kTileOverlayRemoteServerTemplate    @"http://mt1.google.cn/vt/x={x}&y={y}&z={z}&scale={scale}"

#define kTileOverlayRemoteServerTemplate @"http://cache1.arcgisonline.cn/arcgis/rest/services/ChinaCities_Community_BaseMap_ENG/BeiJing_Community_BaseMap_ENG/MapServer/tile/{z}/{y}/{x}"
#define kTileOverlayRemoteMinZ      4
#define kTileOverlayRemoteMaxZ      17

#define kTileOverlayLocalMinZ       11
#define kTileOverlayLocalMaxZ       13

@interface TileOverlayViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MATileOverlay *tileOverlay;

@property (nonatomic, assign) NSInteger currentType; // 0 local, 1 remote

@end

@implementation TileOverlayViewController

#pragma mark - Utility

- (MATileOverlay *)constructTileOverlayWithType:(NSInteger)type
{
    MATileOverlay *tileOverlay = nil;
    if (type == 0)
    {
        tileOverlay = [[LocalTileOverlay alloc] init];
        tileOverlay.minimumZ = kTileOverlayLocalMinZ;
        tileOverlay.maximumZ = kTileOverlayLocalMaxZ;
    }
    else // type == 1
    {
        tileOverlay = [[MATileOverlay alloc] initWithURLTemplate:kTileOverlayRemoteServerTemplate];
        
        /* minimumZ 是tileOverlay的可见最小Zoom值. */
        tileOverlay.minimumZ = kTileOverlayRemoteMinZ;
        /* minimumZ 是tileOverlay的可见最大Zoom值. */
        tileOverlay.maximumZ = kTileOverlayRemoteMaxZ;
        
        /* boundingMapRect 是用来 设定tileOverlay的可渲染区域. */
        tileOverlay.boundingMapRect = MAMapRectWorld;
    }
    
    return tileOverlay;
}

- (void)changeTileType:(NSInteger)type
{
    /* 删除之前的楼层. */
    [self.mapView removeOverlay:self.tileOverlay];
    
    /* 添加新的楼层. */
    self.tileOverlay = [self constructTileOverlayWithType:type];
    
    [self.mapView addOverlay:self.tileOverlay];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        MATileOverlayRenderer *renderer = [[MATileOverlayRenderer alloc] initWithTileOverlay:overlay];
        return renderer;
    }
    
    return nil;
}

#pragma mark - Handle Action

- (void)changeTypeAction:(UISegmentedControl *)segmentedControl
{
    self.currentType = segmentedControl.selectedSegmentIndex;
    [self changeTileType:self.currentType];
}

- (void)returnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - initialization

- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    
    UISegmentedControl *floorSegmentedControl = [[UISegmentedControl alloc] initWithItems:
                                                 [NSArray arrayWithObjects:
                                                  @"Local",
                                                  @"Remote",
                                                  nil]];
    floorSegmentedControl.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 100, 36);
    floorSegmentedControl.selectedSegmentIndex  = 0;
    floorSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [floorSegmentedControl addTarget:self action:@selector(changeTypeAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *floorItem = [[UIBarButtonItem alloc] initWithCustomView:floorSegmentedControl];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, floorItem, flexbleItem, nil];
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
    
    self.mapView.zoomLevel = kTileOverlayLocalMaxZ;
    [self.view addSubview:self.mapView];
    
    [self initToolBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self changeTileType:self.currentType];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

@end
