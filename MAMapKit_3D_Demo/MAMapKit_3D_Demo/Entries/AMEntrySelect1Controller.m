//
//  AMEntrySelect1Controller.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/9.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "AMEntrySelect1Controller.h"

@interface AMEntrySelect1Controller ()

@end

@implementation AMEntrySelect1Controller

- (void)initEntries {
    self.entryTitles = @[@"演示地图的不同类型展示，标准、卫星",
                         @"在一个view上添加多个地图实例",
                         @"在地图上显示实时路况"];
    
    self.entryClasses = @[@"MapTypeViewController",
                          @"MultiMapViewController",
                          @"TrafficViewController"];
    
    self.entryDetails = self.entryClasses;
}

@end
