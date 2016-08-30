//
//  CooridinateSystemConvertController.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/30.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "CooridinateSystemConvertController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "UIView+Toast.h"

@interface CooridinateSystemConvertController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *otherCooridnateSystems;

@property (nonatomic, strong) UITextField *latitudeInput;
@property (nonatomic, strong) UITextField *longitudeInput;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIButton *convertButton;
@property (nonatomic, strong) UIPickerView *picker;

@end


@implementation CooridinateSystemConvertController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.otherCooridnateSystems = @[@"Baidu", @"MapBar", @"MapABC", @"SoSoMap", @"AliYun", @"Google", @"GPS"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    UITextField *tf_lat = [[UITextField alloc] initWithFrame:CGRectMake(15, 20, 200, 40)];
    tf_lat.borderStyle = UITextBorderStyleLine;
    tf_lat.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf_lat.text = @"39.911004";
    tf_lat.placeholder = @"纬度";
    
    UITextField *tf_lng = [[UITextField alloc] initWithFrame:CGRectMake(15, 70, 200, 40)];
    tf_lng.text = @"116.405880";
    tf_lng.borderStyle = UITextBorderStyleLine;
    tf_lng.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf_lng.placeholder = @"经度";
    
    
    [self.view addSubview:tf_lng];
    [self.view addSubview:tf_lat];
    self.latitudeInput = tf_lat;
    self.longitudeInput = tf_lng;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tf_lng.frame) + 30, 160, 30)];
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"选择坐标系" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.selectButton = button;
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.selectButton.frame) + 10, 160, 30)];
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"转换" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(convertAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button setEnabled:NO];
    self.convertButton = button;
    
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(button.frame) + 10, self.view.bounds.size.width - 30, 40)];
    resultLabel.textColor = [UIColor blackColor];
    [self.view addSubview:resultLabel];
    self.resultLabel = resultLabel;
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds) - 162, CGRectGetWidth(self.view.bounds), 162)];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [self.view addSubview:picker];
    self.picker = picker;
    [self.picker setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}



#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectAction
{
    [self.view endEditing:YES];
    [self.picker setHidden:NO];
}

- (void)convertAction
{
    [self.view endEditing:YES];
    
    CLLocationDegrees latitude = [self.latitudeInput.text doubleValue];
    CLLocationDegrees longitude = [self.longitudeInput.text doubleValue];
    if(!CLLocationCoordinate2DIsValid(CLLocationCoordinate2DMake(latitude, longitude)))
    {
        [self.view makeToast:@"无效的输入" duration:1.0];
        return;
    }
    
    NSString *fromSystem = [self.selectButton titleForState:UIControlStateNormal];
    AMapCoordinateType type = AMapCoordinateTypeGPS;
    //@[@"Baidu", @"MapBar", @"MapABC", @"SoSoMap", @"AliYun", @"Google", @"GPS"];
    if([fromSystem isEqualToString:@"Baidu"]) {
        type = AMapCoordinateTypeBaidu;
    } else if([fromSystem isEqualToString:@"MapBar"]) {
        type = AMapCoordinateTypeMapBar;
    } else if([fromSystem isEqualToString:@"MapABC"]) {
        type = AMapCoordinateTypeMapABC;
    } else if([fromSystem isEqualToString:@"SoSoMap"]) {
        type = AMapCoordinateTypeSoSoMap;
    } else if([fromSystem isEqualToString:@"AliYun"]) {
        type = AMapCoordinateTypeAliYun;
    } else if([fromSystem isEqualToString:@"Google"]) {
        type = AMapCoordinateTypeGoogle;
    } else if([fromSystem isEqualToString:@"GPS"]) {
        type = AMapCoordinateTypeGPS;
    }
    
    CLLocationCoordinate2D ret = AMapCoordinateConvert(CLLocationCoordinate2DMake(latitude, longitude), type);
    NSString *result = [NSString stringWithFormat:@"转换结果：{%.6f, %.6f}", ret.latitude, ret.longitude];
    self.resultLabel.text = result;
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.otherCooridnateSystems objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.selectButton setTitle:[self.otherCooridnateSystems objectAtIndex:row] forState:UIControlStateNormal];
    
    self.resultLabel.text = nil;
    [self.convertButton setEnabled:YES];
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.otherCooridnateSystems.count;
}

@end
