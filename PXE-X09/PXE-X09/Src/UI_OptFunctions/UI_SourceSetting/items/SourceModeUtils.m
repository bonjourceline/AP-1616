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
+ (NSString*)getOutputSpkTypeNameByIndex:(int)index{
    switch (index) {
        case 0: return [LANG DPLocalizedString:@"L_Out_NULL"];
            
        case 1: return [LANG DPLocalizedString:@"L_Out_FL_Tweeter"];
        case 2: return [LANG DPLocalizedString:@"L_Out_FL_Midrange"];
        case 3: return [LANG DPLocalizedString:@"L_Out_FL_Woofer"];
        case 4: return [LANG DPLocalizedString:@"L_Out_FL_M_T"];
        case 5: return [LANG DPLocalizedString:@"L_Out_FL_M_WF"];
        case 6: return [LANG DPLocalizedString:@"L_Out_FL_Full"];
            
        case 7: return [LANG DPLocalizedString:@"L_Out_FR_Tweeter"];
        case 8: return [LANG DPLocalizedString:@"L_Out_FR_Midrange"];
        case 9: return [LANG DPLocalizedString:@"L_Out_FR_Woofer"];
        case 10: return [LANG DPLocalizedString:@"L_Out_FR_M_T"];
        case 11: return [LANG DPLocalizedString:@"L_Out_FR_M_WF"];
        case 12: return [LANG DPLocalizedString:@"L_Out_FR_Full"];
            
        case 13: return [LANG DPLocalizedString:@"L_Out_RL_Tweeter"];
        case 14: return [LANG DPLocalizedString:@"L_Out_RL_Woofer"];
        case 15: return [LANG DPLocalizedString:@"L_Out_RL_Full"];
            
        case 16: return [LANG DPLocalizedString:@"L_Out_RR_Tweeter"];
        case 17: return [LANG DPLocalizedString:@"L_Out_RR_Woofer"];
        case 18: return [LANG DPLocalizedString:@"L_Out_RR_Full"];
            
        case 19: return [LANG DPLocalizedString:@"L_Out_C_Tweeter"];
        case 20: return [LANG DPLocalizedString:@"L_Out_C_Woofer"];
        case 21: return [LANG DPLocalizedString:@"L_Out_C_Full"];
            
        case 22: return [LANG DPLocalizedString:@"L_Out_L_Subweeter"];
        case 23: return [LANG DPLocalizedString:@"L_Out_R_Subweeter"];
        case 24: return [LANG DPLocalizedString:@"L_Out_Subweeter"];
            
        case 25: return [LANG DPLocalizedString:@"L_Out_RL_Midrange"];
        case 26: return [LANG DPLocalizedString:@"L_Out_RR_Midrange"];
        case 27: return [LANG DPLocalizedString:@"L_Out_L_Loop"];
        case 28: return [LANG DPLocalizedString:@"L_Out_R_Loop"];
            
        default: return [LANG DPLocalizedString:@"L_Out_NULL"];
    }
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
    for (int i=0; i<16; i++) {
        RecStructData.System.in_spk_type_temp[i]=RecStructData.System.in_spk_type[i];
    }
    for (int i=0; i<16; i++) {
        RecStructData.System.out_spk_type_temp[i]=RecStructData.System.out_spk_type[i];
    }
}
+(void)syncSource{
    for (int i=0; i<IN_CH_MAX; i++) {
        RecStructData.IN_CH[i].LinkFlag=0;
    }
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
    for (int i=0; i<16; i++) {
        RecStructData.System.in_spk_type[i]=RecStructData.System.in_spk_type_temp[i];
    }
    for (int i=0; i<16; i++) {
        RecStructData.System.out_spk_type[i]=RecStructData.System.out_spk_type_temp[i];
    }
}
+(void)syncOutSource{
  
    RecStructData.System.out_mode=RecStructData.System.out_mode_temp;
   
    RecStructData.System.OutputChNum=RecStructData.System.OutputChNum_temp;
    
    for (int i=0; i<16; i++) {
        RecStructData.System.out_spk_type[i]=RecStructData.System.out_spk_type_temp[i];
    }
    for (int i=0; i<Output_CH_MAX; i++) {
        RecStructData.OUT_CH[i].LinkFlag=0;
    }
}
+(void)setHiModeTypeSetting{
    if (RecStructData.System.InSwitch_temp[3]==0||RecStructData.System.high_mode_temp==0) {
        return;
    }
    switch (RecStructData.System.high_mode_temp) {
        case 1:
            RecStructData.System.HiInputChNum_temp=2;
           
            RecStructData.System.in_spk_type_temp[0]=6;
            RecStructData.System.in_spk_type_temp[1]=12;
            break;
        case 2:
            RecStructData.System.HiInputChNum_temp=4;
            RecStructData.System.in_spk_type_temp[0]=6;
            RecStructData.System.in_spk_type_temp[1]=12;
            RecStructData.System.in_spk_type_temp[2]=15;
            RecStructData.System.in_spk_type_temp[3]=18;
            break;
        case 3:
            RecStructData.System.HiInputChNum_temp=6;
            RecStructData.System.in_spk_type_temp[0]=6;
            RecStructData.System.in_spk_type_temp[1]=12;
            RecStructData.System.in_spk_type_temp[2]=15;
            RecStructData.System.in_spk_type_temp[3]=18;
            RecStructData.System.in_spk_type_temp[4]=24;
            RecStructData.System.in_spk_type_temp[5]=0;
            break;
        case 4:
            RecStructData.System.HiInputChNum_temp=6;
            RecStructData.System.in_spk_type_temp[0]=6;
            RecStructData.System.in_spk_type_temp[1]=12;
            RecStructData.System.in_spk_type_temp[2]=15;
            RecStructData.System.in_spk_type_temp[3]=18;
            RecStructData.System.in_spk_type_temp[4]=22;
            RecStructData.System.in_spk_type_temp[5]=23;
            break;
        case 5:
            RecStructData.System.HiInputChNum_temp=6;
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=3;
            RecStructData.System.in_spk_type_temp[3]=9;
            RecStructData.System.in_spk_type_temp[4]=15;
            RecStructData.System.in_spk_type_temp[5]=18;
            break;
        case 6:
            RecStructData.System.HiInputChNum_temp=8;
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=3;
            RecStructData.System.in_spk_type_temp[3]=9;
            RecStructData.System.in_spk_type_temp[4]=15;
            RecStructData.System.in_spk_type_temp[5]=18;
            RecStructData.System.in_spk_type_temp[6]=24;
             RecStructData.System.in_spk_type_temp[7]=0;
            break;
        case 7:
            RecStructData.System.HiInputChNum_temp=8;
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=3;
            RecStructData.System.in_spk_type_temp[3]=9;
            RecStructData.System.in_spk_type_temp[4]=15;
            RecStructData.System.in_spk_type_temp[5]=18;
            RecStructData.System.in_spk_type_temp[6]=22;
            RecStructData.System.in_spk_type_temp[7]=23;
            break;
        case 8:
            RecStructData.System.HiInputChNum_temp=10;
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=3;
            RecStructData.System.in_spk_type_temp[3]=9;
            RecStructData.System.in_spk_type_temp[4]=15;
            RecStructData.System.in_spk_type_temp[5]=18;
            RecStructData.System.in_spk_type_temp[6]=22;
            RecStructData.System.in_spk_type_temp[7]=23;
            RecStructData.System.in_spk_type_temp[8]=21;
            RecStructData.System.in_spk_type_temp[9]=0;
            break;
        case 9:{
            RecStructData.System.HiInputChNum_temp=8;
            
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=3;
            RecStructData.System.in_spk_type_temp[3]=9;
            RecStructData.System.in_spk_type_temp[4]=15;
            RecStructData.System.in_spk_type_temp[5]=18;
            RecStructData.System.in_spk_type_temp[6]=21;
            RecStructData.System.in_spk_type_temp[7]=24;
        }
            break;
        case 10:{
            RecStructData.System.HiInputChNum_temp=12;
            
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=2;
            RecStructData.System.in_spk_type_temp[3]=8;
            RecStructData.System.in_spk_type_temp[4]=3;
            RecStructData.System.in_spk_type_temp[5]=9;
            RecStructData.System.in_spk_type_temp[6]=13;
            RecStructData.System.in_spk_type_temp[7]=16;
            RecStructData.System.in_spk_type_temp[8]=14;
            RecStructData.System.in_spk_type_temp[9]=17;
            RecStructData.System.in_spk_type_temp[10]=21;
            RecStructData.System.in_spk_type_temp[11]=24;
        }
            break;
        case 11:{
            RecStructData.System.HiInputChNum_temp=14;
            
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=2;
            RecStructData.System.in_spk_type_temp[3]=8;
            RecStructData.System.in_spk_type_temp[4]=3;
            RecStructData.System.in_spk_type_temp[5]=9;
            
            RecStructData.System.in_spk_type_temp[6]=13;
            RecStructData.System.in_spk_type_temp[7]=16;
            RecStructData.System.in_spk_type_temp[8]=14;
            RecStructData.System.in_spk_type_temp[9]=17;
            
            RecStructData.System.in_spk_type_temp[10]=22;
            RecStructData.System.in_spk_type_temp[11]=23;
            RecStructData.System.in_spk_type_temp[12]=21;
            RecStructData.System.in_spk_type_temp[13]=0;
            
        }
            break;
        case 12:{
            RecStructData.System.HiInputChNum_temp=10;
            
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=2;
            RecStructData.System.in_spk_type_temp[3]=8;
            RecStructData.System.in_spk_type_temp[4]=3;
            RecStructData.System.in_spk_type_temp[5]=9;
            
            RecStructData.System.in_spk_type_temp[6]=15;
            RecStructData.System.in_spk_type_temp[7]=18;
            
            RecStructData.System.in_spk_type_temp[8]=21;
            RecStructData.System.in_spk_type_temp[9]=24;
        }
            break;
        case 13:{
            RecStructData.System.HiInputChNum_temp=12;
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=2;
            RecStructData.System.in_spk_type_temp[3]=8;
            RecStructData.System.in_spk_type_temp[4]=3;
            RecStructData.System.in_spk_type_temp[5]=9;
            
            RecStructData.System.in_spk_type_temp[6]=15;
            RecStructData.System.in_spk_type_temp[7]=18;
            
            RecStructData.System.in_spk_type_temp[8]=22;
            RecStructData.System.in_spk_type_temp[9]=23;
            RecStructData.System.in_spk_type_temp[10]=21;
            RecStructData.System.in_spk_type_temp[11]=0;
        }
            break;
        case 14:{
            RecStructData.System.HiInputChNum_temp=10;
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=2;
            RecStructData.System.in_spk_type_temp[3]=8;
            RecStructData.System.in_spk_type_temp[4]=3;
            RecStructData.System.in_spk_type_temp[5]=9;
            
            RecStructData.System.in_spk_type_temp[6]=15;
            RecStructData.System.in_spk_type_temp[7]=18;
            RecStructData.System.in_spk_type_temp[8]=24;
            RecStructData.System.in_spk_type_temp[9]=0;
        }
            break;
        case 15:{
            RecStructData.System.HiInputChNum_temp=10;
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=2;
            RecStructData.System.in_spk_type_temp[3]=8;
            RecStructData.System.in_spk_type_temp[4]=3;
            RecStructData.System.in_spk_type_temp[5]=9;
            
            RecStructData.System.in_spk_type_temp[6]=15;
            RecStructData.System.in_spk_type_temp[7]=18;
            RecStructData.System.in_spk_type_temp[8]=22;
            RecStructData.System.in_spk_type_temp[9]=23;
        }
            break;
        case 16:{
            RecStructData.System.HiInputChNum_temp=16;
            RecStructData.System.AuxInputChNum_temp=0;
            
            RecStructData.System.in_spk_type_temp[0]=1;
            RecStructData.System.in_spk_type_temp[1]=7;
            RecStructData.System.in_spk_type_temp[2]=2;
            RecStructData.System.in_spk_type_temp[3]=8;
            RecStructData.System.in_spk_type_temp[4]=3;
            RecStructData.System.in_spk_type_temp[5]=9;
            
            RecStructData.System.in_spk_type_temp[6]=13;
            RecStructData.System.in_spk_type_temp[7]=16;
            RecStructData.System.in_spk_type_temp[8]=25;
            RecStructData.System.in_spk_type_temp[9]=26;
            RecStructData.System.in_spk_type_temp[10]=14;
            RecStructData.System.in_spk_type_temp[11]=17;
            
            RecStructData.System.in_spk_type_temp[12]=19;
            RecStructData.System.in_spk_type_temp[13]=20;
            RecStructData.System.in_spk_type_temp[14]=22;
            RecStructData.System.in_spk_type_temp[15]=23;
            
        }
            break;
//        case 0:{
//
//        }
            break;
        default:
            break;
    }
    for (int i=0; i<RecStructData.System.HiInputChNum_temp/2; i++) {
        RecStructData.System.high_Low_Set_temp[i]=1;
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
            count=6;
            break;
        case 4:
            count=6;
            break;
        case 5:
            count=6;
            break;
        case 6:
            count=8;
            break;
        case 7:
            count=8;
            break;
        case 8:
            count=10;
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
            count=14;
        }
            break;
        case 12:{
            count=10;
        }
            break;
        case 13:{
            count=12;
        }
            break;
        case 14:{
            count=10;
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
    if (RecStructData.System.InSwitch_temp[4]==0||RecStructData.System.aux_mode_temp==0) {
        return;
    }
    
    int spkIndex=0;
    if (RecStructData.System.InSwitch_temp[3]==1) {
        spkIndex=RecStructData.System.HiInputChNum_temp;
    }
    switch (RecStructData.System.aux_mode_temp) {
        case 1:{
            RecStructData.System.AuxInputChNum_temp=2;
            
            RecStructData.System.in_spk_type_temp[spkIndex]=6;
            RecStructData.System.in_spk_type_temp[spkIndex+1]=12;
        }
            break;
        case 2:{
            RecStructData.System.AuxInputChNum_temp=4;
            RecStructData.System.in_spk_type_temp[spkIndex]=6;
            RecStructData.System.in_spk_type_temp[spkIndex+1]=12;
            RecStructData.System.in_spk_type_temp[spkIndex+2]=15;
            RecStructData.System.in_spk_type_temp[spkIndex+3]=18;
        }
            break;
        case 3:{
            RecStructData.System.AuxInputChNum_temp=6;
            
            RecStructData.System.in_spk_type_temp[spkIndex]=6;
            RecStructData.System.in_spk_type_temp[spkIndex+1]=12;
            RecStructData.System.in_spk_type_temp[spkIndex+2]=15;
            RecStructData.System.in_spk_type_temp[spkIndex+3]=18;
            
             RecStructData.System.in_spk_type_temp[spkIndex+4]=21;
             RecStructData.System.in_spk_type_temp[spkIndex+5]=24;
        }
            break;
        case 4:{
            RecStructData.System.AuxInputChNum_temp=8;
            RecStructData.System.in_spk_type_temp[spkIndex]=6;
            RecStructData.System.in_spk_type_temp[spkIndex+1]=12;
            RecStructData.System.in_spk_type_temp[spkIndex+2]=15;
            RecStructData.System.in_spk_type_temp[spkIndex+3]=18;
            
            RecStructData.System.in_spk_type_temp[spkIndex+4]=21;
            RecStructData.System.in_spk_type_temp[spkIndex+5]=24;
            
            RecStructData.System.in_spk_type_temp[spkIndex+6]=27;
            RecStructData.System.in_spk_type_temp[spkIndex+7]=28;
            
        }
            break;
        default:
            break;
    }
    
    int hiNum=RecStructData.System.HiInputChNum_temp/2;
    for (int i=0; i<RecStructData.System.AuxInputChNum_temp/2; i++) {
        RecStructData.System.high_Low_Set_temp[i+hiNum]=0;
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
    if (RecStructData.System.out_mode_temp==0) {
        return;
    }
    switch (RecStructData.System.out_mode_temp) {
        case 1:
            RecStructData.System.OutputChNum_temp=2;
            
            RecStructData.System.out_spk_type_temp[0]=6;
            RecStructData.System.out_spk_type_temp[1]=12;
            break;
        case 2:
            RecStructData.System.OutputChNum_temp=4;
            RecStructData.System.out_spk_type_temp[0]=6;
            RecStructData.System.out_spk_type_temp[1]=12;
            RecStructData.System.out_spk_type_temp[2]=15;
            RecStructData.System.out_spk_type_temp[3]=18;
            break;
        case 3:
            RecStructData.System.OutputChNum_temp=5;
            RecStructData.System.out_spk_type_temp[0]=6;
            RecStructData.System.out_spk_type_temp[1]=12;
            RecStructData.System.out_spk_type_temp[2]=15;
            RecStructData.System.out_spk_type_temp[3]=18;
            RecStructData.System.out_spk_type_temp[4]=24;

            break;
        case 4:
            RecStructData.System.OutputChNum_temp=6;
            RecStructData.System.out_spk_type_temp[0]=6;
            RecStructData.System.out_spk_type_temp[1]=12;
            RecStructData.System.out_spk_type_temp[2]=15;
            RecStructData.System.out_spk_type_temp[3]=18;
            RecStructData.System.out_spk_type_temp[4]=22;
            RecStructData.System.out_spk_type_temp[5]=23;
            break;
        case 5:
            RecStructData.System.OutputChNum_temp=6;
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=3;
            RecStructData.System.out_spk_type_temp[3]=9;
            RecStructData.System.out_spk_type_temp[4]=15;
            RecStructData.System.out_spk_type_temp[5]=18;
            break;
        case 6:
            RecStructData.System.OutputChNum_temp=7;
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=3;
            RecStructData.System.out_spk_type_temp[3]=9;
            RecStructData.System.out_spk_type_temp[4]=15;
            RecStructData.System.out_spk_type_temp[5]=18;
            RecStructData.System.out_spk_type_temp[6]=24;
            
            break;
        case 7:
            RecStructData.System.OutputChNum_temp=8;
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=3;
            RecStructData.System.out_spk_type_temp[3]=9;
            RecStructData.System.out_spk_type_temp[4]=15;
            RecStructData.System.out_spk_type_temp[5]=18;
            RecStructData.System.out_spk_type_temp[6]=22;
            RecStructData.System.out_spk_type_temp[7]=23;
            break;
        case 8:
            RecStructData.System.OutputChNum_temp=9;
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=3;
            RecStructData.System.out_spk_type_temp[3]=9;
            RecStructData.System.out_spk_type_temp[4]=15;
            RecStructData.System.out_spk_type_temp[5]=18;
            RecStructData.System.out_spk_type_temp[6]=22;
            RecStructData.System.out_spk_type_temp[7]=23;
            RecStructData.System.out_spk_type_temp[8]=21;
            
            break;
        case 9:{
            RecStructData.System.OutputChNum_temp=8;
            
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=3;
            RecStructData.System.out_spk_type_temp[3]=9;
            RecStructData.System.out_spk_type_temp[4]=15;
            RecStructData.System.out_spk_type_temp[5]=18;
            RecStructData.System.out_spk_type_temp[6]=21;
            RecStructData.System.out_spk_type_temp[7]=24;
        }
            break;
        case 10:{
            RecStructData.System.OutputChNum_temp=12;
            
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=2;
            RecStructData.System.out_spk_type_temp[3]=8;
            RecStructData.System.out_spk_type_temp[4]=3;
            RecStructData.System.out_spk_type_temp[5]=9;
            RecStructData.System.out_spk_type_temp[6]=13;
            RecStructData.System.out_spk_type_temp[7]=16;
            RecStructData.System.out_spk_type_temp[8]=14;
            RecStructData.System.out_spk_type_temp[9]=17;
            RecStructData.System.out_spk_type_temp[10]=21;
            RecStructData.System.out_spk_type_temp[11]=24;
        }
            break;
        case 11:{
            RecStructData.System.OutputChNum_temp=13;
            
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=2;
            RecStructData.System.out_spk_type_temp[3]=8;
            RecStructData.System.out_spk_type_temp[4]=3;
            RecStructData.System.out_spk_type_temp[5]=9;
            
            RecStructData.System.out_spk_type_temp[6]=13;
            RecStructData.System.out_spk_type_temp[7]=16;
            RecStructData.System.out_spk_type_temp[8]=14;
            RecStructData.System.out_spk_type_temp[9]=17;
            
            RecStructData.System.out_spk_type_temp[10]=22;
            RecStructData.System.out_spk_type_temp[11]=23;
            RecStructData.System.out_spk_type_temp[12]=21;
            
            
        }
            break;
        case 12:{
            RecStructData.System.OutputChNum_temp=10;
            
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=2;
            RecStructData.System.out_spk_type_temp[3]=8;
            RecStructData.System.out_spk_type_temp[4]=3;
            RecStructData.System.out_spk_type_temp[5]=9;
            
            RecStructData.System.out_spk_type_temp[6]=15;
            RecStructData.System.out_spk_type_temp[7]=18;
            
            RecStructData.System.out_spk_type_temp[8]=21;
            RecStructData.System.out_spk_type_temp[9]=24;
        }
            break;
        case 13:{
            RecStructData.System.OutputChNum_temp=11;
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=2;
            RecStructData.System.out_spk_type_temp[3]=8;
            RecStructData.System.out_spk_type_temp[4]=3;
            RecStructData.System.out_spk_type_temp[5]=9;
            
            RecStructData.System.out_spk_type_temp[6]=15;
            RecStructData.System.out_spk_type_temp[7]=18;
            
            RecStructData.System.out_spk_type_temp[8]=22;
            RecStructData.System.out_spk_type_temp[9]=23;
            RecStructData.System.out_spk_type_temp[10]=21;
            
        }
            break;
        case 14:{
            RecStructData.System.OutputChNum_temp=9;
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=2;
            RecStructData.System.out_spk_type_temp[3]=8;
            RecStructData.System.out_spk_type_temp[4]=3;
            RecStructData.System.out_spk_type_temp[5]=9;
            
            RecStructData.System.out_spk_type_temp[6]=15;
            RecStructData.System.out_spk_type_temp[7]=18;
            RecStructData.System.out_spk_type_temp[8]=24;
            
        }
            break;
        case 15:{
            RecStructData.System.OutputChNum_temp=10;
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=2;
            RecStructData.System.out_spk_type_temp[3]=8;
            RecStructData.System.out_spk_type_temp[4]=3;
            RecStructData.System.out_spk_type_temp[5]=9;
            
            RecStructData.System.out_spk_type_temp[6]=15;
            RecStructData.System.out_spk_type_temp[7]=18;
            RecStructData.System.out_spk_type_temp[8]=22;
            RecStructData.System.out_spk_type_temp[9]=23;
        }
            break;
        case 16:{
            RecStructData.System.OutputChNum_temp=16;
            
            RecStructData.System.out_spk_type_temp[0]=1;
            RecStructData.System.out_spk_type_temp[1]=7;
            RecStructData.System.out_spk_type_temp[2]=2;
            RecStructData.System.out_spk_type_temp[3]=8;
            RecStructData.System.out_spk_type_temp[4]=3;
            RecStructData.System.out_spk_type_temp[5]=9;
            
            RecStructData.System.out_spk_type_temp[6]=13;
            RecStructData.System.out_spk_type_temp[7]=16;
            RecStructData.System.out_spk_type_temp[8]=25;
            RecStructData.System.out_spk_type_temp[9]=26;
            RecStructData.System.out_spk_type_temp[10]=14;
            RecStructData.System.out_spk_type_temp[11]=17;
            
            RecStructData.System.out_spk_type_temp[12]=19;
            RecStructData.System.out_spk_type_temp[13]=20;
            RecStructData.System.out_spk_type_temp[14]=22;
            RecStructData.System.out_spk_type_temp[15]=23;
            
        }
            break;

            break;
        default:
            break;
    }
   
}
+(int)getMaxInputChannel{
    int maxChannel=0;
    NSMutableArray * threeCells =[[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        if (RecStructData.System.InSwitch[i]!=0) {
            [threeCells addObject:@(i)];
        }
    }
   
    maxChannel=3;
    if (RecStructData.System.InSwitch[3]!=0) {
        maxChannel=maxChannel+RecStructData.System.HiInputChNum;
    }
    if (RecStructData.System.InSwitch[4]!=0) {
        maxChannel=maxChannel+RecStructData.System.AuxInputChNum;
    }
    return maxChannel;
}
@end
