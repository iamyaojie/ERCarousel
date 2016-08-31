//
//  ERCarousel.h
//  ERCarousel
//
//  Created by Erma on 16/8/29.
//  Copyright © 2016年 Erma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ERCarouselDelegate <NSObject>

- (void)touchClickImageIndex:(NSInteger)index;

@end

@interface ERCarousel : NSObject

@property (nonatomic, strong) NSArray *imageDataArray;
@property (nonatomic, assign) double spacingTime;
@property (nonatomic, weak)   id<ERCarouselDelegate> delegate;

/**
 *  创建轮播器
 *
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  传入image数组
 */
- (void)setImageDataArray:(NSArray *)imageDataArray;

/**
 *  添加轮播器到View上
 *
 */
- (void)addSuperView:(UIView *)view;

/**
 *  设置PageControl指示器的颜色 默认为黑白
 */
- (void)setPageControlCurrentIndicatorColor:(UIColor *)currentIndicatorColor withIndicatorColor:(UIColor *)indicatorColor;

/**
 *  设置PageControl中心点
 */
- (void)setPageControlCenterPoint:(CGPoint)centerPoint;

/**
 *  设置轮播图滚动间隔时间
 */
- (void)setSpacingTime:(double)spacingTime;

@end
