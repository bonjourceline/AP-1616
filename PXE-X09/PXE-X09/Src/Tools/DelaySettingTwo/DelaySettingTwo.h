//
//  DelaySettingFour.h
//  NetTuning
//
//  Created by chsdsp on 16/9/6.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "MacDefine.h"
#import "DataStruct.h"
#import "PIMG.h"



@interface DelaySettingTwo : UIControl
{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    double WIND_MIN;
    double WIND_MRidius;

    
    float LPDrawable1W;
    float LPDrawable1H;
    float LPDrawable2W;
    float LPDrawable2H;
    float LPDrawable3W;
    float LPDrawable3H;
    float LPDrawable4W;
    float LPDrawable4H;

    int mThumbHeight;
    int mThumbWidth;
    int mThumbNormal[4];
    int mThumbPressed[4];
    float mThumbTX;
    float mThumbTY;

    float mThumbLeftOld;
    float mThumbTopOld;

    float mThumbDrawX;
    float mThumbDrawY;

    int arc_color;
    int startarc;
    float rd1;
    float rd2;
    float rd3;
    float rd4;

    double xtap;
    double ytap;
    double rtap;
    int progress[4];
    double rr[4];
    
    //CGPoint
    CGPoint RectF_Point1;
    CGPoint RectF_Point2;
    CGPoint RectF_Point3;
    CGPoint RectF_Point4;
    
    float point1X;
    float point1Y;
    float point2X;
    float point2Y;
    float point3X;
    float point3Y;
    float point4X;
    float point4Y;
    
    //Paint
    CGRect _rectThumb; //拖动点

    float arc_width;
    int arc_angle;
    float arc_interval;

    struct BufData Forbuf;
}

- (struct BufData)getDelayFourData;

@end
