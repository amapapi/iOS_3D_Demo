//
//  FaceOverlayRenderer.h
//  CustomOverlayViewDemo
//
//  Created by songjian on 13-3-12.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAOverlayPathRenderer.h>
#import "FaceOverlay.h"

@interface FaceOverlayRenderer : MAOverlayPathRenderer

- (instancetype)initWithFaceOverlay:(FaceOverlay *)faceOverlay;

@property (nonatomic, readonly) FaceOverlay *faceOverlay;

@end
