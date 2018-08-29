//
//  DelaySettingFour.m
//  NetTuning
//
//  Created by chsdsp on 16/9/6.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "DelaySettingTwo.h"
#import <math.h>
#import "AppDelegate.h"

#define radiansToDegrees(x) (180.0 * x / M_PI)
#define ArcColor (0xFF00d2ff)


/** Helper Functions **/
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

#define kLineWidth 2


@implementation DelaySettingTwo

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        WIND_Width  = frame.size.width;
        WIND_Height = frame.size.height;
        WIND_CenterX = WIND_Width/2;
        WIND_CenterY = WIND_Height/2;
        WIND_MIN = MIN(WIND_Width, WIND_Height);
        WIND_MRidius = WIND_MIN/2;
        [self setup];
    }
    return self;
}


- (void)setup{
    self.backgroundColor = [UIColor clearColor];

    LPDrawable1W = 0;
    LPDrawable1H= 0;
    LPDrawable2W = 0;
    LPDrawable2H= 0;
    LPDrawable3W = 0;
    LPDrawable3H= 0;
    LPDrawable4W = 0;
    LPDrawable4H= 0;

    mThumbHeight = 0;
    mThumbWidth = 0;
    for (int i=0; i<4; i++) {
        mThumbNormal[i] = i;
        mThumbPressed[i] = i;
    }
    mThumbTX = 0;
    mThumbTY = 0;

    mThumbLeftOld = 0;
    mThumbTopOld = 0;

    mThumbDrawX = 0;
    mThumbDrawY = 0;


    arc_color = 0;
    startarc=1;
    rd1 = 0;
    rd2 = 0;
    rd3 = 0;
    rd4 = 0;

    xtap=0;
    ytap=0;
    rtap=0;
    
    for(int i=0;i<4;i++)
    {
        progress[i] = 0;
        rr[i] = 0;
    }
    
    //RectF
    RectF_Point1 = CGPointMake(0, 0);
    RectF_Point2 = CGPointMake(0, 0);
    RectF_Point3 = CGPointMake(0, 0);
    RectF_Point4 = CGPointMake(0, 0);
    
    ;
    point1X = self.frame.origin.x;
    point1Y = WIND_Height/2;
    point2X = CGRectGetMaxX(self.frame);
    point2Y = WIND_Height/2;
    point3X = self.frame.origin.x;
    point3Y = CGRectGetMaxY(self.frame);
    point4X = CGRectGetMaxX(self.frame);
    point4Y = CGRectGetMaxY(self.frame);

    arc_width = 0;
    
    mThumbTX = 60;
    mThumbTY = 60;
    mThumbWidth = 60;
    arc_angle = 10;
    arc_interval = 15;
    _rectThumb = CGRectMake(mThumbTX, mThumbTY, mThumbWidth, mThumbWidth);
}
#pragma mark -Draw UI
/**/
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 1.上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawARCPoint1:ctx withRect:rect];
    [self drawARCPoint2:ctx withRect:rect];
    [self drawThumb:ctx];
    
    [self countDelayTime];
}

#pragma mark - UIControl Override -
/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    //记下起点
    //CGPoint lastPoint = [touch locationInView:self];
    //NSLog(@"beginTrackingWithTouch AngleStart=@%f",AngleStart);
    return YES;
}
/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    //Use the location to design the Handle
    [self movehandle:lastPoint];
    //Control value has changed, let's notify that
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}
/** Move the Handle **/
-(void)movehandle:(CGPoint)lastPoint{
    [self MoveEventDeal:lastPoint];
    //Redraw
    [self setNeedsDisplay];
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
}

#pragma mark Other
- (void)MoveEventDeal:(CGPoint)lastPoint{
    
    mThumbTX = lastPoint.x;
    mThumbTY = lastPoint.y;
    
    if(mThumbTY > WIND_CenterY){
        mThumbTY = WIND_CenterY;
    }
    //Thumb大小
    float thumbW = _rectThumb.size.width*0.5;
    float thumbH = _rectThumb.size.height*0.5;
    
    //边界处理
    //左右
    if(mThumbTX<thumbW){
        mThumbTX=thumbW;
    }else if(mThumbTX>(WIND_Width-thumbW)){
        mThumbTX=WIND_Width-thumbW;
    }
    
    //上下
    if(mThumbTY<0){
        mThumbTY=0;
    }else if(mThumbTY>(WIND_Height-thumbH)){
        mThumbTY=WIND_Height-thumbH;
    }
    
}


