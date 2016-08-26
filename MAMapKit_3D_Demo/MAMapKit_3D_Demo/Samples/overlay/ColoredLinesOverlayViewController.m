//
//  ColoredLinesOverlayViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "ColoredLinesOverlayViewController.h"

@interface ColoredLinesOverlayViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSArray *lines;

@end

@implementation ColoredLinesOverlayViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLines];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.mapView addOverlays:self.lines];
}

#pragma mark - Initialization
- (void)initLines {
    NSMutableArray *arr = [NSMutableArray array];
    
    /* Colored Polyline. */
    CLLocationCoordinate2D coloredPolylineCoords[5];
    coloredPolylineCoords[0].latitude = 39.938698;
    coloredPolylineCoords[0].longitude = 116.275177;
    
    coloredPolylineCoords[1].latitude = 39.966069;
    coloredPolylineCoords[1].longitude = 116.289253;
    
    coloredPolylineCoords[2].latitude = 39.944226;
    coloredPolylineCoords[2].longitude = 116.306076;
    
    coloredPolylineCoords[3].latitude = 39.966069;
    coloredPolylineCoords[3].longitude = 116.322899;
    
    coloredPolylineCoords[4].latitude = 39.938698;
    coloredPolylineCoords[4].longitude = 116.336975;
    
    MAMultiPolyline *coloredPolyline = [MAMultiPolyline polylineWithCoordinates:coloredPolylineCoords count:5 drawStyleIndexes:@[@1, @3]];
    [arr addObject:coloredPolyline];
    
    /* Gradient Polyline. */
    CLLocationCoordinate2D gradientPolylineCoords[8];
    gradientPolylineCoords[0].latitude = 39.938698;
    gradientPolylineCoords[0].longitude = 116.351051;
    
    gradientPolylineCoords[1].latitude = 39.966069;
    gradientPolylineCoords[1].longitude = 116.366844;
    
    gradientPolylineCoords[2].latitude = 39.938698;
    gradientPolylineCoords[2].longitude = 116.381264;
    
    gradientPolylineCoords[3].latitude = 39.938698;
    gradientPolylineCoords[3].longitude = 116.395683;
    
    gradientPolylineCoords[4].latitude = 39.950067;
    gradientPolylineCoords[4].longitude = 116.395683;
    
    gradientPolylineCoords[5].latitude = 39.950437;
    gradientPolylineCoords[5].longitude = 116.423449;
    
    gradientPolylineCoords[6].latitude = 39.966069;
    gradientPolylineCoords[6].longitude = 116.423449;
    
    gradientPolylineCoords[7].latitude = 39.966069;
    gradientPolylineCoords[7].longitude = 116.395683;
    
    MAMultiPolyline *gradientPolyline = [MAMultiPolyline polylineWithCoordinates:gradientPolylineCoords count:8 drawStyleIndexes:@[@0, @2, @3, @7]];
    [arr addObject:gradientPolyline];
    
    self.lines = [NSArray arrayWithArray:arr];
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 10.f;
        
        NSInteger index = [self.lines indexOfObject:overlay];
        if (index == 0)
        {
            polylineRenderer.strokeColors = @[[UIColor blueColor], [UIColor whiteColor], [UIColor blackColor], [UIColor greenColor]];
            polylineRenderer.gradient = YES;
        }
        else
        {
            polylineRenderer.strokeColors = @[[UIColor redColor], [UIColor yellowColor], [UIColor greenColor]];
            polylineRenderer.gradient = NO;
        }
        
        return polylineRenderer;
    }
    
    return nil;
}

@end

