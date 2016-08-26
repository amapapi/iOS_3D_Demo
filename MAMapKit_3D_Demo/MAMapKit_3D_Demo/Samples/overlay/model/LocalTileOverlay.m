//
//  LocalTileOverlay.m
//  DevDemo2D
//
//  Created by xiaoming han on 15/1/13.
//  Copyright (c) 2015年 xiaoming han. All rights reserved.
//

#import "LocalTileOverlay.h"

#define kLocalTileBasePath  @"localtiles"

@implementation LocalTileOverlay

- (void)loadTileAtPath:(MATileOverlayPath)path result:(void (^)(NSData *tileData, NSError *error))result
{
    NSString *imagePath = [NSString stringWithFormat:@"%d/%d_%d_%d.png", @(path.z).intValue, @(path.z).intValue, @(path.x).intValue, @(path.y).intValue];
    
    NSString *tilesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kLocalTileBasePath];
    
    NSData *tileData = [NSData dataWithContentsOfFile:[tilesPath stringByAppendingPathComponent:imagePath]];
    
    NSError *error = nil;
    
    if (tileData == nil)
    {
        error = [NSError errorWithDomain:@"MATileLoadErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"load tile data error"}];
    }
    
    result(tileData, error);
}

@end
