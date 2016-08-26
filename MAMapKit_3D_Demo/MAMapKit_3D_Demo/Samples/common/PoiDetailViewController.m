//
//  PoiDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "PoiDetailViewController.h"
#import "SubPoiListViewController.h"

@interface PoiDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PoiDetailViewController
@synthesize poi = _poi;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0 : title = @"POI全局唯一ID";    break;
            case 1 : title = @"名称";            break;
            case 2 : title = @"兴趣点类型";       break;
            case 3 : title = @"经纬度";          break;
            case 4 : title = @"地址";            break;
            case 5 : title = @"电话";            break;
            case 6 : title = @"距中心点距离";      break;
            case 7 : title = @"停车类型";         break;
            default:break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0   : title = @"邮编";            break;
            case 1   : title = @"网址";            break;
            case 2   : title = @"电子邮件";         break;
            case 3   : title = @"省(省编码)";       break;
            case 4   : title = @"市(市编码)";       break;
            case 5   : title = @"区域(区域编码)";    break;
            case 6   : title = @"地理格ID";         break;
            case 7   : title = @"入口经纬度";        break;
            case 8   : title = @"出口经纬度";        break;
            case 9   : title = @"方向";             break;
            case 10  : title = @"是否有室内地图";      break;
            case 11  : title = @"所属商圈";         break;
            case 12  : title = @"室内信息";         break;
            case 13 : title = @"子POI";           break;
            default  : break;
        }
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
            case 0 : subTitle = self.poi.uid;                       break;
            case 1 : subTitle = self.poi.name;                      break;
            case 2 : subTitle = self.poi.type;                      break;
            case 3 : subTitle = [self.poi.location description];    break;
            case 4 : subTitle = self.poi.address;                   break;
            case 5 : subTitle = self.poi.tel;                       break;
            case 6 : subTitle = [NSString stringWithFormat:@"%ld(米)", (long)self.poi.distance]; break;
            case 7 : subTitle = self.poi.parkingType; break;
            default: break;
                
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0  : subTitle = self.poi.postcode;             break;
            case 1  : subTitle = self.poi.website;              break;
            case 2  : subTitle = self.poi.email;                break;
            case 3  : subTitle = [NSString stringWithFormat:@"%@(%@)", self.poi.province, self.poi.pcode];                              break;
            case 4  : subTitle = [NSString stringWithFormat:@"%@(%@)", self.poi.city, self.poi.citycode];                             break;
            case 5  : subTitle = [NSString stringWithFormat:@"%@(%@)", self.poi.district, self.poi.adcode];                             break;
            case 6  : subTitle = self.poi.gridcode;            break;
            case 7  : subTitle = [self.poi.enterLocation description];   break;
            case 8  : subTitle = [self.poi.exitLocation description];    break;
            case 9 : subTitle = self.poi.direction;            break;
            case 10 : subTitle = [NSString stringWithFormat:@"%d", self.poi.hasIndoorMap];                                              break;
            case 11 : subTitle = self.poi.businessArea;         break;

            case 12 : subTitle = self.poi.indoorData == nil ? @"无" :[NSString stringWithFormat:@"第%ld层(%@)，父ID为%@", (long)self.poi.indoorData.floor, self.poi.indoorData.floorName, self.poi.indoorData.pid]; break;
            case 13 : subTitle = [NSString stringWithFormat:@"%ld个", self.poi.subPOIs.count]; break;
            default : break;
        }
    }
    
    return subTitle;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 8 : 14;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"基础POI信息" : @"扩展信息";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *poiDetailCellIdentifier = @"poiDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:poiDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:poiDetailCellIdentifier];
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([cell.textLabel.text isEqualToString:@"子POI"])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 13)
    {
        if (self.poi.subPOIs.count > 0)
        {
            SubPoiListViewController *controller = [[SubPoiListViewController alloc] init];
            controller.subPois = self.poi.subPOIs;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
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
    
    [self initTitle:@"POI信息 (AMapPOI)"];
    
    [self initTableView];
}

@end
