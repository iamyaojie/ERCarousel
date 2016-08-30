//
//  ViewController.m
//  ERCarouselSample
//
//  Created by Erma on 16/8/30.
//  Copyright © 2016年 Erma. All rights reserved.
//

#import "ViewController.h"
#import "ERCarousel.h"

@interface ViewController ()<ERCarouselDelegate>

@property (nonatomic, strong) ERCarousel *carousel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *array = @[
                       @"http://scimg.jb51.net/allimg/160716/105-160G61F250436.jpg",
                       @"http://yinxing-product.oss-cn-beijing.aliyuncs.com/material/5d296cde226e4b63bb5cd1a137fd141c/lADOY3-46M0BXs0C7g_750_350.jpg",
                       @"http://yinxing-product.oss-cn-beijing.aliyuncs.com/material/5d296cde226e4b63bb5cd1a137fd141c/lADOauWBMM0BkM0C7g_750_400.jpg",
                       @"http://yinxing-product.oss-cn-beijing.aliyuncs.com/material/5d296cde226e4b63bb5cd1a137fd141c/lADOax7iWs0BkM0C7g_750_400.jpg"];
    
    self.carousel = [[ERCarousel alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200)];
    [self.carousel setImageDataArray:array];
    self.carousel.delegate = self;
    [self.carousel addSuperView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchClickImageIndex:(NSInteger)index {
    NSLog(@"%d",index);
}

@end
