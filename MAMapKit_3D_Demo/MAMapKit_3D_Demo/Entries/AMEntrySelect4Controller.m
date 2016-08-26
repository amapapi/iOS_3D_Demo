//
//  AMEntrySelect4Controller.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/11.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "AMEntrySelect4Controller.h"

@interface AMEntrySelect4Controller ()

@end

@implementation AMEntrySelect4Controller

- (void)initEntries {
    self.entryTitles = @[@"根据关键字检索POI",
                         @"根据id检索POI",
                         @"检索指定位置周边的POI",
                         @"检索指定范围内的POI",
                         @"根据输入自动提示",
                         @"地理编码（地址转坐标）",
                         @"逆地理编码（坐标转地址）",
                         @"行政区划查询",
                         @"天气查询",
                         @"公交线路查询",
                         @"公交站点查询",
                         @"检索指定位置周边的POI(云图)",
                         @"根据id检索POI(云图)",
                         @"根据关键字检索某一地区POI(云图)",
                         @"检索指定范围内的POI(云图)"];
    
    self.entryClasses = @[@"PoiSearchPerKeywordController",
                          @"PoiSearchPerIdController",
                          @"PoiSearchNearByController",
                          @"PoiSearchWithInPolygonController",
                          @"TipViewController",
                          @"GeoViewController",
                          @"InvertGeoViewController",
                          @"DistrictViewController",
                          @"WeatherViewController",
                          @"BusLineViewController",
                          @"BusStopViewController",
                          @"CloudPOIAroundSearchViewController",
                          @"CloudPOIIDSearchViewController",
                          @"CloudPOILocalSearchViewController",
                          @"CloudPOIPolygonSearchViewController"];
    
    self.entryDetails = self.entryClasses;
}

@end
