//
//  AMEntrySelect5Controller.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/11.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "AMEntrySelect5Controller.h"

@interface AMEntrySelect5Controller ()

@end

@implementation AMEntrySelect5Controller

- (void)initEntries {
    self.entryTitles = @[@"驾车",
                         @"公交",
                         @"步行",
                         @"公交(跨城)",
                         @"带实时路况的路径规划"];
    
    self.entryClasses = @[@"RoutePlanDriveViewController",
                          @"RoutePlanBusViewController",
                          @"RoutePlanWalkViewController",
                          @"RoutePlanBusCrossCityViewController",
                          @""];
    
    self.entryDetails = self.entryClasses;
}

@end
