//
//  MAWeatherLiveView.h
//  officialDemo2D
//
//  Created by PC on 15/8/24.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MAWeatherLiveView : UIView

- (void)updateWeatherWithInfo:(AMapLocalWeatherLive *)liveInfo;

@end
