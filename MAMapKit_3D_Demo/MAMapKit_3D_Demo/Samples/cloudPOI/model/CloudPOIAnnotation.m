//
//  CloudPOIAnnotation.m
//  AMapCloudDemo
//
//  Created by 刘博 on 14-3-13.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "CloudPOIAnnotation.h"

@interface CloudPOIAnnotation ()

@property (nonatomic, readwrite, strong) AMapCloudPOI *cloudPOI;

@end

@implementation CloudPOIAnnotation

@synthesize cloudPOI = _cloudPOI;

#pragma mark - MAAnnotation Protocol

- (NSString *)title
{
    return [NSString stringWithFormat:@"ID:%ld %@", self.cloudPOI.uid, self.cloudPOI.name];
}

- (NSString *)subtitle
{
    return self.cloudPOI.address;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.cloudPOI.location.latitude, self.cloudPOI.location.longitude);
}

#pragma mark - Life Cycle

- (id)initWithCloudPOI:(AMapCloudPOI *)cloudPOI
{
    if (self = [super init])
    {
        self.cloudPOI = cloudPOI;
    }
    return self;
}

@end
