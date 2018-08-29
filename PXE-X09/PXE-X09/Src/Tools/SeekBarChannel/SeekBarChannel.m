//
//  SeekBarChannel.m
//  AP-DAP612-PXE-0850P
//
//  Created by chsdsp on 2017/6/20.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "SeekBarChannel.h"

#define SeekBarChannelHeight 70



@implementation SeekBarChannel


- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        WIND_Width   = frame.size.width;
        WIND_Height  = frame.size.height;
        WIND_CenterX = WIND_Width/2;
        WIND_CenterY = WIND_Height/2;
        WIND_MIN     = MIN(WIND_Width, WIND_Height);

        //        NSLog(@"WIND_Width = @%f",WIND_Width);
        //        NSLog(@"WIND_Height = @%f",WIND_Height);
        
        [self setup];
    }
    return self;
}

- (void)setup{
    channel = 0;
    //self.backgroundColor = [UIColor colorWithRed:16/255.0 green:26/255.0 blue:74/255.0 alpha:1.0];
    bg = [[UIImageView alloc]init];
    bg.frame = self.frame;
    [self addSubview:bg];
    [bg setImage:[UIImage imageNamed:@"channel_select_bg"]];
    
    self.selectorHorizontal = [[IZValueSelectorView alloc]initWithFrame:CGRectMake(0, 0, WIND_Width, WIND_Height)];
    self.selectorHorizontal.dataSource = self;
    self.selectorHorizontal.delegate = self;
    self.selectorHorizontal.shouldBeTransparent = YES;
    self.selectorHorizontal.horizontalScrolling = YES;
    
    //You can toggle Debug mode on selectors to see the layout
    self.selectorHorizontal.debugEnabled = NO;
    self.selectorHorizontal.frame = self.frame;
    
    [self.selectorHorizontal setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.selectorHorizontal];
    [self.selectorHorizontal selectRowAtIndex:0];
}

#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector {
    //NSLog(@"##  numberOfRowsInSelector");
    return Output_CH_MAX;
}



//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    return 70.0;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return WIND_Height;
}

- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index
{
    return [self selector:valueSelector viewForRowAtIndex:index selected:NO];
}

- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index selected:(BOOL)selected {
    UILabel * label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIND_Height, self.selectorHorizontal.frame.size.height)];
    
    label.text = [NSString stringWithFormat:@"CH%d",(int)index+1];
    label.textAlignment =  NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    if (selected) {
        label.textColor = [UIColor whiteColor];
    } else {
        label.textColor = [UIColor whiteColor];
    }
    [label setBackgroundColor:[UIColor clearColor]];
    //NSLog(@"##  valueSelector=%@",label.text);
    return label;
}

- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector {
    //Just return a rect in which you want the selector image to appear
    //Use the IZValueSelector coordinates
    //Basically the x will be 0
    //y will be the origin of your image
    //width and height will be the same as in your selector image
    return CGRectMake(self.selectorHorizontal.frame.size.width/2 - 35.0, 0.0, WIND_Height, 90.0);
}

#pragma IZValueSelector delegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    channel = (int)index;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    });
    
}




#pragma 接口
- (void)setChannel:(int)val{
    channel = val;
    [self.selectorHorizontal selectRowAtIndex:channel];
}

- (int)getChannel{
    return channel;
}



@end
