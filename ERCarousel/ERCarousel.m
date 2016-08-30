//
//  ERCarousel.m
//  ERCarousel
//
//  Created by Erma on 16/8/29.
//  Copyright © 2016年 Erma. All rights reserved.
//

#import "ERCarousel.h"
#import "UIImageView+WebCache.h"

@interface ERCarousel () <UIScrollViewDelegate>

@property (nonatomic, assign) int           imageCount;         // 图片总数
@property (nonatomic, assign) int           currentImageIndex;  // 当前显示的图片

@property (nonatomic, strong) UIView        *Carousel;          //容器

@property (nonatomic, weak) UIScrollView    *scrollView;
@property (nonatomic, weak) UIPageControl   *pageControl;

@property (nonatomic, assign) CGRect        bounds;

@property (nonatomic, weak) UIImageView     *leftImage;
@property (nonatomic, weak) UIImageView     *rightImage;
@property (nonatomic, weak) UIImageView     *centerImage;

@property (nonatomic, strong) NSTimer       *timer;

@end

@implementation ERCarousel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [ERCarousel new];
 
    self.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    self.Carousel = [[UIView alloc] initWithFrame:frame];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.Carousel.bounds];
    self.scrollView = scrollView;
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.Carousel addSubview:self.scrollView];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.leftImage = leftImage;
    self.leftImage.contentMode=UIViewContentModeScaleToFill;
    self.leftImage.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.leftImage];
    
    UIImageView *centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
    self.centerImage = centerImage;
    self.centerImage.contentMode=UIViewContentModeScaleToFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCurrentImage)];
    self.centerImage.userInteractionEnabled = YES;
    [self.centerImage addGestureRecognizer:tap];
    [self.scrollView addSubview:self.centerImage];
    
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(2 * frame.size.width, 0, frame.size.width, frame.size.height)];
    self.rightImage = rightImage;
    self.rightImage.contentMode=UIViewContentModeScaleToFill;
    self.rightImage.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.rightImage];
    
    return self;
}

- (void)setImageDataArray:(NSArray *)imageDataArray
{
    
    _imageDataArray = imageDataArray;
    self.imageCount = (int)imageDataArray.count;
    
    CGRect frame = self.scrollView.frame;
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    self.scrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    self.pageControl = pageControl;
    CGSize size = [self.pageControl sizeForNumberOfPages:self.imageCount];
    self.pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    self.pageControl.center = CGPointMake(frame.size.width / 2, frame.size.height * 4 / 5);
    
    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    self.pageControl.numberOfPages = self.imageCount;
    [self.Carousel addSubview:self.pageControl];
    
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageDataArray[self.imageCount - 1]]] placeholderImage:nil];
    
    [self.centerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageDataArray[0]]] placeholderImage:nil];
    
    [self.rightImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageDataArray[1]]] placeholderImage:nil];
    
    self.rightImage.contentMode=UIViewContentModeScaleToFill;
    self.centerImage.contentMode=UIViewContentModeScaleToFill;
    self.leftImage.contentMode=UIViewContentModeScaleToFill;
    
    self.currentImageIndex = 0;
    
    self.pageControl.currentPage = self.currentImageIndex;
    
}

- (void)addSuperView:(UIView *)view
{
    [view addSubview:self.Carousel];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPic) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

#pragma mark - 交互事件
- (void)touchCurrentImage {
    [self.delegate touchClickImageIndex:self.currentImageIndex];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self refreshImage];
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    
    self.pageControl.currentPage=self.currentImageIndex;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPic) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

#pragma mark - 私有方法
- (void)refreshImage
{
    
    CGPoint offset=[self.scrollView contentOffset];
    if (offset.x>self.scrollView.frame.size.width) {
        
        self.currentImageIndex=(self.currentImageIndex+1) %self.imageCount;
    }else if(offset.x<self.scrollView.frame.size.width){
        
        self.currentImageIndex=(self.currentImageIndex+self.imageCount-1)%self.imageCount;
    }
    
    [self.centerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageDataArray[self.currentImageIndex]]] placeholderImage:nil];
    
    int leftImageIndex=(self.currentImageIndex+self.imageCount-1)%self.imageCount;
    int rightImageIndex=(self.currentImageIndex+1)%self.imageCount;
    
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageDataArray[leftImageIndex]]] placeholderImage:nil];
    
    [self.rightImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageDataArray[rightImageIndex]]] placeholderImage:nil];
    
}

- (void)nextPic
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width * 2, 0)];
        
    } completion:^(BOOL finished) {
        
        [self refreshImage];

        [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
        
        self.pageControl.currentPage=self.currentImageIndex;
    }];
}


@end
