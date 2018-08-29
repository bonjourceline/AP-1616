//
//  PopoverView.m
//  ArrowView
//
//  Created by guojiang on 4/9/14.
//  Copyright (c) 2014年 LINAICAI. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "PopoverView.h"


#define kArrowHeight 10.f
#define kArrowCurvature 6.f
#define SPACE 2.f
#define ROW_HEIGHT 35.f
#define TITLE_FONT [UIFont systemFontOfSize:14]
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

@interface PopoverView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic) CGPoint showPoint;

@property (nonatomic, strong) UIButton *handerView;
@property (nonatomic, strong) UIButton *originButton;

@end

@implementation PopoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.borderColor = RGB(200, 199, 204);
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images button:(UIButton *)button
{
    self = [super init];
    if (self) {
        
        self.showPoint = point;
        self.titleArray = titles;
        self.imageArray = images;
        
        self.originButton = button;
        self.frame = [self getViewFrame:button];
        
        
        //设置圆角
//        [self.tableView.layer setCornerRadius:5.0];
//        [self.tableView.layer setMasksToBounds:YES];
        
        [self addSubview:self.tableView];
        
    }
    return self;
}

-(CGRect)getViewFrame:(UIButton *)button
{
    CGRect frame = CGRectZero;
    
    frame.size.height = [self.titleArray count] * ROW_HEIGHT + SPACE + kArrowHeight;
    
    /*
    //标题自适应长度
    for (NSString *title in self.titleArray) {
        CGFloat width =  [title sizeWithFont:TITLE_FONT constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByCharWrapping].width;
        frame.size.width = MAX(width, frame.size.width);
    }
     
     if ([self.titleArray count] == [self.imageArray count]) {
     frame.size.width = 10 + 25 + 10 + frame.size.width + 20;
     }else{
     frame.size.width = 10 + frame.size.width + 20;
     }
     
     */
    
    //固定按钮长度
    frame.size.width = button.frame.size.width;
    
    frame.origin.x = self.showPoint.x - frame.size.width/2;
    frame.origin.y = self.showPoint.y;
    
    int nIphoneVersion;
    float sw = [[UIScreen mainScreen] bounds].size.width;
    float sh = [[UIScreen mainScreen] bounds].size.height;
    if (sw == 320.0f && sh == 568.0f)
    {
        nIphoneVersion = 0;
    }
    else if (sw == 375.0f && sh == 667.0f)
    {
        nIphoneVersion = 1;
    }
    else if (sw == 414.0f && sh == 736.0f)
    {
        nIphoneVersion = 2;
    }
    
//    //左间隔最小5x
//    if (frame.origin.x < 5) {
//        frame.origin.x = 5;
//    }
//    //右间隔最小5x
//    if ((frame.origin.x + frame.size.width) > 315) {
//        frame.origin.x = 315 - frame.size.width;
//    }
    
    return frame;
}


-(void)show
{
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:_handerView];
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, arrowPoint.y / self.frame.size.height);
    self.frame = [self getViewFrame:self.originButton];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

-(void)dismiss
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [_handerView removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
    }];
    
}


#pragma mark - UITableView

-(UITableView *)tableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    
    CGRect rect = self.frame;
    rect.origin.x = SPACE;
    rect.origin.y = kArrowHeight + SPACE;
    rect.size.width -= SPACE * 2;
    rect.size.height -= (SPACE - kArrowHeight);
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor grayColor];
//    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    return _tableView;
}

//设置分割线左对齐
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.backgroundColor = RGB(0, 0, 0);
    
//    cell.backgroundColor = [UIColor colorWithRed:118/255.0 green:203/255.0 blue:251/255.0 alpha:1];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1];
    cell.selectedBackgroundView = v;
    
    if ([_imageArray count] == [_titleArray count]) {
        cell.imageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.selectRowAtIndex) {
        self.selectRowAtIndex(indexPath.row);
    }
    [self dismiss:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.borderColor set]; //设置线条颜色
    
    CGRect frame = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height - kArrowHeight);
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
//    float xMax = CGRectGetMaxX(frame);
//    float yMax = CGRectGetMaxY(frame)[];
//    
//    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];//左上角
    
    
    /********************向上的箭头**********************/
//    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
//    [popoverPath addCurveToPoint:arrowPoint
//                   controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin)
//                   controlPoint2:arrowPoint];//actual arrow point
//    
//    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin)
//                   controlPoint1:arrowPoint
//                   controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
     /********************向上的箭头**********************/
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];//右上角
//    
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];//右下角
//    
//    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];//左下角
    
    
    
    /********************向下的箭头**********************/
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];//右上角
//    
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];//右下角
    
    
    
    /********************向下的箭头**********************/
//    [popoverPath addLineToPoint:CGPointMake(_showPoint.x + kArrowHeight, yMax)];//left side
//    [popoverPath addCurveToPoint:_showPoint
//                   controlPoint1:CGPointMake(_showPoint.x + kArrowHeight + kArrowCurvature, yMax)
//                   controlPoint2:arrowPoint];//actual arrow point
//
//    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin)
//                   controlPoint1:arrowPoint
//                   controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side

    
//    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];//左下角
    
    //填充颜色
    [RGB(245, 245, 245) setFill];
    [popoverPath fill];
    
    [popoverPath closePath];
    [popoverPath stroke];
}


@end
