//
//  SourceModeUtils.m
//  PXE-X09
//
//  Created by celine on 2018/10/16.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "SourceModeUtils.h"

@implementation SourceModeUtils
+ (instancetype)shareManager
{
    static SourceModeUtils *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[SourceModeUtils alloc]init];
    });
    return share;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化对象
        
    }
    return self;
}
+ (NSString *) getOutModeName:(int)index{
    NSString *str=@"";
    NSArray *nameArray=@[
                         [LANG DPLocalizedString:@"自定义"],
                         [LANG DPLocalizedString:@"前声场立体声"],
                         [LANG DPLocalizedString:@"四声道全频"],
                         [LANG DPLocalizedString:@"四声道全频+超低"],
                         [LANG DPLocalizedString:@"四声道全频+左右超低"],
                         
                         [LANG DPLocalizedString:@"前主动二分频+后全频"],
                         [LANG DPLocalizedString:@"前主动二分频+后全频+超低"],
                         [LANG DPLocalizedString:@"前主动二分频+后全频+左右超低"],
                         [LANG DPLocalizedString:@"前主动二分频+后全频+中置+左右超低"],
                         [LANG DPLocalizedString:@"前主动二分频+后全频+中置+超低"],
                         
                         [LANG DPLocalizedString:@"前主动三分频+后二分频+中置+超低"],
                         [LANG DPLocalizedString:@"前主动三分频+后二分频+中置+左右超低"],
                         
                         [LANG DPLocalizedString:@"前主动三分频+后全频+中置+超低"],
                         [LANG DPLocalizedString:@"前主动三分频+后全频+中置+左右超低"],
                         
                         [LANG DPLocalizedString:@"前主动三分频+后全频+超低"],
                         [LANG DPLocalizedString:@"前主动三分频+后全频+左右超低"],
                         [LANG DPLocalizedString:@"前主动三分频+后主动三分频+中置高/低+左右超低"],
                         
                         ];
    if (nameArray.count>index) {
        str=[nameArray objectAtIndex:index];
    }
    return str;
}
+(NSString *)getAuxModeName:(int)index{
    NSString *str=@"";
    NSArray *nameArray=@[
                         [LANG DPLocalizedString:@"自定义"],
                         [LANG DPLocalizedString:@"立体声"],
                         [LANG DPLocalizedString:@"四声道"],
                         [LANG DPLocalizedString:@"六声道（5.1）"],
                         [LANG DPLocalizedString:@"八声道（7.1）"],
                         ];
    if (nameArray.count>index) {
        str=[nameArray objectAtIndex:index];
    }
    return str;
}
+(void)syncSourceTemp{
    for (int i=0; i<5; i++) {
        RecStructData.System.InSwitch_temp[i]=RecStructData.System.InSwitch[i];
    }
    
    RecStructData.System.high_mode_temp=RecStructData.System.high_mode;
    RecStructData.System.aux_mode_temp=RecStructData.System.aux_mode;
    RecStructData.System.out_mode_temp=RecStructData.System.out_mode;
    RecStructData.System.HiInputChNum_temp=RecStructData.System.HiInputChNum;
    RecStructData.System.AuxInputChNum_temp=RecStructData.System.AuxInputChNum;
    RecStructData.System.OutputChNum_temp=RecStructData.System.OutputChNum;
    
    for (int i=0; i<8; i++) {
        
        RecStructData.System.high_Low_Set_temp[i]=RecStructData.System.high_Low_Set[i];
    }
}
+(void)syncSource{
    for (int i=0; i<5; i++) {
        RecStructData.System.InSwitch[i]=RecStructData.System.InSwitch_temp[i];
    }
    
    RecStructData.System.high_mode=RecStructData.System.high_mode_temp;
    RecStructData.System.aux_mode=RecStructData.System.aux_mode_temp;
    RecStructData.System.out_mode=RecStructData.System.out_mode_temp;
    RecStructData.System.HiInputChNum=RecStructData.System.HiInputChNum_temp;
    RecStructData.System.AuxInputChNum=RecStructData.System.AuxInputChNum_temp;
    RecStructData.System.OutputChNum=RecStructData.System.OutputChNum_temp;
    
    for (int i=0; i<8; i++) {
        
        RecStructData.System.high_Low_Set[i]=RecStructData.System.high_Low_Set_temp[i];
    }
}
@end
