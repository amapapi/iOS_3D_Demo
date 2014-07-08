//
//  GestureAttributesViewController.m
//  Category_demo
//
//  Created by songjian on 13-3-21.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "GestureAttributesViewController.h"

enum{
    GestureAttributesViewControllerTagScroll = 0,
    GestureAttributesViewControllerTagZoom,
    GestureAttributesViewControllerTagRotate,
    GestureAttributesViewControllerTagCamera
};

#define ScrollTitle(enabled) ((enabled) ? (@"Scroll D") : (@"Scroll E"))
#define ZoomTitle(enabled)   ((enabled) ? (@"Zoom D")   : (@"Zoom E"))
#define RotateTitle(enabled) ((enabled) ? (@"Rotate D") : (@"Rotate E"))
#define CameraTitle(enabled) ((enabled) ? (@"Camera D") : (@"Camera E"))

@interface GestureAttributesViewController ()

@end

@implementation GestureAttributesViewController

#pragma mark - Action Handle

- (void)gestureAttributesAction:(UIBarButtonItem *)item
{
    switch (item.tag)
    {
        case GestureAttributesViewControllerTagScroll:
        {
            self.mapView.scrollEnabled = !self.mapView.scrollEnabled;
            
            item.title = ScrollTitle(self.mapView.scrollEnabled);
            
            break;
        }
        case GestureAttributesViewControllerTagZoom:
        {
            self.mapView.zoomEnabled = !self.mapView.zoomEnabled;
            
            item.title = ZoomTitle(self.mapView.zoomEnabled);
            
            break;
        }
        case GestureAttributesViewControllerTagRotate:
        {
            self.mapView.rotateEnabled = !self.mapView.rotateEnabled;
            
            item.title = RotateTitle(self.mapView.rotateEnabled);
            
            break;
        }
        default:
        {
            self.mapView.rotateCameraEnabled = !self.mapView.rotateCameraEnabled;
            
            item.title = CameraTitle(self.mapView.rotateCameraEnabled);
            
            break;
        }
    }
}

#pragma mark - Initialization

- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    
    UIBarButtonItem *scrollItem = [[UIBarButtonItem alloc] initWithTitle:ScrollTitle(YES)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(gestureAttributesAction:)];
    scrollItem.tag = GestureAttributesViewControllerTagScroll;
    
    UIBarButtonItem *zoomItem = [[UIBarButtonItem alloc] initWithTitle:ZoomTitle(YES)
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(gestureAttributesAction:)];
    zoomItem.tag = GestureAttributesViewControllerTagZoom;
    
    UIBarButtonItem *rotateItem = [[UIBarButtonItem alloc] initWithTitle:RotateTitle(YES)
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(gestureAttributesAction:)];
    rotateItem.tag = GestureAttributesViewControllerTagRotate;
    
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithTitle:CameraTitle(YES)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(gestureAttributesAction:)];
    cameraItem.tag = GestureAttributesViewControllerTagCamera;
    
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, scrollItem, flexbleItem, zoomItem, flexbleItem, rotateItem, flexbleItem, cameraItem, flexbleItem, nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /* Reset gesture attributes. */
    self.mapView.scrollEnabled       = YES;
    self.mapView.zoomEnabled         = YES;
    self.mapView.rotateEnabled       = YES;
    self.mapView.rotateCameraEnabled = YES;
}

@end
