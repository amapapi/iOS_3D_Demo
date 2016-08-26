//
//  TipDetailViewController.m
//  officialDemo2D
//
//  Created by PC on 15/8/25.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "TipDetailViewController.h"

@interface TipDetailViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation TipDetailViewController

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipIndentifier = @"tipIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipIndentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tipIndentifier];
    }
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.subTitleArray objectAtIndex:indexPath.row];
    
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

- (void)initTableData
{
    self.subTitleArray = @[self.tip.uid, self.tip.name,
                           self.tip.adcode, self.tip.district,
                           self.tip.address,
                           [NSString stringWithFormat:@"latitude:%f,longitude:%f",self.tip.location.latitude,self.tip.location.longitude]];
    
    self.titleArray = @[@"POI的id(uid)", @"名称(name)", @"区域编码(adcode)", @"所属区域(district)", @"地址(address)", @"位置(location)"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTitle:@"Tip信息 (AMapTip)"];
    
    [self initTableData];
    
    [self initTableView];
}

@end