-(float)GetDegreeCenterX:(float)centX withCenterY:(float)centY withX:(float)x withY:(float)y
{
    float Degree=0;
    double radian = atan2(y - centY, x - centX);
    if (radian < 0){
        radian = radian + 2*M_PI;
    }
    Degree = round(radiansToDegrees(radian));
    return Degree;
}

-(void)drawARCPoint1:(CGContextRef)ctx withRect:(CGRect)rect
{
    CGContextSetLineWidth(ctx, kLineWidth);
    [SetColor(ArcColor) set];
    
    rd1 = (float)sqrt(mThumbTX*mThumbTX+(WIND_CenterY-mThumbTY)*(WIND_CenterY-mThumbTY))-mThumbWidth/2;
    int n = (int) (rd1/arc_interval);
    int startAngle=(int)[self GetDegreeCenterX:point1X withCenterY:point1Y withX:mThumbTX withY:mThumbTY];
    for(int i=startarc;i <= n;i++){
        if(i>12){
            break;
        }
        rd1 = arc_interval*i;
        CGContextAddArc(ctx, point1X, point1Y, rd1, ToRad(startAngle+arc_angle), ToRad(startAngle-arc_angle), 1);
        CGContextStrokePath(ctx);
    }
    
    double x=mThumbTX/xtap;
    double y=(WIND_CenterY-mThumbTY)/ytap;
    rr[0]=(double) x;
    rr[2]=(double) y;
}

-(void)drawARCPoint2:(CGContextRef)ctx withRect:(CGRect)rect
{
    CGContextSetLineWidth(ctx, kLineWidth);
    [SetColor(ArcColor) set];
    
    rd2 = (float)sqrt((point2X-mThumbTX)*(point2X-mThumbTX)+(WIND_CenterY-mThumbTY)*(WIND_CenterY-mThumbTY))-mThumbWidth/2;
    int n = (int) (rd2/arc_interval);
    int startAngle=(int)[self GetDegreeCenterX:point2X withCenterY:point2Y withX:mThumbTX withY:mThumbTY];
    for(int i=startarc;i <= n;i++){
        if(i>12){
            break;
        }
        rd2 = arc_interval*i;
        CGContextAddArc(ctx, point2X, point2Y, rd2, ToRad(startAngle+arc_angle), ToRad(startAngle-arc_angle), 1);
        CGContextStrokePath(ctx);
    }
    
    double x=(WIND_Width-mThumbTX)/xtap;
    double y=(WIND_CenterY-mThumbTY)/ytap;
    rr[1]=(double) x;
    rr[3]=(double) y;
}


//画触摸点
-(void)drawThumb:(CGContextRef)context
{
    UIImage *thumb = [UIImage imageNamed:[PIMG DPIMG:@"chs_lp_delay_normal"]];
    mThumbWidth = _rectThumb.size.width;
    mThumbHeight = _rectThumb.size.height;
    
    _rectThumb.origin.x = mThumbTX-mThumbWidth*0.5;
    _rectThumb.origin.y = mThumbTY-mThumbHeight*0.5;
    
    
    //边界处理
    //左右
    if(_rectThumb.origin.x<0){
        _rectThumb.origin.x=0;
    }else if(_rectThumb.origin.x>(WIND_Width-mThumbWidth)){
        _rectThumb.origin.x=WIND_Width-mThumbWidth;
    }
    
    //上下
    if(_rectThumb.origin.y <0){
        _rectThumb.origin.y=0;
    }else if(_rectThumb.origin.y>(WIND_Height/2-mThumbHeight/2)){
        _rectThumb.origin.y=WIND_Height/2-mThumbHeight/2;
    }
    
    _rectThumb.size = thumb.size;
    
    [thumb drawInRect:_rectThumb blendMode:kCGBlendModeNormal alpha:1];
}


-(void)countDelayTime{
    xtap=WIND_Width/CCar[0];
    ytap=WIND_Height/5;//固定5M
    
    int hd=(int) ((rr[2]/0.34)*48);
    //NSLog(@"rr[0]=%f,rr[1]=%f,rr[2]=%f,rr[3]=%f",rr[0],rr[1],rr[2],rr[3]);
    if(rr[0]>=rr[1]){
        progress[1]=hd;
        progress[0]=(int) (((rr[0]-rr[1])/0.34)*48)+hd;
    }else{
        progress[0]=hd;
        progress[1]=(int) (((rr[1]-rr[0])/0.34)*48)+hd;
        
    }
}

#pragma Class call
- (struct BufData)getDelayFourData{
    for(int i=0;i<4;i++){
        Forbuf.bufD[i]=progress[i];
    }
    return  Forbuf;
}

@end
