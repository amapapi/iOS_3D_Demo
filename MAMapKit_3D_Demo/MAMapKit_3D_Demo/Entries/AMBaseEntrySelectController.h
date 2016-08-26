//
//  AMBaseEntrySelectController.h
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/9.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMBaseEntrySelectController : UIViewController

@property (nonatomic, strong) NSArray<NSString *> *entryTitles;
@property (nonatomic, strong) NSArray<NSString *> *entryDetails;
@property (nonatomic, strong) NSArray<NSString *> *entryClasses;

- (void)initEntries;

@end
