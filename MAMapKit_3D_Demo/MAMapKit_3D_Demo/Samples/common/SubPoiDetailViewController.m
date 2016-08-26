//
//  SubPoiDetailViewController.m
//  officialDemo2D
//
//  Created by KuangYe on 15/12/17.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "SubPoiDetailViewController.h"
#import "PureLayout.h"

@interface SubPoiDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SubPoiDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0 : title = @"POI全局唯一ID";    break;
            case 1 : title = @"名称";            break;
            case 2 : title = @"名称缩写";       break;
            case 3 : title = @"经纬度";          break;
            case 4 : title = @"地址";            break;
            case 5 : title = @"距中心点距离";      break;
            case 6 : title = @"子POI类型";         break;
            default:break;
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
            case 0 : subTitle = self.subPoi.uid;                       break;
            case 1 : subTitle = self.subPoi.name;                      break;
            case 2 : subTitle = self.subPoi.sname;                      break;
            case 3 : subTitle = [self.subPoi.location description];    break;
            case 4 : subTitle = self.subPoi.address;                   break;
            case 5 : subTitle = [NSString stringWithFormat:@"%ld(米)", (long)self.subPoi.distance]; break;
            case 6 : subTitle = self.subPoi.subtype;
            default: break;
        }
    }
    return subTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"subPoi 具体信息";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *subPoiDetail = @"subPoiDetail";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subPoiDetail];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:subPoiDetail];
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



@end
