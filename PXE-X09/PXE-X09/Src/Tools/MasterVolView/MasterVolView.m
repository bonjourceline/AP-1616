//
//  MasterVolView.m
//  JH-DBP4106-newMusic
//
//  Created by chs on 2017/11/22.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "MasterVolView.h"
#import "MacDefine.h"
#import "DataProgressHUD.h"
@implementation MasterVolView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self=[[[NSBundle mainBundle] loadNibNamed:@"MasterVolView" owner:nil options:nil]lastObject];
    if (self) {
        self.frame=frame;
        
        [self initView];
    }
    return self;
    
}
-(void)setSliderValue:(int) value{
    self.hidden=NO;
    [self.VolSlider setValue:value animated:YES];
    if ([DataProgressHUD shareManager].showVolView) {
        
        [self hideVolView];
    }else{
        self.hidden=YES;
    }
    
}
-(void)hideVolView{
    self.volumeAnimation=VolumeAnimationFadeIn;
    [UIView animateKeyframesWithDuration: 2 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations:^{
            switch (self.volumeAnimation) {
                case VolumeAnimationFadeIn:
                    self.alpha = 1.0f;
                    break;
                case VolumeAnimationSlideDown:
                    self.alpha = 1.0f;
                    self.transform = CGAffineTransformIdentity;
                    break;
                default:
                    break;
            }
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            switch (self.volumeAnimation) {
                case VolumeAnimationFadeIn:
                    self.alpha = 0.0001;
                    break;
                case VolumeAnimationSlideDown:
                    self.alpha = 0.0001;
                    self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
                    break;
                default:
                    break;
            }
        }];
    } completion:nil];
//    [self.showTime invalidate];
//    self.showTime=nil;
//    count=0;
//    self.showTime=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    
}
-(void)countTime{
    count ++;
    if (count==1) {
        [self dismissView];
        [self.showTime invalidate];
        self.showTime=nil;
        
    }
}
-(void)dismissView{
    
    [UIView animateWithDuration:0.7 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        self.hidden=YES;
        self.alpha=1;
    }];
    
}
-(void)initView{
    self.hidden=YES;
    self.VolSlider.minimumValue=0;
    self.VolSlider.maximumValue=Master_Volume_MAX;
    self.VolSlider.userInteractionEnabled=NO;
    self.hidden=YES;
    if(MasterVolumeMute_DATA_TRANSFER == COM_TYPE_INPUT){
        [self.VolSlider setValue:RecStructData.IN_CH[0].Valume];
    }else{
        [self.VolSlider setValue:RecStructData.System.main_vol];
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
