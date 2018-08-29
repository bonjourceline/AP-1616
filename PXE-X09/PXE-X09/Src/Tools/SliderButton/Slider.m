//
//  VolumeCircleIMLine.m
//  MT-IOS
//
//  Created by chsdsp on 2017/3/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "Slider.h"
#import <math.h>


#define P_ArcRadius 0.8
#define P_ImgRadius 0.7
#define P_ImgRadius_BG 0.8


#define T_RadiusOut 0.80
#define T_RadiusIN  0.69

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@implementation Slider



#pragma mark -init

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
    ArcRadius = WIND_MRidius * P_ArcRadius;
    ImgRadius = WIND_MRidius * P_ImgRadius;
    ImgRadius_BG = WIND_MRidius * P_ImgRadius_BG;
    
    T_Radius_LineOut = WIND_MRidius * T_RadiusOut;
    T_Radius_LineIn  = WIND_MRidius * T_RadiusIN;
    
    self.SBStyle = Slider_IMAGE;//VCSS_LINE_ONLY VCSS_LINE_PARK VCSS_LINE_IMAGE VCSS_LINE_PARK_IMAGE
    Progress = 170;//当前数值
    MaxProgress   = 660;//最大数值
    ProgressWidth = 3; //seekbara 线宽
    
    Draw_AngleStart = M_PI*3/4;//起始角度
    Draw_AngleEnd   = M_PI*9/4;  //结束角度
    Draw_AngleMax   = Draw_AngleEnd - Draw_AngleStart;
    Draw_AngleStep  = Draw_AngleMax/(MaxProgress+10);
    
    SB_AngleStart = 135;//起始角度
    SB_AngleEnd   = 45;  //结束角度
    SB_AngleMax = SB_AngleEnd > SB_AngleStart ?
        (SB_AngleEnd - SB_AngleStart):(SB_AngleEnd +360 - SB_AngleStart);
    SB_AngleStep  = SB_AngleMax/(MaxProgress+10);
    
    T_AngleStep = SB_AngleMax/((MaxProgress+10)/10);
    
    ColorArc_Progress = SetColor(UI_Master_SB_Volume_Press);//seekbar 进度颜色
    ColorArc_BGProgress = SetColor(UI_Master_SB_Volume_Normal);//seekbar 条底颜色
    ColorProgressPoint = SetColor(UI_Master_SB_Volume_Point);//seekbar 条底颜色
    
    ColorArc_Gain_P = SetColor(UI_EQSB_VolGain_P_Color);
    ColorArc_Gain_N = SetColor(UI_EQSB_VolGain_P_Color);//UI_EQSB_VolGain_N_Color
    
    if(self.SBStyle >= Slider_LINE_IMAGE){
        
        self.MasterImg = [[UIImageView alloc]init];
        self.MasterImg.frame = CGRectMake(WIND_MRidius * (1-P_ImgRadius),
                                          WIND_MRidius * (1-P_ImgRadius),
                                          ImgRadius*2,
                                          ImgRadius*2);
        self.MasterImg.image = [UIImage imageNamed:[PIMG DPIMG:@"master_vol_indicator"]];
        [self addSubview:self.MasterImg];
        self.MasterImg.center = self.center;
        
        
        self.MasterImgBg = [[UIImageView alloc]init];
        self.MasterImgBg.frame = CGRectMake(0,
                                            0,
                                            ImgRadius_BG*2,
                                            ImgRadius_BG*2);
        self.MasterImgBg.image = [UIImage imageNamed:@"master_vol_indicator_bg"];
        self.MasterImgBg.center = self.center;
        [self addSubview:self.MasterImgBg];
    
    }
}
#pragma mark -Draw UI
/**/
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
    Progress = totalDegree/SB_AngleStep;
    
    if(Progress < 0){
        Progress = 0;
    }
    if(Progress > MaxProgress){
        Progress = MaxProgress;
    }

    /*画中心圆形按键*/
    if(self.SBStyle == Slider_LINE_IMAGE){////有线和图片
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGAffineTransform transform= CGAffineTransformMakeRotation(sweepAngle);//*0.38
        self.MasterImg.transform = transform;
        
        /*画seekbar弧BGProgress*/
        CGContextSetStrokeColorWithColor(context, ColorArc_BGProgress.CGColor);
        CGContextSetLineWidth(context, ProgressWidth);
        CGContextAddArc(context, WIND_CenterX, WIND_CenterY, ArcRadius,  Draw_AngleStart, Draw_AngleEnd, false);
        CGContextDrawPath(context, kCGPathStroke);
        
        /*画seekbar弧Progress*/
        CGContextSetStrokeColorWithColor(context, ColorArc_Progress.CGColor);
        CGContextSetLineWidth(context, ProgressWidth);
        if(Progress == MaxProgress){
            CGContextAddArc(context, WIND_CenterX, WIND_CenterY, ArcRadius,  Draw_AngleStart, Draw_AngleEnd, false);
        }else{
            CGContextAddArc(context, WIND_CenterX, WIND_CenterY, ArcRadius,  Draw_AngleStart, Draw_AngleStart+sweepAngle, false);
        }
        CGContextDrawPath(context, kCGPathStroke);
    }else if(self.SBStyle == Slider_LINE_ONLY){//只有圆形线，线是分段的，像时钟那样
        CGContextRef context = UIGraphicsGetCurrentContext();
        /*画seekbar弧BGProgress*/
        CGContextSetStrokeColorWithColor(context, ColorArc_BGProgress.CGColor);
        CGContextSetLineWidth(context, ProgressWidth);
        CGContextAddArc(context, WIND_CenterX, WIND_CenterY, ArcRadius,  Draw_AngleStart, Draw_AngleEnd, false);
        CGContextDrawPath(context, kCGPathStroke);
        
        /*画seekbar弧Progress*/
        CGContextSetStrokeColorWithColor(context, ColorArc_Progress.CGColor);
        CGContextSetLineWidth(context, ProgressWidth);
        if(Progress == MaxProgress){
            CGContextAddArc(context, WIND_CenterX, WIND_CenterY, ArcRadius,  Draw_AngleStart, Draw_AngleEnd, false);
        }else{
            CGContextAddArc(context, WIND_CenterX, WIND_CenterY, ArcRadius,  Draw_AngleStart, Draw_AngleStart+sweepAngle, false);
        }
        CGContextDrawPath(context, kCGPathStroke);
    }else if(self.SBStyle == Slider_LINE_PARK){//只有圆形线，线是分段的，像时钟那样
        //画Progress Bg
        [self draw_T_ProgressBg];
        //画Progress
        [self draw_T_Progress];
        //画点
        //[self draw_T_ProgressPoint];
    }else if(self.SBStyle == Slider_TLINE_IMAGE){////有线和图片
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGAffineTransform transform= CGAffineTransformMakeRotation(sweepAngle);//*0.38
        self.MasterImg.transform = transform;
        
        /*画seekbar弧BGProgress*/
//        CGContextSetStrokeColorWithColor(context, ColorArc_BGProgress.CGColor);
//        CGContextSetLineWidth(context, ProgressWidth);
//        CGContextAddArc(context, WIND_CenterX, WIND_CenterY, ArcRadius,  Draw_AngleStart, Draw_AngleEnd, false);
//        CGContextDrawPath(context, kCGPathStroke);
        
        /*画seekbar弧Progress*/
        if(Progress <= MaxProgress/2){
            CGContextSetStrokeColorWithColor(context, ColorArc_Gain_N.CGColor);
            CGContextSetLineWidth(context, ProgressWidth);
            CGContextAddArc(context, WIND_CenterX, WIND_CenterY, ArcRadius,
                            Draw_AngleStart+sweepAngle,
                            Draw_AngleStart+Draw_AngleMax/2,
                            false);
        }else{
            CGContextSetStrokeColorWithColor(context, ColorArc_Gain_P.CGColor);
            CGContextSetLineWidth(context, ProgressWidth);
            if(Progress == MaxProgress){
                CGContextAddArc(context, WIND_CenterX, WIND_CenterY, ArcRadius,  Draw_AngleStart+Draw_AngleMax/2, Draw_AngleEnd, false);
            }else{
                CGContextAddArc(context, WIND_CenterX, WIND_CenterY, ArcRadius,  Draw_AngleStart+Draw_AngleMax/2, Draw_AngleStart+sweepAngle, false);
            }
        }

        
        CGContextDrawPath(context, kCGPathStroke);
    }else if(self.SBStyle == Slider_IMAGE){////有线和图片
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGAffineTransform transform= CGAffineTransformMakeRotation(sweepAngle);//*0.38
        self.MasterImg.transform = transform;
        
        CGContextDrawPath(context, kCGPathStroke);
    }
}

