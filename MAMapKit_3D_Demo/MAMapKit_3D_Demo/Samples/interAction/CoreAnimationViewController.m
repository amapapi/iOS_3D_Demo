//
//  CoreAnimationViewController.m
//  OfficialDemo3D
//
//  Created by songjian on 14-2-7.
//  Copyright (c) 2014年 songjian. All rights reserved.
//

#import "CoreAnimationViewController.h"

#define kMapCoreAnimationDuration 10.f

@interface CoreAnimationViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation CoreAnimationViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Fly"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(handleFlyAction)];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.907728, 116.397968);
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
}

#pragma mark - CoreAnimation Delegate

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"%s: keyPath = %@", __func__, ((CAPropertyAnimation *)anim).keyPath);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    /* flag 参数暂时无效. */
    
    NSLog(@"%s: keyPath = %@", __func__, ((CAPropertyAnimation *)anim).keyPath);
}

#pragma mark - CoreAnimation

/* 生成 地图中心点的 CAKeyframeAnimation. */
- (CAAnimation *)centerMapPointAnimation
{
    MAMapPoint fromMapPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(39.989870, 116.480940));
    MAMapPoint toMapPoint   = MAMapPointForCoordinate(CLLocationCoordinate2DMake(31.232992, 121.476773));
    
#define RATIO 100.f
    
    MAMapSize mapSize = MAMapSizeMake((toMapPoint.x - fromMapPoint.x) / RATIO, (toMapPoint.y - fromMapPoint.y) / RATIO);
    CAKeyframeAnimation *centerAnimation = [CAKeyframeAnimation animationWithKeyPath:kMAMapLayerCenterMapPointKey];
    
    centerAnimation.delegate = self;
    centerAnimation.duration = kMapCoreAnimationDuration;
    centerAnimation.values   = [NSArray arrayWithObjects:
                                [NSValue valueWithMAMapPoint:fromMapPoint],
                                [NSValue valueWithMAMapPoint:MAMapPointMake(fromMapPoint.x + mapSize.width, fromMapPoint.y + mapSize.height)],
                                [NSValue valueWithMAMapPoint:MAMapPointMake(toMapPoint.x - mapSize.width, toMapPoint.y - mapSize.height)],
                                [NSValue valueWithMAMapPoint:toMapPoint],
                                nil];
    centerAnimation.timingFunctions = [NSArray arrayWithObjects:
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       nil];
    centerAnimation.keyTimes = @[@(0.f), @(0.4f), @(0.6f), @(1.f)];
    
    return centerAnimation;
}

/* 生成 地图缩放级别的 CAKeyframeAnimation. */
- (CAAnimation *)zoomLevelAnimation
{
    CAKeyframeAnimation *zoomLevelAnimation = [CAKeyframeAnimation animationWithKeyPath:kMAMapLayerZoomLevelKey];
    
    zoomLevelAnimation.delegate = self;
    zoomLevelAnimation.duration = kMapCoreAnimationDuration;
    zoomLevelAnimation.values   = @[@(18), @(5), @(5), @(18)];
    zoomLevelAnimation.keyTimes = @[@(0.f), @(0.4f), @(0.6f), @(1.f)];
    zoomLevelAnimation.timingFunctions = [NSArray arrayWithObjects:
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                          nil];
    
    return zoomLevelAnimation;
}

/* 生成 地图摄像机俯视角度的 CABasicAnimation. */
- (CAAnimation *)cameraDegreeAnimation
{
    CABasicAnimation *cameraDegreeAnimation = [CABasicAnimation animationWithKeyPath:kMAMapLayerCameraDegreeKey];
    
    cameraDegreeAnimation.delegate  = self;
    cameraDegreeAnimation.duration  = kMapCoreAnimationDuration;
    cameraDegreeAnimation.fromValue = @(0.f);
    cameraDegreeAnimation.toValue   = @(45.f);
    
    return cameraDegreeAnimation;
}

/*生成 地图旋转角度的 CABasicAnimation. */
-(CAAnimation *)rotationDegreeKey
{
    CABasicAnimation *rotationDegreeAnimation =[CABasicAnimation animationWithKeyPath:kMAMapLayerRotationDegreeKey];
    rotationDegreeAnimation.delegate  = self;
    rotationDegreeAnimation.duration  = kMapCoreAnimationDuration;
    rotationDegreeAnimation.fromValue = @(0.f);
    rotationDegreeAnimation.toValue   = @(180.f);
    
    return rotationDegreeAnimation;
}

/* 执行动画. */
- (void)executeCoreAnimation
{
    /* 添加 中心点 动画. */
    [self.mapView.layer addAnimation:[self centerMapPointAnimation] forKey:kMAMapLayerCenterMapPointKey];
    
    /* 添加 缩放级别 动画. */
    [self.mapView.layer addAnimation:[self zoomLevelAnimation]      forKey:kMAMapLayerZoomLevelKey];
    
    /* 添加 摄像机俯视角度 动画. */
    [self.mapView.layer addAnimation:[self cameraDegreeAnimation]   forKey:kMAMapLayerCameraDegreeKey];
    
    /* 添加 地图旋转角度 动画. */
    [self.mapView.layer addAnimation:[self rotationDegreeKey]       forKey:kMAMapLayerRotationDegreeKey];
}

#pragma mark - Handle Action

- (void)handleFlyAction
{
    /* 执行动画. */
    [self executeCoreAnimation];
}

- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
