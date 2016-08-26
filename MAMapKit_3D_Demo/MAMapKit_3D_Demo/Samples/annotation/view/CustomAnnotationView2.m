//
//  CustomAnnotationView2.m
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/12.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import "CustomAnnotationView2.h"
#import "UIView+Toast.h"

#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

@interface CustomAnnotationView2 ()

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;

@end

@implementation CustomAnnotationView2


#pragma mark - Handle Action

- (void)btnAction:(UIButton *)sender
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    NSString *str = [NSString stringWithFormat:@"%@, {%f,%f}", sender.currentTitle, coorinate.latitude, coorinate.longitude];
    [[UIApplication sharedApplication].keyWindow makeToast:str];
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 150, 120);
        
        self.backgroundColor = [UIColor grayColor];
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 110, 40)];
        [btn1 setTitle:@"btn1" forState:UIControlStateNormal];
        [btn1 setBackgroundColor:[UIColor redColor]];
        [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, 60, 40)];
        [btn2 setTitle:@"btn2" forState:UIControlStateNormal];
        [btn2 setBackgroundColor:[UIColor greenColor]];
        [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(80,60,50,40)];
        [btn3 setTitle:@"btn3" forState:UIControlStateNormal];
        [btn3 setBackgroundColor:[UIColor blueColor]];
        [btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn1];
        [self addSubview:btn2];
        [self addSubview:btn3];
    }
    
    return self;
}

@end
