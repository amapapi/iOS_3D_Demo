//
//  AOIDetailViewController.m
//  officialDemo2D
//
//  Created by xiaoming han on 16/2/22.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "AOIDetailViewController.h"

@interface AOIDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_baseInfoTitle;
    NSArray *_baseInfoArray;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AOIDetailViewController

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    return _baseInfoTitle[indexPath.row];
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    return _baseInfoArray[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _baseInfoTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *roadDetailCellIdentifier = @"roadDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:roadDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:roadDetailCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    [self initTitle:@"兴趣区域 (AMapAOI)"];
    
    [self initTableView];
    
    _baseInfoTitle = @[@"ID", @"名称", @"位置", @"区域编码", @"面积"];
    _baseInfoArray = @[self.aoi.uid,
                       self.aoi.name,
                       [self.aoi.location description],
                       self.aoi.adcode,
                       [NSString stringWithFormat:@"%.2f平方米", self.aoi.area]];
}

@end
