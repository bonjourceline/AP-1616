//
//  SeekBarChannel.h
//  AP-DAP612-PXE-0850P
//
//  Created by chsdsp on 2017/6/20.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "MacDefine.h"
#import "DataStruct.h"
#import "IZValueSelectorView.h"



@interface SeekBarChannel : UIControl
<IZValueSelectorViewDataSource,
IZValueSelectorViewDelegate>
{
    @private
    double WIND_Width;
    double WIND_Height;
    double WIND_CenterX;
    double WIND_CenterY;
    double WIND_MIN;
    //曲线框的边距
    double marginLeft;
    double marginRight;
    double marginTop;
    double marginBottom;
    double frameWidth;
    double frameHeight;

    int channel;
    UIImageView *bg;
    
}
@property (strong, nonatomic) IZValueSelectorView *selectorHorizontal;
- (void)setChannel:(int)val;
- (int)getChannel;


@end
