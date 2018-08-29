//
//  ViewLine.h
//  YB-DAP460-X2S
//
//  Created by chsdsp on 2017/4/28.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "MacDefine.h"
#import "DataStruct.h"
#import "Masonry.h"


#define UI_Line1_Color  (0xFF3c3d49) //
#define UI_Line2_Color  (0xFF121115) //

#define Line1Height 1
#define Line2Height 1
#define ViewLineHeight (Line1Height+Line1Height)

@interface ViewLine : UIView{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    
    int tag;
    
    UIView *VLine1;
    UIView *VLine2;
}

@end
