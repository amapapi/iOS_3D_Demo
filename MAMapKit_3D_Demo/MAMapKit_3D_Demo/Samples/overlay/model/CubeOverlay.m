//
//  StereoOverlay.m
//  MAMapKit_Debug
//
//  Created by yi chen on 1/12/16.
//  Copyright © 2016 Autonavi. All rights reserved.
//

#import "CubeOverlay.h"

@interface CubeOverlay()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, readwrite) CLLocationDistance lengthOfSide;

@property (nonatomic, readwrite) MAMapRect boundingMapRect;

@end


@implementation CubeOverlay

@synthesize coordinate          = _coordinate;
@synthesize boundingMapRect     = _boundingMapRect;

- (void)constructBoundingMapRect
{
    MAMapPoint centerPoint = MAMapPointForCoordinate(self.coordinate);
    double lengthInMapPoint = self.lengthOfSide * MAMapPointsPerMeterAtLatitude(self.coordinate.latitude);
    self.boundingMapRect = MAMapRectMake(centerPoint.x - lengthInMapPoint * 0.5, centerPoint.y - lengthInMapPoint * 0.5, lengthInMapPoint, lengthInMapPoint);
}

+ (instancetype)cubeOverlayWithCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                   lengthOfSide:(CLLocationDistance)lengthOfSide
{
    return [[self alloc] initWithCenterCoordinate:centerCoordinate lengthOfSide:lengthOfSide];
}

- (instancetype)initWithCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                            lengthOfSide:(CLLocationDistance)lengthOfSide
{
    if (self = [super init])
    {
        self.coordinate = centerCoordinate;
        self.lengthOfSide = lengthOfSide;
        
        [self constructBoundingMapRect];
    }
    return self;
}

@end
