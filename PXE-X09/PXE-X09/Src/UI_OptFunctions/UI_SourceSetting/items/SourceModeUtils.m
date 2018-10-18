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
+(void)setHiModeTypeSetting{
    switch (RecStructData.System.high_mode_temp) {
        case 1:
            RecStructData.System.HiInputChNum_temp=2;
            RecStructData.System.in_spk_type_temp[0]=6;
            RecStructData.System.in_spk_type_temp[1]=12;
            break;
        case 2:
            RecStructData.System.HiInputChNum_temp=4;
            
            break;
        case 3:
            RecStructData.System.HiInputChNum_temp=5;
            break;
        case 4:
            RecStructData.System.HiInputChNum_temp=6;
            break;
        case 5:
            RecStructData.System.HiInputChNum_temp=6;
            break;
        case 6:
            RecStructData.System.HiInputChNum_temp=7;
            break;
        case 7:
            RecStructData.System.HiInputChNum_temp=8;
            break;
        case 8:
            RecStructData.System.HiInputChNum_temp=9;
            break;
        case 9:{
            RecStructData.System.HiInputChNum_temp=8;
        }
            break;
        case 10:{
            RecStructData.System.HiInputChNum_temp=12;
        }
            break;
        case 11:{
            RecStructData.System.HiInputChNum_temp=13;
        }
            break;
        case 12:{
            RecStructData.System.HiInputChNum_temp=10;
        }
            break;
        case 13:{
            RecStructData.System.HiInputChNum_temp=11;
        }
            break;
        case 14:{
            RecStructData.System.HiInputChNum_temp=9;
        }
            break;
        case 15:{
            RecStructData.System.HiInputChNum_temp=10;
        }
            break;
        case 16:{
            RecStructData.System.HiInputChNum_temp=16;
        }
            break;
//        case 0:{
//
//        }
            break;
        default:
            break;
    }
}
+(int)getHiModeTypeChNum:(int)index{
    int count=0;
    switch (index) {
        case 0:{
            count=0;
        }
            break;
        case 1:{
            count=2;
        }
            break;
        case 2:
            count=4;
            
            break;
        case 3:
            count=5;
            break;
        case 4:
            count=6;
            break;
        case 5:
            count=6;
            break;
        case 6:
            count=7;
            break;
        case 7:
            count=8;
            break;
        case 8:
            count=9;
            break;
        case 9:{
            count=8;
        }
            break;
        case 10:{
            count=12;
        }
            break;
        case 11:{
            count=13;
        }
            break;
        case 12:{
            count=10;
        }
            break;
        case 13:{
            count=11;
        }
            break;
        case 14:{
            count=9;
        }
            break;
        case 15:{
            count=10;
        }
            break;
        case 16:{
            count=16;
        }
            break;
        default:
            break;
    }
    return count;
}
+(void)setAUXModeTypeSetting{
    switch (RecStructData.System.aux_mode_temp) {
        case 1:{
            RecStructData.System.AuxInputChNum_temp=2;
        }
            break;
        case 2:{
            RecStructData.System.AuxInputChNum_temp=4;
        }
            break;
        case 3:{
            RecStructData.System.AuxInputChNum_temp=6;
        }
            break;
        case 4:{
            RecStructData.System.AuxInputChNum_temp=8;
        }
            break;
        default:
            break;
            
    }
}
+(int)getAuxModeTypeChNum:(int)index{
    int count=0;
    switch (index) {
        case 0:{
            count=0;
        }
            break;
        case 1:
            count=2;
            break;
        case 2:{
            count=4;
        }
            break;
        case 3:{
            count=6;
        }
            break;
        case 4:{
            count=8;
        }
            break;
            
        default:
            break;
    }
    return count;
}
+(void)setOUTModeTypeSetting{
    switch (RecStructData.System.out_mode_temp) {
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            break;
        case 7:
            break;
        case 8:
            break;
        case 9:{
            
        }
            break;
        case 10:{
            
        }
            break;
        case 11:{
            
        }
            break;
        case 12:{
            
        }
            break;
        case 13:{
            
        }
            break;
        case 14:{
            
        }
            break;
        case 15:{
            
        }
            break;
        case 16:{
            
        }
            break;
        case 17:{
            
        }
            break;
        default:
            break;
    }
    
}
@end
