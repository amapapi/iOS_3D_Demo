//
//  PathDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "PathDetailViewController.h"
#import "StepDetailViewController.h"

@interface PathDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_baseInfoTitle;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PathDetailViewController
@synthesize tableView = _tableView;
@synthesize path = _path;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        title = _baseInfoTitle[indexPath.row];
    }
    else
    {
        AMapStep *step = self.path.steps[indexPath.row];
        
        title = step.instruction;
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
            case 0: subTitle = [NSString stringWithFormat:@"%ld(米)", (long)self.path.distance];    break;
            case 1: subTitle = [NSString stringWithFormat:@"%ld(秒)", (long)self.path.duration];    break;
            case 2: subTitle = self.path.strategy;                                           break;
            case 3: subTitle = [NSString stringWithFormat:@"%f(元)", self.path.tolls];        break;
            case 4: subTitle = [NSString stringWithFormat:@"%ld(米)", (long)self.path.tollDistance];        break;
            case 5: subTitle = [NSString stringWithFormat:@"%ld(个)", (long)self.path.totalTrafficLights];        break;
                
            default:subTitle = @""; break;
        }
    }
    else
    {
        subTitle = nil;
    }
    
    return subTitle;
}

- (void)gotoDetailForStep:(AMapStep *)step
{
    StepDetailViewController *stepDetailViewController = [[StepDetailViewController alloc] init];
    stepDetailViewController.step = step;
    
    [self.navigationController pushViewController:stepDetailViewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [self gotoDetailForStep:self.path.steps[indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return (section == 0) ? _baseInfoTitle.count : self.path.steps.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? @"基础信息" : @"导航路段";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pathDetailCellIdentifier = @"pathDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pathDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:pathDetailCellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
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
    
    [self initTitle:@"步行/驾车方案 (AMapPath)"];
    
    [self initTableView];
    
    _baseInfoTitle = @[@"起点和终点的距离", @"预计耗时", @"导航策略", @"费用", @"收费路段长度", @"交通信号灯数量"];

}

@end
