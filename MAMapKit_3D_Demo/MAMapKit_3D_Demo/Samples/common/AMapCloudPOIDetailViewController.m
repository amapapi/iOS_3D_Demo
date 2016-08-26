//
//  AMapCloudPOIDetailViewController.m
//  AMapCloudDemo
//
//  Created by 刘博 on 14-3-13.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "AMapCloudPOIDetailViewController.h"

@interface AMapCloudPOIDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AMapCloudPOIDetailViewController

@synthesize cloudPOI = _cloudPOI;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0 : title = @"POI ID(_id)";              break;
            case 1 : title = @"名称(_name)";               break;
            case 2 : title = @"经纬度(_location)";         break;
            case 3 : title = @"地址(_address)";            break;
            case 4 : title = @"创建时间(_createtime)";      break;
            case 5 : title = @"更新时间(_updatetime)";      break;
            case 6 : title = @"距center距离(_distance)";    break;
            default: break;
        }
    }
    else if (indexPath.section == 1)
    {
        title = @"";
    }
    else
    {
        title = [[self.cloudPOI.customFields allKeys] objectAtIndex:indexPath.row];
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
            case 0 : subTitle = [NSString stringWithFormat:@"%ld", self.cloudPOI.uid];break;
            case 1 : subTitle = self.cloudPOI.name;                                 break;
            case 2 : subTitle = [self.cloudPOI.location formattedDescription];      break;
            case 3 : subTitle = self.cloudPOI.address;                              break;
            case 4 : subTitle = [NSString stringWithFormat:@"%@", self.cloudPOI.createTime];break;
            case 5 : subTitle = [NSString stringWithFormat:@"%@", self.cloudPOI.updateTime];break;
            case 6 : subTitle = [NSString stringWithFormat:@"%ld(米)", self.cloudPOI.distance];break;
            default: break;
        }
    }
    else if (indexPath.section == 1)
    {
        AMapCloudImage *image =  [_cloudPOI.images objectAtIndex:indexPath.row];
        subTitle = image.preurl;
    }
    else
    {
        subTitle = [NSString stringWithFormat:@"%@",[self.cloudPOI.customFields valueForKey:[self titleForIndexPath:indexPath]]];
    }
    
    return subTitle;
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
        return 7;
    }
    if (section == 1)
    {
        return [_cloudPOI.images count];
    }
    return [[_cloudPOI customFields] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return  @"基本字段";
    }
    if (section == 1)
    {
        return @"图片信息";
    }
    return @"自定义字段";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *poiDetailCellIdentifier = @"cloudPOIDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:poiDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:poiDetailCellIdentifier];
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    cell.accessoryType          = UITableViewCellAccessoryNone;
    cell.selectionStyle         = UITableViewCellSelectionStyleNone;
    
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
    
    [self initTitle:@"AMapCloudPOI信息"];
    
    [self initTableView];
}

@end
