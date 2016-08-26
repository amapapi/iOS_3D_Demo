//
//  StereoOverlayRenderer.h
//  MAMapKit_Debug
//
//  Created by yi chen on 1/12/16.
//  Copyright © 2016 Autonavi. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CubeOverlay.h"

@interface CubeOverlayRenderer : MAOverlayRenderer

- (instancetype)initWithCubeOverlay:(CubeOverlay *)cubeOverlay;

@property (nonatomic, readonly) CubeOverlay *cubeOverlay;

@end
