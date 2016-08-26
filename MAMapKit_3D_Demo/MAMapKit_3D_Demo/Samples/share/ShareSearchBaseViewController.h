//
//  ShareSearchBaseViewController.h
//  officialDemo2D
//
//  Created by xiaoming han on 15/10/29.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//


@interface ShareSearchBaseViewController : UIViewController<MAMapViewDelegate ,AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

/// 子类重写实现自己的逻辑。
- (void)shareAction;

@end