#pragma mark - UIControl Override -
/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    //记下起点
    CGPoint lastPoint = [touch locationInView:self];
    AngleStart = [self GetTouchAngle:lastPoint];
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
    AngleStart = AngleCur;
    //Control value has changed, let's notify that
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
}


/** Move the Handle **/
-(void)movehandle:(CGPoint)lastPoint{
    float degrees;
    AngleCur = [self GetTouchAngle:lastPoint];
    degrees = AngleStart - AngleCur;
    if (degrees > 300) {
        degrees = degrees - 360;
    } else if (degrees < -300) {
        degrees = 360 + degrees;
    }
    float sum = totalDegree + degrees;
    if(sum > SB_AngleMax || sum < 0){
        return;
    }

    totalDegree = sum;
    totalDegree = (int)totalDegree % 360;
    if (totalDegree < 0) {
        totalDegree += 360;
    }
    sweepAngle = ToRad(totalDegree);
    
    //Redraw
    [self setNeedsDisplay];
}
//获取触摸所在的角度
-(float) GetTouchAngle:(CGPoint)LastPoint{
    float angle = 0;
    angle = [self getAngle:LastPoint.x witih_Y:LastPoint.y];
    return angle;
}

-(float) getAngle:(float) x witih_Y:(float) y{
    x = x - (WIND_Width / 2);
    y = WIND_Height - y - (WIND_Height / 2);
    
    switch ([self getQuadrant:x: y]) {
        case 1:
            return asin(y / hypot(x, y)) * 180 / M_PI;
        case 2:
            return 180 - asin(y / hypot(x, y)) * 180 / M_PI;
        case 3:
            return 180 + (-1 * asin(y / hypot(x, y)) * 180 / M_PI);
        case 4:
            return 360 + asin(y / hypot(x, y)) * 180 / M_PI;
        default:
            return 0;
    }
}
-(int) getQuadrant:(float) x :(float) y {
    if (x >= 0) {
        return y >= 0 ? 1 : 4;
    } else {
        return y >= 0 ? 2 : 3;
    }
}
/**********************              *********************/
-(void)draw_T_ProgressBg{
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*画seekbar弧BGProgress*/
    CGContextSetStrokeColorWithColor(context, ColorArc_BGProgress.CGColor);
    CGContextSetLineWidth(context, ProgressWidth/2);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextBeginPath(context);

    CGPoint startPoint;
    CGPoint endPoint;
    //int i=0;
    for(int i=0; i<=MaxProgress/10;i++){
        startPoint = [self pointFromAngle:(180+SB_AngleStart + T_AngleStep*i) withRadius:T_Radius_LineIn];
        endPoint = [self pointFromAngle:(180+SB_AngleStart + T_AngleStep*i) withRadius:T_Radius_LineOut];
        //起点坐标
        CGContextMoveToPoint(context,startPoint.x, startPoint.y);
        //终点坐标
        CGContextAddLineToPoint(context,endPoint.x, endPoint.y);
    }
    CGContextStrokePath(context);
}

