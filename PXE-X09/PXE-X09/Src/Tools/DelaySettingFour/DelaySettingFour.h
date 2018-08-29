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



@interface DelaySettingFour : UIControl
{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    double WIND_MIN;
    double WIND_MRidius;

    
    double LPDrawable1W;
    double LPDrawable1H;
    double LPDrawable2W;
    double LPDrawable2H;
    double LPDrawable3W;
    double LPDrawable3H;
    double LPDrawable4W;
    double LPDrawable4H;

    int mThumbHeight;
    int mThumbWidth;
    int mThumbNormal[4];
    int mThumbPressed[4];
    double mThumbTX;
    double mThumbTY;

    float mThumbLeftOld;
    double mThumbTopOld;

    double mThumbDrawX;
    double mThumbDrawY;

    int arc_color;
    int startarc;
    double rd1;
    double rd2;
    double rd3;
    double rd4;

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
