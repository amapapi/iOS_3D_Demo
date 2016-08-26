//
//  RailwayStationDetailViewController.m
//  officialDemo2D
//
//  Created by xiaoming han on 16/8/1.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "RailwayStationDetailViewController.h"

@interface RailwayStationDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RailwayStationDetailViewController

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *busLineDetailCellIdentifier = @"railwayStationDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busLineDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:busLineDetailCellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    
    cell.textLabel.text         = self.titleArray[indexPath.row];
    cell.detailTextLabel.text   = self.subTitleArray[indexPath.row];
    
    return cell;
}

#pragma mark - Initialization

- (void)initTableData
{
    self.subTitleArray = @[[NSString stringWithFormat:@"%@", self.railwayStation.uid],
                           [NSString stringWithFormat:@"%@", self.railwayStation.name],
                           [NSString stringWithFormat:@"%@", self.railwayStation.location.description],
                           [NSString stringWithFormat:@"%@", self.railwayStation.adcode],
                           [NSString stringWithFormat:@"%@", self.railwayStation.time],
                           [NSString stringWithFormat:@"%ld 秒", (long)self.railwayStation.wait],
                           [NSString stringWithFormat:@"%d", self.railwayStation.isStart],
                           [NSString stringWithFormat:@"%d", self.railwayStation.isEnd],
                           ];
    
    self.titleArray = @[@"火车站id(uid)", @"名称(name)", @"经纬度(location)", @"区域编码(adcode)",
                        @"发车、到站时间(time)", @"停靠时间(wait)",
                        @"是否是始发站(isStart)", @"是否是终点站(isEnd)"];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)initTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor whiteColor];
    titleLabel.text             = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTitle:@"火车站 (AMapRailwayStation)"];
    
    [self initTableData];
    
    [self initTableView];
}

@end
