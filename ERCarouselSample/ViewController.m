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
                       @"http://pic4.nipic.com/20091113/3747840_182620947109_2.jpg",
                       @"http://d.hiphotos.baidu.com/image/h%3D200/sign=5af1cfb2d954564efa65e33983df9cde/38dbb6fd5266d0161a816d89932bd40734fa35f2.jpg",
                       @"http://c.hiphotos.baidu.com/image/h%3D200/sign=6637bda737fa828bce239ae3cd1e41cd/0e2442a7d933c8950b4aa1d9d51373f08202005f.jpg",
                       @"http://e.hiphotos.baidu.com/image/h%3D200/sign=f9240945952397ddc9799f046983b216/dc54564e9258d1092fc29910d558ccbf6c814d6a.jpg"
                       ];
    
    self.carousel = [[ERCarousel alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200)];
    
    [self.carousel setPageControlCurrentIndicatorColor:[UIColor blueColor] withIndicatorColor:[UIColor greenColor]];
    [self.carousel setPageControlCenterPoint:CGPointMake(50, 50)];
    
    
//    [self.carousel setImageDataArray:array];
    self.carousel.spacingTime = 4;
    
    self.carousel.delegate = self;
    [self.carousel addSuperView:self.view];
    
    
    [self.carousel setImageDataArray:array];
    [self.carousel setImageDataArray:array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchClickImageIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
}

@end
