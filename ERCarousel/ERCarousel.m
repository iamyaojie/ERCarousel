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

@property (nonatomic, assign)   int             imageCount;             // 图片总数
@property (nonatomic, assign)   int             currentImageIndex;      // 当前显示的图片

@property (nonatomic, strong)   UIView          *Carousel;              //容器

@property (nonatomic, weak)     UIScrollView    *scrollView;
@property (nonatomic, weak)     UIPageControl   *pageControl;

@property (nonatomic, assign)   CGRect          bounds;

@property (nonatomic, weak)     UIImageView     *leftImage;
@property (nonatomic, weak)     UIImageView     *rightImage;
@property (nonatomic, weak)     UIImageView     *centerImage;

@property (nonatomic, strong)   NSTimer         *timer;

@end

@implementation ERCarousel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [ERCarousel new];

    self.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);

    self.Carousel = [[UIView alloc] initWithFrame:frame];

    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.leftImage.backgroundColor = [UIColor whiteColor];
    self.centerImage.backgroundColor = [UIColor whiteColor];
    self.rightImage.backgroundColor = [UIColor whiteColor];

    self.currentImageIndex = 0;
    self.pageControl.currentPage = self.currentImageIndex;
    
    return self;
}

- (void)setImageDataArray:(NSArray *)imageDataArray
{
    _imageDataArray = imageDataArray;

    self.imageCount = (int)imageDataArray.count;

    [self setImage:self.leftImage withURLString:[NSString stringWithFormat:@"%@",_imageDataArray[self.imageCount - 1]]];
    [self setImage:self.centerImage withURLString:[NSString stringWithFormat:@"%@",_imageDataArray[0]]];
    
    if (self.imageCount == 1)
    {
        [self setImage:self.rightImage withURLString:[NSString stringWithFormat:@"%@",_imageDataArray[0]]];
    }else
    {
        [self setImage:self.rightImage withURLString:[NSString stringWithFormat:@"%@",_imageDataArray[1]]];
    }

    self.pageControl.numberOfPages = self.imageCount;
}

- (void)addSuperView:(UIView *)view
{
    [view addSubview:self.Carousel];
    [self startTimer];
}

- (void)setPageControlCurrentIndicatorColor:(UIColor *)currentIndicatorColor withIndicatorColor:(UIColor *)indicatorColor
{
    self.pageControl.currentPageIndicatorTintColor = currentIndicatorColor;
    self.pageControl.pageIndicatorTintColor = indicatorColor;
}

- (void)setPageControlCenterPoint:(CGPoint)centerPoint
{
    self.pageControl.center = centerPoint;
}

- (void)setSpacingTime:(double)spacingTime
{
    _spacingTime = spacingTime;
    [self startTimer];
}

#pragma mark - 交互事件
- (void)touchCurrentImage
{
    [self.delegate touchClickImageIndex:self.currentImageIndex];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshImage];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:0.5];
}

#pragma mark - 私有方法
- (void)setImage:(UIImageView *)imageView withURLString:(NSString *)urlString
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
}

- (void)refreshImage
{
    CGPoint offset=[self.scrollView contentOffset];
    
    if (offset.x > self.bounds.size.width)
    {
        self.currentImageIndex = (self.currentImageIndex + 1) % self.imageCount;
        
    }else if(offset.x < self.bounds.size.width)
    {
        self.currentImageIndex = (self.currentImageIndex + self.imageCount - 1) % self.imageCount;
    }
    
    int leftImageIndex = (self.currentImageIndex + self.imageCount - 1) % self.imageCount;
    int rightImageIndex = (self.currentImageIndex + 1) % self.imageCount;

    [self setImage:self.centerImage withURLString:[NSString stringWithFormat:@"%@",self.imageDataArray[self.currentImageIndex]]];
    [self setImage:self.leftImage withURLString:[NSString stringWithFormat:@"%@",self.imageDataArray[leftImageIndex]]];
    [self setImage:self.rightImage withURLString:[NSString stringWithFormat:@"%@",self.imageDataArray[rightImageIndex]]];
    
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
    self.pageControl.currentPage=self.currentImageIndex;
    
}

- (void)nextPic
{
    [UIView animateWithDuration:0.5 animations:^
    {
        [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width * 2, 0)];
        
    } completion:^(BOOL finished)
    {
        [self refreshImage];
    }];
}

- (void)startTimer
{
    [self stopTimer];
    
    if (!self.spacingTime)
    {
        self.spacingTime = 3;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.spacingTime target:self selector:@selector(nextPic) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [self.timer invalidate];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView = scrollView;
        [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self.Carousel addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)leftImage
{
    if (_leftImage == nil)
    {
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _leftImage = leftImage;
        _leftImage.contentMode=UIViewContentModeScaleToFill;
        _leftImage.userInteractionEnabled = NO;
        [self.scrollView addSubview:_leftImage];
    }
    return _leftImage;
}

- (UIImageView *)centerImage
{
    if (_centerImage == nil)
    {
        UIImageView *centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        _centerImage = centerImage;
        _centerImage.contentMode=UIViewContentModeScaleToFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCurrentImage)];
        _centerImage.userInteractionEnabled = YES;
        [_centerImage addGestureRecognizer:tap];
        [self.scrollView addSubview:_centerImage];
    }
    return _centerImage;
}

- (UIImageView *)rightImage
{
    if (_rightImage == nil)
    {
        UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(2 * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        _rightImage = rightImage;
        _rightImage.contentMode=UIViewContentModeScaleToFill;
        _rightImage.userInteractionEnabled = NO;
        [self.scrollView addSubview:_rightImage];
    }
    return _rightImage;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil)
    {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        _pageControl = pageControl;
        _pageControl.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height * 9 / 10);
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self.Carousel addSubview:_pageControl];
    }
    return _pageControl;
}

@end