-(void)draw_T_Progress{
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*画seekbar弧BGProgress*/
    CGContextSetStrokeColorWithColor(context, ColorArc_Progress.CGColor);
    CGContextSetLineWidth(context, ProgressWidth/2);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextBeginPath(context);
    
    CGPoint startPoint;
    CGPoint endPoint;
    //int i=0;
    for(int i=1; i<=(Progress/10 + 1);i++){
        startPoint = [self pointFromAngle:(180+SB_AngleEnd - T_AngleStep*i) withRadius:T_Radius_LineIn];
        endPoint = [self pointFromAngle:(180+SB_AngleEnd - T_AngleStep*i) withRadius:T_Radius_LineOut];
        //起点坐标
        CGContextMoveToPoint(context,startPoint.x, startPoint.y);
        //终点坐标
        CGContextAddLineToPoint(context,endPoint.x, endPoint.y);
    }
    CGContextStrokePath(context);
}

-(void)draw_T_ProgressPoint{
    CGPoint Point = [self pointFromAngle:(180+SB_AngleStart + T_AngleStep*(MaxProgress-Progress)/10) withRadius:T_Radius_LineOut+ProgressWidth*0.8];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, ColorProgressPoint.CGColor);
    CGContextSetStrokeColorWithColor(context, ColorProgressPoint.CGColor);
    CGContextSetLineWidth(context, ProgressWidth);
    CGContextAddArc(context, Point.x, Point.y, ProgressWidth*0.8, 0, 2*M_PI, YES);
    CGContextDrawPath(context, kCGPathFill);
}

