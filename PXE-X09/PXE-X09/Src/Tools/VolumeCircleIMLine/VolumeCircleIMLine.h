//
//  VolumeCircleIMLine.h
//  MT-IOS
//
//  Created by chsdsp on 2017/3/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TInstrumentView.h"

#define Calculate_radius ((self.bounds.size.height>self.bounds.size.width)?(self.bounds.size.width*0.5-self.lineWidth):(self.bounds.size.height*0.5-self.lineWidth))
#define LuCenter CGPointMake(self.center.x-self.frame.origin.x, self.center.y-self.frame.origin.y)


//音量条类型
typedef NS_ENUM(NSUInteger, VolumeCircularSliderStyle) {
    VCSS_LINE_ONLY = 1,  //只有圆形线
    VCSS_LINE_J = 2, //圆形+J+T图片
    VCSS_LINE_PARK = 3,  //只有圆形线，线是分段的，像时钟那样
    VCSS_LINE_IMAGE = 4, //有线和图片
    VCSS_LINE_PARK_IMAGE = 5, //有圆形线，线是分段的，像时钟那样和图片
    VCSS_LINE_Thumb = 6, //有圆形线和thumb图片
    VCSS_LINE_OnlyImage =7 ,//只有图片
};


@interface VolumeCircleIMLine : UIControl{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    double WIND_MIN;
    double WIND_MRidius;
    
    double SB_AngleStart;//起始角度
    double SB_AngleEnd;  //结束角度
    double SB_AngleMax;  //总弧长度
    double SB_AngleStep; //弧步进

    double Draw_AngleStart;//起始角度
    double Draw_AngleEnd;  //结束角度
    double Draw_AngleMax;  //总弧长度
    double Draw_AngleStep; //弧步进
    
    int Progress;
    int MaxProgress;//最大数值
    double ProgressWidth; //seekbara 线宽
    
    
    
    double AngleStart;//手滑动起始角度
    double AngleEnd;  //手滑动结束角度
    double AngleCur;  //手滑动结束角度
    double ArcRadius; //Seekbar半径
    double ImgRadius; //Seekbar半径
    
    double sweepAngle;
    double totalDegree;
    UIColor* ColorArc_Progress;//seekbar 进度颜色
    UIColor* ColorArc_BGProgress;//seekbar 条底颜色
    UIColor* ColorProgressPoint;//seekbar 条底颜色
    UIColor* ColorCirInside;//内部实心圆颜色
    //UIImage* MasterImg; //中心圆形图片
    
    CGAffineTransform _currentTransform;
    
    
    //时钟线
    double T_Radius_LineOut; //单根时钟线的外点
    double T_Radius_LineIn;  //单根时钟线的m内点，内外点画线
    double T_AngleStep; //弧步进
    
    double T_Radius_Circle; //单根时钟线的外点
}
@property (nonatomic) VolumeCircularSliderStyle SBStyle; //控件样式,默
@property (nonatomic,strong) UIImageView *MasterImg; //中心圆形图片

@property (nonatomic,strong) UIImageView *MasterImgBg; //中心圆形图片

//获取当前位置
-(int)GetProgress;
//设置当前位置
-(void)setProgress:(int)ProgressSet;
//设置最大值
-(void)setMaxProgress:(int)Max;
//设置圆弧起始和终点位置
-(void)setArcDrawStartAndEnd:(float)start withEnd:(float)end;
//设置Progress颜色
-(void)setColorProgress:(UIColor*) Color;
//设置Progress背景颜色
-(void)setColorBGProgress:(UIColor*) Color;
//设置ProgressWidth
-(void)setProgressWidth:(float) Width;
@end
