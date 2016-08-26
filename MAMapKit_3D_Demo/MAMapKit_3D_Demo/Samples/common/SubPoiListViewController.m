//
//  SubPoiListViewController.m
//  officialDemo2D
//
//  Created by KuangYe on 15/12/17.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "PureLayout.h"
#import "SubPoiListViewController.h"
#import <AMapSearchKit/AMapCommonObj.h>
#import "SubPoiDetailViewController.h"

@interface SubPoiListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SubPoiListViewController

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
    AMapSubPOI *subPOI = self.subPois[indexPath.row];
    return subPOI.name;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    AMapSubPOI *subPOI = self.subPois[indexPath.row];
    return subPOI.address;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subPois.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"subPoi列表";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *subPoiList = @"subPoiList";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subPoiList];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:subPoiList];
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SubPoiDetailViewController *controller = [[SubPoiDetailViewController alloc] init];
    controller.subPoi = self.subPois[indexPath.row];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
