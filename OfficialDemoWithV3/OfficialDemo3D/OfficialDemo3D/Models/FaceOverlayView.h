//
//  FaceOverlayView.h
//  CustomOverlayViewDemo
//
//  Created by songjian on 13-3-12.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAOverlayPathView.h>
#import "FaceOverlay.h"

@interface FaceOverlayView : MAOverlayPathView

- (id)initWithFaceOverlay:(FaceOverlay *)faceOverlay;

@property (nonatomic, readonly) FaceOverlay *faceOverlay;

@end
