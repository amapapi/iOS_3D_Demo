//
//  CloudPOIAnnotation.h
//  AMapCloudDemo
//
//  Created by 刘博 on 14-3-13.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface CloudPOIAnnotation : NSObject<MAAnnotation>

- (id)initWithCloudPOI:(AMapCloudPOI *)cloudPOI;

@property (nonatomic, readonly, strong) AMapCloudPOI *cloudPOI;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*!
 @brief 获取annotation标题
 @return 返回annotation的标题信息
 */
- (NSString *)title;

/*!
 @brief 获取annotation副标题
 @return 返回annotation的副标题信息
 */
- (NSString *)subtitle;

@end
