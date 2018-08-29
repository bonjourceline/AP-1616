//
//  ADView.m
//  09-04UISrollViewRepeate
//
//  Created by 郝海圣 on 15/9/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ADView.h"
#import "MacDefine.h"

#define  WIDTH self.frame.size.width
#define  HEIGHT self.frame.size.height
@interface ADView()<UIScrollViewDelegate>
{
    NSInteger _currentPage;//记录当前的显示页

}
@property (nonatomic,copy) GoBackBlock goBlock;

@end
@implementation ADView

-(id)initWithArray:(NSArray *)array  andFrame:(CGRect)frame andBlock:(GoBackBlock)back{
    if (self = [super init]) {
        self.frame  = frame;
        NSMutableArray *ra = [NSMutableArray arrayWithArray:array];
        NSString *s0 = array[0];
        NSString *tailS = array[array.count - 1];
        [ra insertObject:tailS atIndex:0 ];
        [ra addObject:s0];
        self.imageArray = [NSArray arrayWithArray:ra];
        [self configUI];
        self.goBlock = back;
        

    }
    return self;
}

-(void)configUI{
    int _nIphoneVersion = 0,height =0;
    float sw = [[UIScreen mainScreen] bounds].size.width;
    float sh = [[UIScreen mainScreen] bounds].size.height;
    if (sw == 320.0f && sh == 568.0f)
    {
        _nIphoneVersion = 0;
    }
    else if (sw == 375.0f && sh == 667.0f)
    {
        _nIphoneVersion = 1;
    }
    else if (sw == 414.0f && sh == 736.0f)
    {
        _nIphoneVersion = 2;
    }
    else if (sw == 320.0f && sh == 480.0f)
    {
        _nIphoneVersion = 3;
    }
    
    UIScrollView *scr = [[UIScrollView alloc]initWithFrame:self.bounds];
    scr.backgroundColor = [UIColor yellowColor];
    //创建滚动视图的子视图
    NSArray *imageArray = self.imageArray;

    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*WIDTH, 0, WIDTH,HEIGHT )];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.userInteractionEnabled = YES;
        [scr addSubview:imageView];
        
//        if (i == imageArray.count-2) {
            int x;
            int y;
            int w;
            int h;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(30, 400, 90, 30);
            btn.center = self.center;
            x = btn.frame.origin.x;
            y = btn.frame.origin.y;
            w = btn.frame.size.width;
            h = btn.frame.size.height;
            switch (_nIphoneVersion)
            {
                case 0:
                    height = 215;
                    break;
                case 1:
                    height = 255;
                    break;
                case 2:
                    height = 285;
                    break;
                case 3:
                    height = 185;
                    break;
                default:
                    break;
            }
            btn.frame = CGRectMake(x, y+height, w, h);
            
            [btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
            [btn setTitle:@"跳过提示" forState:UIControlStateNormal];
            [btn setTitle:@"跳过提示" forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
            
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:2.0]; //设置矩形四个圆角半径
            [btn.layer setBorderWidth:1.0]; //边框宽度
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
            [btn.layer setBorderColor:colorref];//边框颜色
            [imageView addSubview:btn];
             
//        }
    }
    
    //设置内容视图的大小
    scr.contentSize = CGSizeMake(imageArray.count*WIDTH, HEIGHT);
    //用户看到的第一张
    scr.contentOffset = CGPointMake(WIDTH, 0);
    //设置回弹效果
    scr.bounces = NO;
    //设置代理
    scr.delegate = self;
    //翻页效果
    scr.pagingEnabled = YES;
    //设置水平的指示条
    scr.showsHorizontalScrollIndicator = NO;
    [self addSubview:scr];
    
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(250, 250, 100, 50 )];
    page.numberOfPages = imageArray.count -2;
    page.pageIndicatorTintColor  = [UIColor yellowColor];
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    _currentPage = 1;
    //设置页码指示器的页码
    page.currentPage = _currentPage-1;
    page.tag = 20;
//    [self addSubview:page];
}
-(void)go{
    if (!g_bSkipTips)
    {
        g_bSkipTips = TRUE;
        self.goBlock();
        [self removeFromSuperview];
    }
}
#pragma mark 协议方法
// 是否支持滑动至顶部
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

// 滑动到顶部时调用该方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScrollToTop");
}

// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //BOOL bScrollLeftOrRight = TRUE;
    
    CGPoint point = scrollView.contentOffset;
    NSLog(@"scrollViewDidScroll:%.f",point.x);
    
    if (_currentPage == 1)
    {
        self.scrollPoint = scrollView.contentOffset;
        if ((self.beginDraggPoint.x - self.scrollPoint.x) >= 0)
        {
            scrollView.contentOffset = CGPointMake(320, 0);
        }
    }
    
}

// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginDraggPoint = scrollView.contentOffset;
    NSLog(@"scrollViewWillBeginDragging:%.f",self.beginDraggPoint.x);
}

// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"scrollViewDidEndDragging:%.f",point.x);

}

// scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDecelerating");
}

//滑动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //图片的位置          1    2    3     4     5
    //图片的坐标          0    300  600   900   1200
    //图片的地址          2    0    1     2     0
    //_currentpage          0    1    2     3     4 记录的是真实的页码
    //页码指示器.currentPage       0    1     2
    //获取偏移量
    
    CGPoint point = scrollView.contentOffset;
    
    //当显示到最后一页时，让滑动图消失
    if (point.x == 4*WIDTH) {
        [self go];
        return;
    }
    
    if (point.x == 0) {
        scrollView.contentOffset = CGPointMake(WIDTH*(self.imageArray.count-2), 0);
        
    }
    if (point.x == WIDTH*(self.imageArray.count-1)) {
        scrollView.contentOffset = CGPointMake(WIDTH, 0);
    }
    //获得页码指示器
    UIPageControl *page = (UIPageControl *)[self viewWithTag:20];
    _currentPage = scrollView.contentOffset.x/WIDTH;
    NSLog(@"_currentPage %ld",_currentPage);
    page.currentPage = _currentPage-1;
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
