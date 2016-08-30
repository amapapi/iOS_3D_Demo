//
//  AMEntrySelect6Controller.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/12.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "AMEntrySelect6Controller.h"

@implementation AMEntrySelect6Controller

- (void)initEntries {
    self.entryTitles = @[@"其他坐标系转换为高德坐标系",
                         @"地理坐标与屏幕像素坐标相互转换",
                         @"两点间距离计算",
                         @"点与线的距离计算",
                         @"判断点是否在多边形内"];
    
    self.entryClasses = @[@"CooridinateSystemConvertController",
                          @"CoordinateConvertViewController",
                          @"DistanceCalculateViewController",
                          @"DistanceCalculateViewController2",
                          @"InsideTestViewController"];
    
    self.entryDetails = self.entryClasses;
}

@end
