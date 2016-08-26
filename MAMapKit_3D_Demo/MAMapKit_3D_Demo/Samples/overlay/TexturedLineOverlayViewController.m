//
//  TexturedLineOverlayViewController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/17.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "TexturedLineOverlayViewController.h"

enum{
    OverlayViewControllerOverlayTypeCommonPolyline = 0,
    OverlayViewControllerOverlayTypeTexturePolyline,
    OverlayViewControllerOverlayTypeArrowPolyline,
    OverlayViewControllerOverlayTypeMultiTexPolyline,
};

@interface TexturedLineOverlayViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSMutableArray *overlaysAboveRoads;
@property (nonatomic, strong) NSMutableArray *overlaysAboveLabels;

@end

@implementation TexturedLineOverlayViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initOverlays];
    
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
    
    [self.mapView addOverlays:self.overlaysAboveLabels];
    [self.mapView addOverlays:self.overlaysAboveRoads level:MAOverlayLevelAboveRoads];
}

#pragma mark - Initialization

- (void)initOverlays
{
    self.overlaysAboveLabels = [NSMutableArray array];
    self.overlaysAboveRoads = [NSMutableArray array];
    
    /* Polyline. */
    CLLocationCoordinate2D commonPolylineCoords[5];
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.44095;
    
    commonPolylineCoords[4].latitude = 39.932136;
    commonPolylineCoords[4].longitude = 116.44095;
    
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:5];
    [self.overlaysAboveLabels insertObject:commonPolyline atIndex:OverlayViewControllerOverlayTypeCommonPolyline];
    
    /* Textured Polyline. */
    CLLocationCoordinate2D texPolylineCoords[3];
    texPolylineCoords[0].latitude = 39.932136;
    texPolylineCoords[0].longitude = 116.44095;
    
    texPolylineCoords[1].latitude = 39.932136;
    texPolylineCoords[1].longitude = 116.50095;
    
    texPolylineCoords[2].latitude = 39.952136;
    texPolylineCoords[2].longitude = 116.50095;
    
    MAPolyline *texPolyline = [MAPolyline polylineWithCoordinates:texPolylineCoords count:3];
    [self.overlaysAboveLabels insertObject:texPolyline atIndex:OverlayViewControllerOverlayTypeTexturePolyline];
    
    /* Arrow Polyline. */
    CLLocationCoordinate2D ArrowPolylineCoords[3];
    ArrowPolylineCoords[0].latitude = 39.793765;
    ArrowPolylineCoords[0].longitude = 116.294653;
    
    ArrowPolylineCoords[1].latitude = 39.831741;
    ArrowPolylineCoords[1].longitude = 116.294653;
    
    ArrowPolylineCoords[2].latitude = 39.832136;
    ArrowPolylineCoords[2].longitude = 116.34095;
    
    MAPolyline *arrowPolyline = [MAPolyline polylineWithCoordinates:ArrowPolylineCoords count:3];
    [self.overlaysAboveLabels insertObject:arrowPolyline atIndex:OverlayViewControllerOverlayTypeArrowPolyline];
    
    /* Multi-Texture Polyline. */
    CLLocationCoordinate2D mulTexPolylineCoords[5];
    mulTexPolylineCoords[0].latitude = 39.852136;
    mulTexPolylineCoords[0].longitude = 116.30095;
    
    mulTexPolylineCoords[1].latitude = 39.852136;
    mulTexPolylineCoords[1].longitude = 116.40095;
    
    mulTexPolylineCoords[2].latitude = 39.932136;
    mulTexPolylineCoords[2].longitude = 116.40095;
    
    mulTexPolylineCoords[3].latitude = 39.932136;
    mulTexPolylineCoords[3].longitude = 116.40095;
    
    mulTexPolylineCoords[4].latitude = 39.982136;
    mulTexPolylineCoords[4].longitude = 116.48095;
    
    MAMultiPolyline *multiTexturePolyline = [MAMultiPolyline polylineWithCoordinates:mulTexPolylineCoords count:5 drawStyleIndexes:@[@1, @2, @4]];
    [self.overlaysAboveLabels insertObject:multiTexturePolyline atIndex:OverlayViewControllerOverlayTypeMultiTexPolyline];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        if (overlay == self.overlaysAboveLabels[OverlayViewControllerOverlayTypeMultiTexPolyline])
        {
            MAMultiTexturePolylineRenderer * polylineRenderer = [[MAMultiTexturePolylineRenderer alloc] initWithMultiPolyline:overlay];
            polylineRenderer.lineWidth    = 18.f;
            
            UIImage * bad = [UIImage imageNamed:@"custtexture_bad"];
            UIImage * slow = [UIImage imageNamed:@"custtexture_slow"];
            UIImage * green = [UIImage imageNamed:@"custtexture_green"];
            
            BOOL succ = [polylineRenderer loadStrokeTextureImages:@[bad, slow, green]];
            if (!succ)
            {
                NSLog(@"loading texture image fail.");
            }
            return polylineRenderer;
            
        }
        else
        {
            MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
            
            polylineRenderer.lineWidth = 8.f;
            polylineRenderer.strokeColors = @[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor]];
            
            return polylineRenderer;
        }
        
    }
    else if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        if (overlay == self.overlaysAboveLabels[OverlayViewControllerOverlayTypeTexturePolyline])
        {
            polylineRenderer.lineWidth    = 8.f;
            [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];
            
        }
        else if(overlay == self.overlaysAboveLabels[OverlayViewControllerOverlayTypeArrowPolyline])
        {
            polylineRenderer.lineWidth    = 20.f;
            polylineRenderer.lineCapType  = kMALineCapArrow;
        }
        else
        {
            polylineRenderer.lineWidth    = 8.f;
            polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
            polylineRenderer.lineJoinType = kMALineJoinRound;
            polylineRenderer.lineCapType  = kMALineCapRound;
        }
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - Helpers
/*!
 @brief  生成多角星坐标
 @param coordinates 输出的多角星坐标数组指针。内存需在外申请，方法内不释放，多角星坐标结果输出。
 @param pointsCount 输出的多角星坐标数组元素个数。
 @param starCenter  多角星的中心点位置。
 */
- (void)generateStarPoints:(CLLocationCoordinate2D *)coordinates pointsCount:(NSUInteger)pointsCount atCenter:(CLLocationCoordinate2D)starCenter
{
#define STAR_RADIUS 0.05
#define PI 3.1415926
    NSUInteger starRaysCount = pointsCount / 2;
    for (int i =0; i<starRaysCount; i++)
    {
        float angle = 2.f*i/starRaysCount*PI;
        int index = 2 * i;
        coordinates[index].latitude = STAR_RADIUS* sin(angle) + starCenter.latitude;
        coordinates[index].longitude = STAR_RADIUS* cos(angle) + starCenter.longitude;
        
        index++;
        angle = angle + (float)1.f/starRaysCount*PI;
        coordinates[index].latitude = STAR_RADIUS/2.f* sin(angle) + starCenter.latitude;
        coordinates[index].longitude = STAR_RADIUS/2.f* cos(angle) + starCenter.longitude;
    }
    
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
