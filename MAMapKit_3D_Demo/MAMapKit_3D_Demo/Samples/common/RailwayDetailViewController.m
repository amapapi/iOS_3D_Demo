//
//  RailwayDetailViewController.m
//  officialDemo2D
//
//  Created by xiaoming han on 16/7/29.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "RailwayDetailViewController.h"
#import "RailwayStationDetailViewController.h"

@interface RailwayDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RailwayDetailViewController

- (void)gotoDetailForStation:(AMapRailwayStation *)station
{
    RailwayStationDetailViewController *detailVC = [[RailwayStationDetailViewController alloc] init];
    detailVC.railwayStation = station;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)gotoDetailForRailway:(AMapRailway *)railway
{
    RailwayDetailViewController *detailViewController = [[RailwayDetailViewController alloc] init];
    detailViewController.railway = railway;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapRailwayStation *station = nil;
    AMapRailway *alterRailway = nil;
    if (indexPath.section == 0 && (indexPath.row == 6 || indexPath.row == 7))
    {
        if (indexPath.row == 6)
        {
            station = self.railway.departureStation;
        }
        else if (indexPath.row == 7)
        {
            station = self.railway.arrivalStation;
        }
    }
    else if(indexPath.section == 1)
    {
        station = self.railway.viaStops[indexPath.row];
    }
    else if(indexPath.section == 2)
    {
        alterRailway = self.railway.alters[indexPath.row];
    }
    
    if (station)
    {
        [self gotoDetailForStation:station];
    }
    else if (alterRailway)
    {
        [self gotoDetailForRailway:alterRailway];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.titleArray.count;
    }
    else if (section == 1) // 途经点
    {
        return self.railway.viaStops.count;
    }
    else if (section == 2) // 备选
    {
        return self.railway.alters.count;
    }
    else
    {
        return 0;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"基础信息";
    }
    else if (section == 1)
    {
        return @"途径站点信息";
    }
    else
    {
        return @"备选线路信息";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *busLineDetailCellIdentifier = @"railwayDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busLineDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:busLineDetailCellIdentifier];
    }
    
    if (indexPath.section == 1 || indexPath.section == 2 || (indexPath.section == 0 && (indexPath.row == 6 || indexPath.row == 7)))
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text         = nil;
    cell.detailTextLabel.text   = nil;
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text         = self.titleArray[indexPath.row];
        cell.detailTextLabel.text   = self.subTitleArray[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text         = self.railway.viaStops[indexPath.row].name;
    }
    else
    {
        cell.textLabel.text         = self.railway.alters[indexPath.row].name;
    }
    
    return cell;
}

#pragma mark - Initialization

- (void)initTableData
{
    self.subTitleArray = @[[NSString stringWithFormat:@"%@", self.railway.uid],
                           [NSString stringWithFormat:@"%@", self.railway.name],
                           [NSString stringWithFormat:@"%@", self.railway.trip],
                           [NSString stringWithFormat:@"%@", self.railway.type],
                           [NSString stringWithFormat:@"%ld 米", (long)self.railway.distance],
                           [NSString stringWithFormat:@"%ld 秒", (long)self.railway.time],
                           [NSString stringWithFormat:@"%@", self.railway.departureStation.name],
                           [NSString stringWithFormat:@"%@", self.railway.arrivalStation.name],
                           [NSString stringWithFormat:@"%@(%.1f)等%d种", self.railway.spaces.lastObject.code, @(self.railway.spaces.lastObject.cost).floatValue, @(self.railway.spaces.count).intValue],
                           ];
    
    self.titleArray = @[@"线路id(uid)", @"名称(name)", @"车次(trip)", @"类型(type)",
                        @"行车距离(distance)", @"耗时(time)",
                        @"出发站(departureStation)", @"到达站(arrivalStation)",
                        @"仓位信息(spaces)"];
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
    
    [self initTitle:@"铁路线路 (AMapRailway)"];
    
    [self initTableData];
    
    [self initTableView];
}

@end
