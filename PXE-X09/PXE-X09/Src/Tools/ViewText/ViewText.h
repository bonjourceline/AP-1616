//
//  ViewText.h
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


#define ViewTextTop 5
#define ViewHeight 70
#define TextHeight 20
#define ViewTextHeight (ViewHeight+TextHeight+ViewTextTop)
#define ViewTextWidth (ViewHeight)


#define UI_ViewText_Press  (0xFFd9d9d9) //
#define UI_ViewText_Normal (0xFFffffff) //


@interface ViewText : UIView{
@private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    
    int tag;
}
@property (strong, nonatomic) UILabel  *mLable;
@property (strong, nonatomic) UIButton   *mView;

- (void)setTag:(int)stag;
@end