/** Given the angle, get the point position on circumference **/
-(CGPoint)pointFromAngle:(double)angleInt withRadius:(double)radius{
    
    //Circle center
    CGPoint centerPoint = CGPointMake(WIND_Width/2, WIND_Height/2);
    
    //The point position on the circumference
    CGPoint result;
    double x,y;
    
//    y = round(centerPoint.y + radius * sin(ToRad(-angleInt)));
//    x = round(centerPoint.x + radius * cos(ToRad(-angleInt)));
    y = centerPoint.y + radius * sin(ToRad(-angleInt));
    x = centerPoint.x + radius * cos(ToRad(-angleInt));
    result.x = x;
    result.y = y;
    
    return result;
}
#pragma 属性设置
/**/
//获取当前位置
-(int)GetProgress{
    return Progress/10;
}
//设置当前位置
-(void)setProgress:(int)ProgressSet{
    //NSLog(@"setProgress:@%d",ProgressSet);
    Progress = ProgressSet * 10;
    totalDegree = SB_AngleStep * Progress ;
    
    sweepAngle = ToRad(totalDegree);
    [self setNeedsDisplay];
}
//设置最大值
-(void)setMaxProgress:(int)Max{
    //NSLog(@"setMaxProgress:@%d",Max);
    MaxProgress = Max*10;
    
    Draw_AngleStart = M_PI*3/4;//起始角度
    Draw_AngleEnd   = M_PI*9/4;  //结束角度
    Draw_AngleMax   = Draw_AngleEnd - Draw_AngleStart;
    Draw_AngleStep  = Draw_AngleMax/(MaxProgress+10);
    
    SB_AngleStart = 135;//起始角度
    SB_AngleEnd   = 45;  //结束角度
    SB_AngleMax = SB_AngleEnd > SB_AngleStart ?
    (SB_AngleEnd - SB_AngleStart):(SB_AngleEnd +360 - SB_AngleStart);
    SB_AngleStep  = SB_AngleMax/(MaxProgress+10);
    
    T_AngleStep = SB_AngleMax/((MaxProgress+10)/10);
    
}

//设置圆弧起始和终点位置
-(void)setArcDrawStartAndEnd:(float)start withEnd:(float)end{
    SB_AngleStart = start;//起始角度
    SB_AngleEnd   = end;  //结束角度
    SB_AngleMax = SB_AngleEnd > SB_AngleStart ?
    (SB_AngleEnd - SB_AngleStart):(SB_AngleEnd +360 - SB_AngleStart);
    SB_AngleStep  = SB_AngleMax/(MaxProgress+10);

    
    Draw_AngleStart = ToRad(SB_AngleStart);//起始角度
    Draw_AngleEnd   = ToRad(SB_AngleEnd);  //结束角度
    Draw_AngleMax   = Draw_AngleEnd - Draw_AngleStart;
    Draw_AngleStep  = Draw_AngleMax/(MaxProgress+10);
    
}
//设置Progress颜色
-(void)setColorProgress:(UIColor*) Color{
    ColorArc_Progress = Color;
}
//设置Progress背景颜色
-(void)setColorBGProgress:(UIColor*) Color{
    ColorArc_BGProgress = Color;
}
//设置ProgressWidth
-(void)setProgressWidth:(float) Width{
    ProgressWidth = Width;
}



@end
