//
//  AMBaseEntrySelectController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/9.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "AMBaseEntrySelectController.h"

@interface AMBaseEntrySelectController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AMBaseEntrySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initEntries];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = self.entryClasses[indexPath.row];
    
    UIViewController *subViewController = [[NSClassFromString(className) alloc] init];
    subViewController.title = self.entryTitles[indexPath.row];
    
    [self.navigationController pushViewController:subViewController animated:YES];
}

#pragma mark - tableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entryTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mainCellIdentifier = @"com.autonavi.mainCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mainCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.numberOfLines = 0;
        
        cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    cell.textLabel.text = self.entryTitles[indexPath.row];
    
    cell.detailTextLabel.text = self.entryDetails[indexPath.row];
    
    return cell;
}

#pragma mark - 子类必须重载此方法，创建entryTitles， entryDetails, entryClasses
- (void)initEntries {
    
}

@end
