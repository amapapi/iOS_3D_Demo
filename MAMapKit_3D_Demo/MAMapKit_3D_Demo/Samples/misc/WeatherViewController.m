//
//  WeatherViewController.m
//  officialDemo2D
//
//  Created by PC on 15/8/21.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "WeatherViewController.h"
#import "PureLayout.h"
#import "MAWeatherLiveView.h"
#import "MAWeatherForecastView.h"


#define kHeightRatio 0.42
#define kWidthRatio  0.7
#define kTwoViewsMargin 5

@interface WeatherViewController() <AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) MAWeatherLiveView *weatherLiveView;
@property (nonatomic, strong) MAWeatherForecastView *weatherForecastView;
@property (nonatomic, strong) UIView *marginView;

@property (nonatomic, strong) NSMutableArray *layoutConstraintsPortrait;
@property (nonatomic, strong) NSMutableArray *layoutConstraintsLandsape;

@end


@implementation WeatherViewController


#pragma mark - AMapSearchDelegate

- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response
{
    if (request.type == AMapWeatherTypeLive)
    {
        if (response.lives.count == 0)
        {
            return;
        }
        
        AMapLocalWeatherLive *liveWeather = [response.lives firstObject];
        if (liveWeather != nil)
        {
            [self.weatherLiveView updateWeatherWithInfo:liveWeather];
        }
    }
    else
    {
        if (response.forecasts.count == 0)
        {
            return;
        }
        
        AMapLocalWeatherForecast *forecast = [response.forecasts firstObject];
        
        if (forecast != nil)
        {
            [self.weatherForecastView updateWeatherWithInfo:forecast];
        }
    }
}

#pragma mark - Utility

- (void)searchLiveWeather
{
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city                      = @"北京";
    request.type                      = AMapWeatherTypeLive;
    
    [self.search AMapWeatherSearch:request];
}

- (void)searchForecastWeather
{
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city                      = @"北京";
    request.type                      = AMapWeatherTypeForecast;
    
    [self.search AMapWeatherSearch:request];
}

#pragma mark - Initialization

- (void)initWeatherLiveView
{
    self.weatherLiveView = [[MAWeatherLiveView alloc] init];
    [self.weatherLiveView setBackgroundColor:[UIColor colorWithRed:84/255.0 green:142/255.0 blue:212/255.0 alpha:1]];
    [self.view addSubview:self.weatherLiveView];
}

- (void)initWeatherForecastView
{
    self.weatherForecastView = [[MAWeatherForecastView alloc] init];
    [self.weatherForecastView setBackgroundColor:[UIColor colorWithRed:84/255.0 green:142/255.0 blue:212/255.0 alpha:1]];
    [self.view addSubview:self.weatherForecastView];
}

- (void)initMarginView;
{
    self.marginView = [[UIView alloc] init];
    self.marginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.marginView];
}

- (void)initLayoutConstraints
{
    if (!self.layoutConstraintsLandsape)
    {
        self.layoutConstraintsLandsape = [NSMutableArray array];
        
        [self.layoutConstraintsLandsape addObject:[self.weatherLiveView autoPinEdgeToSuperviewEdge:ALEdgeTop]];
        [self.layoutConstraintsLandsape addObject:[self.weatherLiveView autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [self.layoutConstraintsLandsape addObject:[self.weatherLiveView autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
        
        [self.layoutConstraintsLandsape addObject:[self.marginView autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
        [self.layoutConstraintsLandsape addObject:[self.marginView autoPinEdgeToSuperviewEdge:ALEdgeTop]];
        [self.layoutConstraintsLandsape addObject:[self.marginView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.weatherLiveView]];
        [self.layoutConstraintsLandsape addObject:[self.marginView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.weatherForecastView]];
        [self.layoutConstraintsLandsape addObject:[self.marginView autoSetDimension:ALDimensionWidth toSize:kTwoViewsMargin]];
        
        [self.layoutConstraintsLandsape addObject:[self.weatherForecastView autoPinEdgeToSuperviewEdge:ALEdgeTop]];
        [self.layoutConstraintsLandsape addObject:[self.weatherForecastView autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
        [self.layoutConstraintsLandsape addObject:[self.weatherForecastView autoPinEdgeToSuperviewEdge:ALEdgeRight]];
        
        [self.layoutConstraintsLandsape addObject:[self.weatherForecastView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.weatherLiveView withMultiplier:kWidthRatio]];
    }
    
    [self.layoutConstraintsLandsape autoRemoveConstraints];
    
    if (!self.layoutConstraintsPortrait)
    {
        self.layoutConstraintsPortrait = [NSMutableArray array];
        [self.layoutConstraintsPortrait addObject:[self.weatherLiveView autoPinEdgeToSuperviewEdge:ALEdgeTop]];
        [self.layoutConstraintsPortrait addObject:[self.weatherLiveView autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [self.layoutConstraintsPortrait addObject:[self.weatherLiveView autoPinEdgeToSuperviewEdge:ALEdgeRight]];
        
        [self.layoutConstraintsPortrait addObject:[self.marginView autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [self.layoutConstraintsPortrait addObject:[self.marginView autoPinEdgeToSuperviewEdge:ALEdgeRight]];
        [self.layoutConstraintsPortrait addObject:[self.marginView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.weatherLiveView]];
        [self.layoutConstraintsPortrait addObject:[self.marginView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.weatherForecastView]];
        [self.layoutConstraintsPortrait addObject:[self.marginView autoSetDimension:ALDimensionHeight toSize:kTwoViewsMargin]];
        
        [self.layoutConstraintsPortrait addObject:[self.weatherForecastView autoPinEdgeToSuperviewEdge:ALEdgeRight]];
        [self.layoutConstraintsPortrait addObject:[self.weatherForecastView autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [self.layoutConstraintsPortrait addObject:[self.weatherForecastView autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
        
        [self.layoutConstraintsPortrait addObject:[self.weatherForecastView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.weatherLiveView withMultiplier:kHeightRatio]];
    }
}

#pragma mark - Life Cycle

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
        toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [self.layoutConstraintsLandsape autoRemoveConstraints];
        [self.layoutConstraintsPortrait autoInstallConstraints];
    }
    else
    {
        [self.layoutConstraintsPortrait autoRemoveConstraints];
        [self.layoutConstraintsLandsape autoInstallConstraints];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:84/255.0 green:142/255.0 blue:212/255.0 alpha:1]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    [self initWeatherLiveView];
    [self initWeatherForecastView];
    [self initMarginView];
    
    [self initLayoutConstraints];
    
    [self searchLiveWeather];
    [self searchForecastWeather];
}

#pragma mark - action handle

- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
