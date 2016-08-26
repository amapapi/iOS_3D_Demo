//
//  AMEntrySelect7Controller.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/12.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "AMEntrySelect7Controller.h"

@implementation AMEntrySelect7Controller

- (void)initEntries {
    self.entryTitles = @[@"位置分享",
                         @"路径规划分享",
                         @"POI分享",
                         @"导航分享"];
    
    self.entryClasses = @[@"LocationShareViewController",
                          @"RouteShareViewController",
                          @"POIShareViewController",
                          @"NaviShareViewController"];
    
    self.entryDetails = self.entryClasses;
}

@end
