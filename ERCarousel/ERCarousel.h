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

@interface ERCarousel : UIViewController

@property (nonatomic, strong) NSArray *imageDataArray;

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

@end
