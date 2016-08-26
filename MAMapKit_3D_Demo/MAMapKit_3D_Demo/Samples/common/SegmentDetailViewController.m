//
//  SegmentViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "SegmentDetailViewController.h"
#import "WalkingDetailViewController.h"
#import "BusLineDetailViewController.h"
#import "RailwayDetailViewController.h"
#import "TaxiDetailViewController.h"

@interface SegmentDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SegmentDetailViewController
@synthesize segment = _segment;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0: title = @"步行导航信息"; break;
            case 1: title = @"打车导航信息"; break;
            case 2: title = @"入口名称";    break;
            case 3: title = @"入口经纬度";  break;
            case 4: title = @"出口名称";    break;
            default:title = @"出口经纬度";  break;
        }
    }
    else if (indexPath.section == 1)
    {
        AMapRailway *railway = self.segment.railway;
        if (railway.uid)
        {
            title = railway.name;
        }
    }
    else
    {
        AMapBusLine *busline = [self.segment.buslines objectAtIndex:indexPath.row];
        title = [NSString stringWithFormat:@"%@-->%@", busline.departureStop.name , busline.arrivalStop.name];
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *subTitle = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0: subTitle = nil; break;
            case 1: subTitle = nil; break;
            case 2: subTitle = self.segment.enterName;                   break;
            case 3: subTitle = [self.segment.enterLocation description]; break;
            case 4: subTitle = self.segment.exitName;                    break;
            default:subTitle = [self.segment.exitLocation description];  break;
        }
    }
    
    return subTitle;
}

- (void)gotoDetailForWalking:(AMapWalking *)walking
{
    WalkingDetailViewController *walkingDetailViewController = [[WalkingDetailViewController alloc] init];
    
    walkingDetailViewController.walking = walking;
    
    [self.navigationController pushViewController:walkingDetailViewController animated:YES];
}

- (void)gotoDetailForTaxi:(AMapTaxi *)taxi
{
    TaxiDetailViewController *detailViewController = [[TaxiDetailViewController alloc] init];
    
    detailViewController.taxi = taxi;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)gotoDetailForBusLine:(AMapBusLine *)busLine
{
    BusLineDetailViewController *busLineDetailViewController = [[BusLineDetailViewController alloc] init];
    
    busLineDetailViewController.busLine = busLine;
    
    [self.navigationController pushViewController:busLineDetailViewController animated:YES];
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
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self gotoDetailForWalking:self.segment.walking];
        }
        else if (indexPath.row == 1)
        {
            [self gotoDetailForTaxi:self.segment.taxi];
        }
    }
    else if (indexPath.section == 1)
    {
        [self gotoDetailForRailway:self.segment.railway];
    }
    else if (indexPath.section == 2)
    {
        [self gotoDetailForBusLine:[self.segment.buslines objectAtIndex:indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"" ;
    }
    else if (section == 1)
    {
        return @"铁路线路";
    }
    else
    {
        return @"公交线路换乘列表";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 6;
    }
    else if (section == 1)
    { // railway
        return self.segment.railway.uid ? 1 : 0;
    }
    else
    {
        return self.segment.buslines.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *segmentDetailCellIdentifier = @"segmentDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:segmentDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:segmentDetailCellIdentifier];
    }
    
    if ((indexPath.row <= 1 && indexPath.section == 0) || indexPath.section > 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Initialization

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
    
    [self initTitle:@"公交换乘路段 (AMapSegment)"];
    
    [self initTableView];
}

@end
