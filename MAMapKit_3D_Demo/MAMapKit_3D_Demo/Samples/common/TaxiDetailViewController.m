//
//  TaxiDetailViewController.m
//  officialDemo2D
//
//  Created by xiaoming han on 16/8/8.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "TaxiDetailViewController.h"

@interface TaxiDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TaxiDetailViewController

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
    static NSString *busLineDetailCellIdentifier = @"taxiStationDetailCellIdentifier";
    
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
    self.subTitleArray = @[[NSString stringWithFormat:@"%@", self.taxi.origin],
                           [NSString stringWithFormat:@"%@", self.taxi.destination],
                           [NSString stringWithFormat:@"%ld 米", (long)self.taxi.distance],
                           [NSString stringWithFormat:@"%ld 秒", (long)self.taxi.duration],
                           [NSString stringWithFormat:@"%@", self.taxi.sname],
                           [NSString stringWithFormat:@"%@", self.taxi.tname]
                           ];
    
    self.titleArray = @[@"起点坐标(origin)", @"终点坐标(destination)", @"距离(distance)", @"耗时(duration)", @"起点名称(sname)", @"终点名称(tname)"];
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
    
    [self initTitle:@"打车导航信息 (AMapTaxi)"];
    [self initTableData];
    [self initTableView];
}

@end
