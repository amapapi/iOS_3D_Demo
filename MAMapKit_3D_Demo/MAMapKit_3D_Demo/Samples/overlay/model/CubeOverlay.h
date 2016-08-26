//
//  StereoOverlay.h
//  MAMapKit_Debug
//
//  Created by yi chen on 1/12/16.
//  Copyright © 2016 Autonavi. All rights reserved.
//


#import <MAMapKit/MAMapKit.h>

@interface CubeOverlay : MAShape<MAOverlay>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly) MAMapRect boundingMapRect;

@property (nonatomic, readonly) CLLocationDistance lengthOfSide;

+ (instancetype)cubeOverlayWithCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                   lengthOfSide:(CLLocationDistance)lengthOfSide;

@end
