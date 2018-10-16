//
//  EQView.m
//  KP-DBP410-CF-A10S
//
//  Created by chsdsp on 2017/3/29.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "EQView.h"
#import "Dimens.h"
#import "Define_Color.h"
@implementation EQView

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
    self.backgroundColor = [UIColor clearColor];
    //曲线框的边距
    marginLeft   = [Dimens GDimens:30];
    marginRight  = [Dimens GDimens:10];
    marginTop    = [Dimens GDimens:15];
    marginBottom = [Dimens GDimens:25];
    frameWidth   = WIND_Width-marginRight-marginLeft;
    frameHeight  = WIND_Height-marginBottom - marginTop;
    
    EQView_Frame_Color   = SetColor(Color_EQView_Frame);   //EQ边框颜色
    EQView_Text_Color    = SetColor(Color_EQView_Text);    //EQ文本颜色
    EQView_MidLine_Color = SetColor(Color_EQView_MidLine); //EQ中线颜色
    EQView_EQLine_Color  = SetColor(Color_EQView_EQLine);  //EQ曲线颜色
    clearColor  = SetColor(UI_SystemClearColor);
    //各种线宽
    LineWidthOf_Frame   = 2;
    LineWidthOf_InFrame = LineWidthOf_Frame/2;
    LineWidthOf_MidLine = LineWidthOf_Frame/2;
    LineWidthOf_EQLine  = LineWidthOf_Frame;
    
    //X轴的划分
    //分3大分，再分9小分
    x3Base=marginLeft;
    x3Tap =frameWidth/3;
    
    xTap1=x3Tap*3/10*3/5;
    xTap2=x3Tap*3/10*2/5;
    xTap3=x3Tap*4/10*1/4;
    xTap4=x3Tap*4/10*1/5;
    xTap5=x3Tap*4/10*1/6;
    xTap6=x3Tap*4/10*1/7;
    xTap7=x3Tap*4/10*1/8;
    xTap8=x3Tap*4/10*1/9;
    xTap9=x3Tap*3/10;
    
    TV_Freq0 = [NSArray arrayWithObjects:@"30",@"40",@"50",@"",@"70",@"",@"",@"100",@"200", nil];
    TV_Freq1 = [NSArray arrayWithObjects:@"300",@"",@"500",@"",@"700",@"",@"",@"1k",@"2k", nil];
    TV_Freq2 = [NSArray arrayWithObjects:@"3k",@"4k",@"5k",@"",@"7k",@"",@"",@"10k",@"20k", nil];
    TV_DB    = [NSArray arrayWithObjects:@"+20",@"",@"+10",@"",@"0dB",@"",@"-10",@"",@"-20", nil];
    TV_DB0   = [NSArray arrayWithObjects:@"+20",@"",@"+10",@"",@"0dB",@"",@"-10",@"",@"-20", nil];
    TV_DB1   = [NSArray arrayWithObjects:@"+12",@"+9",@"+6",@"+3",@"0dB",@"-3",@"-6",@"-9",@"-12", nil];
    
    //    TV_Freq0 = [NSArray arrayWithObjects:@"",@"",@"50",@"",@"",@"",@"",@"100",@"200", nil];
    //    TV_Freq1 = [NSArray arrayWithObjects:@"",@"",@"500",@"",@"",@"",@"",@"1k",@"2k", nil];
    //    TV_Freq2 = [NSArray arrayWithObjects:@"",@"",@"5k",@"",@"",@"",@"",@"10k",@"20k", nil];
    //    TV_DB    = [NSArray arrayWithObjects:@"+20",@"",@"+10",@"",@"0dB",@"",@"-10",@"",@"-20", nil];
    //    TV_DB0   = [NSArray arrayWithObjects:@"+20",@"",@"+10",@"",@"0dB",@"",@"-10",@"",@"-20", nil];
    //    //TV_DB1   = [NSArray arrayWithObjects:@"+12",@"+9",@"+6",@"+3",@"0dB",@"-3",@"-6",@"-9",@"-12", nil];
    //    TV_DB1   = [NSArray arrayWithObjects:@"+12",@"",@"+6",@"",@"0dB",@"",@"-6",@"",@"-12", nil];
    if(EQ_Gain_MAX != 400){
        TV_DB = TV_DB1;
    }
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //画边框
    [self drawFrame];
    [self drawMidLine];
    //画边框标识
    [self drawFrameText];
    //画边框标识
    [self DrawEQLine];
    
    [self drawFrameRec];
    
    
}
#pragma 子函数

- (void)drawFrameRec{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, EQView_Frame_Color.CGColor);//线条颜色
    CGContextSetLineWidth(context, LineWidthOf_Frame);
    CGContextAddRect(context, CGRectMake(marginLeft, marginTop, frameWidth, frameHeight));
    CGContextStrokePath(context);
}
- (void)drawMidLine{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, LineWidthOf_Frame);
    float tl=frameHeight/8;
    float Right = WIND_Width - marginRight;
    CGContextSetStrokeColorWithColor(context, EQView_MidLine_Color.CGColor);//线条颜色
    CGContextMoveToPoint(context,marginLeft, marginTop+tl*4);
    CGContextAddLineToPoint(context,Right, marginTop+tl*4);
    CGContextStrokePath(context);
}
//画边框
- (void)drawFrame{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, EQView_Frame_Color.CGColor);//线条颜色
    CGContextSetLineWidth(context, LineWidthOf_Frame);
    CGContextAddRect(context, CGRectMake(marginLeft, marginTop, frameWidth, frameHeight));
    
    //画横线
    CGContextSetStrokeColorWithColor(context, EQView_Frame_Color.CGColor);//线条颜色
    float tl=frameHeight/8;
    float Right = WIND_Width - marginRight;
    for(int i=1;i<=7;i++){
        if(i==4){
            CGContextSetStrokeColorWithColor(context, EQView_MidLine_Color.CGColor);//线条颜色
            CGContextSetLineWidth(context, LineWidthOf_MidLine);
        }else{
            CGContextSetStrokeColorWithColor(context, EQView_Frame_Color.CGColor);//线条颜色
            CGContextSetLineWidth(context, LineWidthOf_InFrame);
        }
        CGContextMoveToPoint(context,marginLeft, marginTop+tl*i);
        CGContextAddLineToPoint(context,Right, marginTop+tl*i);
    }
    float x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,base;
    //画竖线
    float Bottom = WIND_Height - marginBottom;
    for(int i=0;i<=2;i++){
        base=x3Tap*i;
        x0=marginLeft+base;
        x1=xTap1+x0;
        x2=xTap2+x1;
        x3=xTap3+x2;
        x4=xTap4+x3;
        x5=xTap5+x4;
        x6=xTap6+x5;
        x7=xTap7+x6;
        x8=xTap8+x7;
        x9=xTap9+x8;
        
        CGContextMoveToPoint(context,x1, marginTop);
        CGContextAddLineToPoint(context,x1, Bottom);
        
        CGContextMoveToPoint(context,x2, marginTop);
        CGContextAddLineToPoint(context,x2, Bottom);
        
        CGContextMoveToPoint(context,x3, marginTop);
        CGContextAddLineToPoint(context,x3, Bottom);
        
        CGContextMoveToPoint(context,x4, marginTop);
        CGContextAddLineToPoint(context,x4, Bottom);
        
        CGContextMoveToPoint(context,x5, marginTop);
        CGContextAddLineToPoint(context,x5, Bottom);
        
        CGContextMoveToPoint(context,x6, marginTop);
        CGContextAddLineToPoint(context,x6, Bottom);
        
        CGContextMoveToPoint(context,x7, marginTop);
        CGContextAddLineToPoint(context,x7, Bottom);
        
        CGContextMoveToPoint(context,x8, marginTop);
        CGContextAddLineToPoint(context,x8, Bottom);
        
        CGContextMoveToPoint(context,x9, marginTop);
        CGContextAddLineToPoint(context,x9, Bottom);
    }
    CGContextStrokePath(context);
}
- (void)drawFrameText{
    float tap=frameHeight/8;
    float tlstartY = marginTop-tap/2;
    
    UIFont  *font = [UIFont boldSystemFontOfSize:8.0];//设置
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* attribute = @{
                                NSForegroundColorAttributeName: EQView_Text_Color,
                                NSFontAttributeName:font,
                                NSParagraphStyleAttributeName:paragraphStyle
                                };
    for (int i = 0; i<9; i++) {
        [TV_DB[i] drawWithRect:CGRectMake(0, tlstartY+i*tap,marginLeft, tap)
                       options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:attribute
                       context:nil];
    }
    font = [UIFont boldSystemFontOfSize:8.0];//设置
    attribute = @{
                  NSForegroundColorAttributeName: EQView_Text_Color,
                  NSFontAttributeName:font,
                  NSParagraphStyleAttributeName:paragraphStyle
                  };
    
    tlstartY = WIND_Height-marginBottom;
    [@"20" drawWithRect:CGRectMake(marginLeft/2, tlstartY,marginLeft, marginBottom)
                options:NSStringDrawingUsesLineFragmentOrigin
             attributes:attribute
                context:nil];
    float x[9]={0};
    for(int i=0;i<=2;i++){
        x3Base=x3Tap*i+marginLeft/2;
        x[0]=x3Base+xTap1;
        x[1]=xTap2+x[0];
        x[2]=xTap3+x[1];
        x[3]=xTap4+x[2];
        x[4]=xTap5+x[3];
        x[5]=xTap6+x[4];
        x[6]=xTap7+x[5];
        x[7]=xTap8+x[6];
        x[8]=xTap9+x[7];
        if(i==0){
            for(int j=0;j<9;j++){
                [TV_Freq0[j] drawWithRect:CGRectMake(x[j], tlstartY,marginLeft, marginBottom)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attribute
                                  context:nil];
            }
        }else if(i==1){
            for(int j=0;j<9;j++){
                [TV_Freq1[j] drawWithRect:CGRectMake(x[j], tlstartY,marginLeft, marginBottom)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attribute
                                  context:nil];
            }
        }else if(i==2){
            for(int j=0;j<9;j++){
                [TV_Freq2[j] drawWithRect:CGRectMake(x[j], tlstartY,marginLeft, marginBottom)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attribute
                                  context:nil];
            }
            
        }
    }
}

- (void) DrawEQLine{
    [self ComposePoint];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*画seekbar弧BGProgress*/
    CGContextSetStrokeColorWithColor(context, EQView_EQLine_Color.CGColor);
    CGContextSetLineWidth(context, LineWidthOf_EQLine);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextBeginPath(context);
    
    for(int i=0; i<240;i++){
        //        NSLog(@"m_nPointY=%f",m_nPointY[i]);
        //起点坐标
        CGContextMoveToPoint(context,m_nPointX[i], m_nPointY[i]);
        //终点坐标
        CGContextAddLineToPoint(context,m_nPointX[i+1], m_nPointY[i+1]);
    }
    CGContextStrokePath(context);
    
    //重画外框
    CGContextSetStrokeColorWithColor(context, EQView_Frame_Color.CGColor);//线条颜色
    CGContextSetLineWidth(context, LineWidthOf_Frame);
    CGContextAddRect(context, CGRectMake(marginLeft, marginTop, frameWidth, frameHeight));
}

#pragma 画EQ线
//把各点组合成曲线
- (void)ComposePoint{
    //把EQ，高低通滤波器累加
    for(int i=0;i<241;i++){
        m_nPoint[i]=0;
        for(int j=0;j<MaxEQ;j++){
            m_nPoint[i]+=m_nPointPEQ[j][i];
        }
        m_nPoint[i]+=m_nPointHP[i];
        m_nPoint[i]+=m_nPointLP[i];
    }
    
    double MidY = marginTop+(WIND_Height-marginTop-marginBottom)/2;
    //计算出各占坐标
    double step=(double)frameHeight / (double)EQ_Gain_MAX;//每个DP对应多少个高度的点数
    double stepx=frameWidth/240.0;//(double)(line_end-line_start);
    for(int i=0;i<241;i++){
        m_nPointY[i]=MidY-m_nPoint[i]*10.0*step;
        m_nPointX[i]=i*stepx+marginLeft;
        //if(!bool_HideBg){
        if(m_nPointY[i]>(WIND_Height-marginBottom)){
            m_nPointY[i]=(WIND_Height-marginBottom);
        }else if(m_nPointY[i]<(marginTop)){
            m_nPointY[i]=marginTop;
        }
        //}
    }
}

- (void)SetEQData:(struct output_Struct)SyncEQ {
    INS_OUT = true;
    MaxEQ = Output_CH_EQ_MAX_USE;
    for(int j=0;j<MaxEQ;j++){
        //        NSLog(@"############################");
        EQ_Filter.EQ[j].freq  = SyncEQ.EQ[j].freq;
        EQ_Filter.EQ[j].level = SyncEQ.EQ[j].level;
        EQ_Filter.EQ[j].bw    = SyncEQ.EQ[j].bw;
        EQ_Filter.EQ[j].shf_db= SyncEQ.EQ[j].shf_db;
        EQ_Filter.EQ[j].type  = SyncEQ.EQ[j].type;
        //        NSLog(@"EQ.%d,EQ_Filter.EQ.freq=%d",j,EQ_Filter.EQ[j].freq);
        //        NSLog(@"EQ.%d,EQ_Filter.EQ.level=%d",j,EQ_Filter.EQ[j].level);
        //        NSLog(@"EQ.%d,EQ_Filter.EQ.bw=%d",j,EQ_Filter.EQ[j].bw);
    }
    
    EQ_Filter.h_freq   = SyncEQ.h_freq;
    EQ_Filter.h_filter = SyncEQ.h_filter;
    EQ_Filter.h_level  = SyncEQ.h_level;
    EQ_Filter.l_freq   = SyncEQ.l_freq;
    EQ_Filter.l_filter = SyncEQ.l_filter;
    EQ_Filter.l_level  = SyncEQ.l_level;
    //    NSLog(@"--------------------------------------");
    //    NSLog(@"EQ_Filter.h_freq=%d",EQ_Filter.h_freq);
    //    NSLog(@"EQ_Filter.h_filter=%d",EQ_Filter.h_filter);
    //    NSLog(@"EQ_Filter.h_level=%d",EQ_Filter.h_level);
    //    NSLog(@"EQ_Filter.l_freq=%d",EQ_Filter.l_freq);
    //    NSLog(@"EQ_Filter.l_filter=%d",EQ_Filter.l_filter);
    //    NSLog(@"EQ_Filter.l_level=%d",EQ_Filter.l_level);
    
    [self UpdateEQFilter];
}
-(void)SetINEQData:(struct input_Struct)SyncEQ {
    MaxEQ = IN_CH_EQ_MAX_USE;
    for(int j=0;j<MaxEQ;j++){
        //        NSLog(@"############################");
        EQ_Filter.EQ[j].freq  = SyncEQ.EQ[j].freq;
        EQ_Filter.EQ[j].level = SyncEQ.EQ[j].level;
        EQ_Filter.EQ[j].bw    = SyncEQ.EQ[j].bw;
        EQ_Filter.EQ[j].shf_db= SyncEQ.EQ[j].shf_db;
        EQ_Filter.EQ[j].type  = SyncEQ.EQ[j].type;
        //        NSLog(@"EQ.%d,EQ_Filter.EQ.freq=%d",j,EQ_Filter.EQ[j].freq);
        //        NSLog(@"EQ.%d,EQ_Filter.EQ.level=%d",j,EQ_Filter.EQ[j].level);
        //        NSLog(@"EQ.%d,EQ_Filter.EQ.bw=%d",j,EQ_Filter.EQ[j].bw);
    }
    
    EQ_Filter.h_freq   = SyncEQ.h_freq;
    EQ_Filter.h_filter = SyncEQ.h_filter;
    EQ_Filter.h_level  = SyncEQ.h_level;
    EQ_Filter.l_freq   = SyncEQ.l_freq;
    EQ_Filter.l_filter = SyncEQ.l_filter;
    EQ_Filter.l_level  = SyncEQ.l_level;
    //    NSLog(@"--------------------------------------");
    //    NSLog(@"EQ_Filter.h_freq=%d",EQ_Filter.h_freq);
    //    NSLog(@"EQ_Filter.h_filter=%d",EQ_Filter.h_filter);
    //    NSLog(@"EQ_Filter.h_level=%d",EQ_Filter.h_level);
    //    NSLog(@"EQ_Filter.l_freq=%d",EQ_Filter.l_freq);
    //    NSLog(@"EQ_Filter.l_filter=%d",EQ_Filter.l_filter);
    //    NSLog(@"EQ_Filter.l_level=%d",EQ_Filter.l_level);
    
    [self UpdateEQFilter];
}

- (void)SetINSEQData:(struct inputs_Struct)SyncEQ {
    INS_OUT = false;
    MaxEQ = INS_CH_EQ_MAX_USE;
    for(int j=0;j<MaxEQ;j++){
        //        NSLog(@"############################");
        EQ_Filter.EQ[j].freq  = SyncEQ.EQ[j].freq;
        EQ_Filter.EQ[j].level = SyncEQ.EQ[j].level;
        EQ_Filter.EQ[j].bw    = SyncEQ.EQ[j].bw;
        EQ_Filter.EQ[j].shf_db= SyncEQ.EQ[j].shf_db;
        EQ_Filter.EQ[j].type  = SyncEQ.EQ[j].type;
        //        NSLog(@"EQ.%d,EQ_Filter.EQ.freq=%d",j,EQ_Filter.EQ[j].freq);
        //        NSLog(@"EQ.%d,EQ_Filter.EQ.level=%d",j,EQ_Filter.EQ[j].level);
        //        NSLog(@"EQ.%d,EQ_Filter.EQ.bw=%d",j,EQ_Filter.EQ[j].bw);
    }
    
    EQ_Filter.h_freq   = SyncEQ.h_freq;
    EQ_Filter.h_filter = SyncEQ.h_filter;
    EQ_Filter.h_level  = SyncEQ.h_level;
    EQ_Filter.l_freq   = SyncEQ.l_freq;
    EQ_Filter.l_filter = SyncEQ.l_filter;
    EQ_Filter.l_level  = SyncEQ.l_level;
    //    NSLog(@"--------------------------------------");
    //    NSLog(@"EQ_Filter.h_freq=%d",EQ_Filter.h_freq);
    //    NSLog(@"EQ_Filter.h_filter=%d",EQ_Filter.h_filter);
    //    NSLog(@"EQ_Filter.h_level=%d",EQ_Filter.h_level);
    //    NSLog(@"EQ_Filter.l_freq=%d",EQ_Filter.l_freq);
    //    NSLog(@"EQ_Filter.l_filter=%d",EQ_Filter.l_filter);
    //    NSLog(@"EQ_Filter.l_level=%d",EQ_Filter.l_level);
    
    [self UpdateEQFilter];
}


- (struct output_Struct) GetEQData {
    for(int j=0;j<MaxEQ;j++){
        ReadEQ.EQ[j].freq  = EQ_Filter.EQ[j].freq;
        ReadEQ.EQ[j].level = EQ_Filter.EQ[j].level;
        ReadEQ.EQ[j].bw    = EQ_Filter.EQ[j].bw;
        ReadEQ.EQ[j].shf_db= EQ_Filter.EQ[j].shf_db;
        ReadEQ.EQ[j].type  = EQ_Filter.EQ[j].type;
    }
    
    ReadEQ.h_freq   = EQ_Filter.h_freq;
    ReadEQ.h_filter = EQ_Filter.h_filter;
    ReadEQ.h_level  = EQ_Filter.h_level;
    ReadEQ.l_freq   = EQ_Filter.l_freq;
    ReadEQ.l_filter = EQ_Filter.l_filter;
    ReadEQ.l_level  = EQ_Filter.l_level;
    
    return ReadEQ;
}
/*
 * 高通滤波器更新
 *
 */
- (void)UpdateEQFilter{
    [self UpDataHPF];
    [self UpDataLPF];
    for(int i=0;i<MaxEQ;i++){
        [self UpDataPEQ:i];
    }
    [self setNeedsDisplay];
}


/*
 * 高通滤波器更新
 *
 */
- (void)UpDataHPF{
    int    i;
    double HPF_FsPi,f,HPF_Wf;
    double w0;
    double HPF_fre;
    int       HPF_type,HPF_oct;
    double HPF_Q[4];
    
    double temp_a0[4];
    double temp_a1[4];
    double temp_a2[4];
    
    double temp_b0[4];
    double temp_b1[4];
    double temp_b2[4];
    
    double w0_cValue,w0_sValue,w_h,alph_h,alphah;
    double a1,a2,b1,b2,b3,A,B,C,D,EE,tmp;
    tmp    =    0.0;
    HPF_fre       = EQ_Filter.h_freq;
    HPF_type   = EQ_Filter.h_filter;
    int m_nOct = EQ_Filter.h_level;
    BOOL m_nDataType = true;
    if(m_nDataType){
        if(m_nOct==0){
            HPF_oct    =    m_nOct+1;
        }else{
            HPF_oct    =    m_nOct;
        }
    }else{
        HPF_oct    =    m_nOct;
        if(HPF_type    == Bessel){
            /*if(HPF_oct ==    Oct_36dB){
             HPF_oct    =    Oct_42dB;
             }else{
             if(HPF_oct ==    Oct_42dB){
             HPF_oct    =    Oct_36dB;
             }
             }*/
            switch(HPF_oct){
                case Oct_30dB:
                    HPF_oct    =    Oct_42dB;
                    break;
                case Oct_36dB:
                    HPF_oct    =    Oct_48dB;
                    break;
                case Oct_42dB:
                    HPF_oct    =    Oct_30dB;
                    break;
                case Oct_48dB:
                    HPF_oct    =    Oct_36dB;
                    break;
            }
        }
    }
    HPF_FsPi = 0.00006544985;
    switch(HPF_oct){
        case Oct_6dB:
        case Oct_12dB:
            if(HPF_type    == L_R){
                HPF_Q[0] = 1.0;
                HPF_Q[1] = 0.0;
                HPF_Q[2] = 0.0;
                HPF_Q[3] = 0.0;
            }
            if(HPF_type    == ButtWorth){
                HPF_Q[0] = 0.70422535;
                HPF_Q[1] = 0.0;
                HPF_Q[2] = 0.0;
                HPF_Q[3] = 0.0;
            }
            if(HPF_type    == Bessel){
                HPF_Q[0] = 0.70422535;
                HPF_Q[1] = 0.0;
                HPF_Q[2] = 0.0;
                HPF_Q[3] = 0.0;
                HPF_fre    =    HPF_fre/1.2683112435;
            }
            break;
        case Oct_18dB:
            if(HPF_type    == L_R){
                HPF_Q[0] = 1.0;
                HPF_Q[1] = 0.70422535211;
                HPF_Q[2] = 0.0;
                HPF_Q[3] = 0.0;
            }
            if(HPF_type    == ButtWorth){
                HPF_Q[0] = 1.0;
                HPF_Q[1] = 0.5;
                HPF_Q[2] = 0.0;
                HPF_Q[3] = 0.0;
            }
            if(HPF_type    == Bessel){
                HPF_Q[0] = 0.7560;
                HPF_Q[1] = 0.72463768;
                HPF_Q[2] = 0.0;
                HPF_Q[3] = 0.0;
                HPF_fre    =    HPF_fre/1.2854981442;
            }
            break;
        case Oct_24dB:
            if(HPF_type    == L_R){
                HPF_Q[0] = 0.70422535211;
                HPF_Q[1] = 0.70422535211;
                HPF_Q[2] = 0.0;
                HPF_Q[3] = 0.0;
            }
            if(HPF_type    == ButtWorth){
                HPF_Q[0] = 0.92592593;
                HPF_Q[1] = 0.38167939;
                HPF_Q[2] = 0.0;
                HPF_Q[3] = 0.0;
            }
            if(HPF_type    == Bessel){
                HPF_Q[0] = 0.96153846;
                HPF_Q[1] = 0.61728395;
                HPF_Q[2] = 0.0;
                HPF_Q[3] = 0.0;
                HPF_fre    =    HPF_fre/1.5006420029;
            }
            break;
        case Oct_30dB:
            if(    HPF_type==L_R){
                HPF_Q[0]=1.0;
                HPF_Q[1]=0.62;
                HPF_Q[2]=0.62;
                HPF_Q[3]=0.0;
            }
            if(    HPF_type==ButtWorth){
                HPF_Q[0]=1.0;
                HPF_Q[1]=0.8064616129;
                HPF_Q[2]=0.3086417953;
                HPF_Q[3]=0.0;
            }
            if(    HPF_type==Bessel){
                HPF_Q[0]=0.6656;
                HPF_Q[1]=0.8928571428;
                HPF_Q[2]=0.54347826;
                HPF_Q[3]=0.0;
                HPF_fre    =    HPF_fre    /    1.3854981442;
            }
            break;
        case Oct_36dB:
            if(    HPF_type==L_R){
                HPF_Q[0]=1.0;
                HPF_Q[1]=0.5;
                HPF_Q[2]=0.5;
                HPF_Q[3]=0.0;
            }
            if(    HPF_type==ButtWorth){
                HPF_Q[0]=0.96153846;
                HPF_Q[1]=0.70422535211;
                HPF_Q[2]=0.2590673575;
                HPF_Q[3]=0.0;
            }
            if(    HPF_type==Bessel){
                HPF_Q[0]=0.980392156;
                HPF_Q[1]=0.819672131;
                HPF_Q[2]=0.490196;
                HPF_Q[3]=0.0;
                HPF_fre    =    HPF_fre    /    1.5554981442;
            }
            break;
        case Oct_42dB:
            if(    HPF_type==L_R){
                HPF_Q[0]=1.0;
                HPF_Q[1]=0.4531343150;
                HPF_Q[2]=0.92592592593;
                HPF_Q[3]=0.4531343150;
            }
            if(    HPF_type==ButtWorth){
                HPF_Q[0]=1.0;
                HPF_Q[1]=0.90909090909;
                HPF_Q[2]=0.625;
                HPF_Q[3]=0.2222222222;
            }
            if(    HPF_type==Bessel){
                HPF_Q[0]=0.5937;
                HPF_Q[1]=0.943396226415;
                HPF_Q[2]=0.757575757576;
                HPF_Q[3]=0.4424778761;
                HPF_fre    =    HPF_fre    /    1.5554981442;
            }
            break;
        case Oct_48dB:
            if(HPF_type    == L_R){
                HPF_Q[0] = 0.92592592593;
                HPF_Q[1] = 0.3731343150;
                HPF_Q[2] = 0.92592592593;
                HPF_Q[3] = 0.3731343150;
            }
            if(HPF_type    == ButtWorth){
                HPF_Q[0] = 0.98039126;
                HPF_Q[1] = 0.83333333;
                HPF_Q[2] = 0.55555556;
                HPF_Q[3] = 0.1953125;
            }
            if(HPF_type    == Bessel){
                HPF_Q[0] = 0.98039216;
                HPF_Q[1] = 0.89285714;
                HPF_Q[2] = 0.70422535;
                HPF_Q[3] = 0.40650406;
                HPF_fre    =    HPF_fre/1.6791201410;
                
            }
            break;
    }
    w0 = HPF_FsPi    *    HPF_fre;
    w0_cValue    =    cos(w0);
    w0_sValue    =    sin(w0);
    w_h    =    w0*0.5;
    alph_h = tan(w_h);
    for(i=0;i<4;i++){
        alphah = w0_sValue * HPF_Q[i];
        if(HPF_Q[i]    == 0){
            temp_a0[i] = 1;
            temp_a1[i] = 0;
            temp_a2[i] = 0;
            temp_b0[i] = 1;
            temp_b1[i] = 0;
            temp_b2[i] = 0;
        }else{
            temp_a0[i] = 1+alphah;
            if(temp_a0[i]    == 0){
                temp_a0[i] = 0.0000000001;
            }
            temp_a1[i] = -2.0*w0_cValue;
            temp_a2[i] = 1-alphah;
            temp_b0[i] = (1+w0_cValue)*0.5;
            temp_b1[i] = -2.0*temp_b0[i];
            temp_b2[i] = temp_b0[i];
        }
    }
    //        if(HPF_oct ==    Oct_18dB|| HPF_oct ==    Oct_30dB ||    HPF_oct    == Oct_42dB){
    //            temp_a0[0] = HPF_Q[0]*alph_h+1;
    //            if(temp_a0[0]    == 0)    temp_a0[0] =0.0000000001;
    //            temp_a1[0] = HPF_Q[0]*alph_h-1;
    //            temp_a2[0] = 0.0;
    //            temp_b0[0] = 1.0;
    //            temp_b1[0] = -1.0;
    //            temp_b2[0] = 0.0;
    //        }
    if(HPF_oct == Oct_18dB|| HPF_oct == Oct_30dB || HPF_oct == Oct_42dB || HPF_oct == Oct_6dB)
    {
        temp_a0[0] = HPF_Q[0]*alph_h+1;
        if(temp_a0[0] == 0) temp_a0[0] =0.0000000001;
        temp_a1[0] = HPF_Q[0]*alph_h-1;
        temp_a2[0] = 0.0;
        temp_b0[0] = 1.0;
        temp_b1[0] = -1.0;
        temp_b2[0] = 0.0;
    }
    
    for(int    j=0;j< 241;j++){
        f    =    FREQ241[j];
        HPF_Wf = 2*pi*f/FS;
        for(i=0;i<4;i++){
            a1 = temp_a1[i]/temp_a0[i];
            a2 = temp_a2[i]/temp_a0[i];
            
            b1 = temp_b0[i]/temp_a0[i];
            b2 = temp_b1[i]/temp_a0[i];
            b3 = temp_b2[i]/temp_a0[i];
            A    =    cos(HPF_Wf)+a1+a2*cos(HPF_Wf);
            B    =    sin(HPF_Wf)-a2*sin(HPF_Wf);
            C    =    b1*cos(HPF_Wf)+b2+b3*cos(HPF_Wf);
            D    =    b1*sin(HPF_Wf)-b3*sin(HPF_Wf);
            EE  =   sqrt((C*C+D*D)/(A*A+B*B));
            tmp    =    tmp    +20*log10(EE);
        }
        if(EQ_Filter.h_freq!=20){
            m_nPointHP[j]    =    tmp;
        }
        tmp    =    0;
    }
    if((EQ_Filter.h_freq==20)||(EQ_Filter.h_level==HL_OFF)){
        for(int    j=0;j< 241;j++){
            m_nPointHP[j]    =    0;
        }
    }
    
}
/*
 * 低通滤波器更新
 *
 */
- (void) UpDataLPF{
    int    i;
    double LPF_FsPi,f;
    double w0;
    double LPF_fre;
    int    LPF_type,LPF_oct;
    double alphal1,alphal2;
    double Bessel_LPF_Qa[4];
    double Bessel_LPF_Qb[4];
    double temp_bi,temp_ai;
    double temp_a0[4];
    double temp_a1[4];
    double temp_a2[4];
    double temp_b0[4];
    double temp_b1[4];
    double temp_b2[4];
    double LPF_Q[4];
    double a1,a2,b1,b2,b3;
    double A,B,C,D,EE,tmp;
    double w0_cValue,w0_sValue,w_l,alph_l,alphal;
    double LPF_Wf;
    tmp    =    0;
    LPF_fre     =    EQ_Filter.l_freq;
    LPF_type =  EQ_Filter.l_filter;
    int m_nOct =  EQ_Filter.l_level;
    BOOL m_nDataType=false;
    if(m_nDataType){
        if(m_nOct    == 1){
            LPF_oct = m_nOct+1;
        }else{
            LPF_oct = m_nOct;
        }
    }else{
        LPF_oct    =    m_nOct;
    }
    LPF_FsPi = 0.00006544985;
    if(    LPF_type ==    Bessel ){
        /*
         if(LPF_oct ==    Oct_36dB){
         LPF_oct = Oct_42dB;
         }else{
         if(LPF_oct ==    Oct_42dB){
         LPF_oct = Oct_36dB;
         }
         }*/
        switch(LPF_oct){
            case Oct_30dB:
                LPF_oct    =    Oct_48dB;
                break;
            case Oct_36dB:
                LPF_oct    =    Oct_42dB;
                break;
            case Oct_42dB:
                LPF_oct    =    Oct_30dB;
                break;
            case Oct_48dB:
                LPF_oct    =    Oct_36dB;
                break;
        }
        switch(LPF_oct){
            case Oct_6dB:
            case Oct_12dB:
                LPF_fre    =    LPF_fre/1.3616541287;
                Bessel_LPF_Qa[0] = 1.0;
                Bessel_LPF_Qb[0] = 0.3333333333;
                
                Bessel_LPF_Qa[1] = 0.0;
                Bessel_LPF_Qb[1] = 0.0;
                
                Bessel_LPF_Qa[2] = 0.0;
                Bessel_LPF_Qb[2] = 0.0;
                
                Bessel_LPF_Qa[3] = 0.0;
                Bessel_LPF_Qb[3] = 0.0;
                break;
            case Oct_18dB:
                LPF_fre    =    LPF_fre/1.75567236868;
                Bessel_LPF_Qa[0] = 0.5693712514;
                Bessel_LPF_Qb[0] = 0.154812441;
                
                Bessel_LPF_Qa[1] = 0.430628846;
                Bessel_LPF_Qb[1] = 0.0;
                
                Bessel_LPF_Qa[2] = 0.0;
                Bessel_LPF_Qb[2] = 0.0;
                
                Bessel_LPF_Qa[3] = 0.0;
                Bessel_LPF_Qb[3] = 0.0;
                break;
            case Oct_24dB:
                LPF_fre    =    LPF_fre/2.1139176749;
                Bessel_LPF_Qa[0] = 0.369;
                Bessel_LPF_Qb[0] = 0.087858766;
                
                Bessel_LPF_Qa[1] = 0.6278294896;
                Bessel_LPF_Qb[1] = 0.109408;
                
                Bessel_LPF_Qa[2] = 0.0;
                Bessel_LPF_Qb[2] = 0.0;
                
                Bessel_LPF_Qa[3] = 0.0;
                Bessel_LPF_Qb[3] = 0.0;
                break;
            case Oct_30dB:
                LPF_fre=LPF_fre    /    1.0;//2.1139176749;
                Bessel_LPF_Qa[0] = 0.6656;//0.369;
                Bessel_LPF_Qb[0] = 0.0;//0.087858766;
                
                Bessel_LPF_Qa[1] = 1.1402;//0.6278294896;
                Bessel_LPF_Qb[1] = 0.4128;//0.109408;
                
                Bessel_LPF_Qa[2] = 0.6216;
                Bessel_LPF_Qb[2] = 0.3245;
                
                Bessel_LPF_Qa[3] = 0.0;
                Bessel_LPF_Qb[3] = 0.0;
                break;
            case Oct_36dB:
                LPF_fre=LPF_fre    /    1.0;;
                Bessel_LPF_Qa[0] = 1.2217;//0.369;
                Bessel_LPF_Qb[0] = 0.3887;//0.087858766;
                
                Bessel_LPF_Qa[1] = 0.9686;//0.6278294896;
                Bessel_LPF_Qb[1] = 0.3505;//0.109408;
                
                Bessel_LPF_Qa[2] = 0.5131;
                Bessel_LPF_Qb[2] = 0.2756;
                
                Bessel_LPF_Qa[3] = 0.0;
                Bessel_LPF_Qb[3] = 0.0;
                break;
            case Oct_42dB:
                LPF_fre=LPF_fre    /    1.0;//3.17961723751;
                Bessel_LPF_Qa[0] = 0.5937;//0.117235677;
                Bessel_LPF_Qb[0] = 0.0;//0.02064747;
                
                Bessel_LPF_Qa[1] = 1.0944;//0.226516664;
                Bessel_LPF_Qb[1] = 0.3395;//0.0259273886;
                
                Bessel_LPF_Qa[2] = 0.8304;//0.3067559;
                Bessel_LPF_Qb[2] = 0.3011;//0.0294683265;
                
                Bessel_LPF_Qa[3] = 0.4332;//0.3494916166;
                Bessel_LPF_Qb[3] = 0.2381;//0.031272257;
                break;
            case Oct_48dB:
                LPF_fre    =    LPF_fre/3.17961723751;
                Bessel_LPF_Qa[0] = 0.117235677;
                Bessel_LPF_Qb[0] = 0.02064747;
                
                Bessel_LPF_Qa[1] = 0.226516664;
                Bessel_LPF_Qb[1] = 0.0259273886;
                
                Bessel_LPF_Qa[2] = 0.3067559;
                Bessel_LPF_Qb[2] = 0.0294683265;
                
                Bessel_LPF_Qa[3] = 0.3494916166;
                Bessel_LPF_Qb[3] = 0.031272257;
                break;
        }
        w0 = LPF_fre * LPF_FsPi;
        alphal1    =    tan(w0*0.5);
        alphal2    =    alphal1    *alphal1;
        for( i = 0;i<4;i++){
            temp_ai    =    Bessel_LPF_Qa[i];
            temp_bi    =    Bessel_LPF_Qb[i];
            if(temp_ai ==    0){
                temp_a0[i] = 1;
                temp_a1[i] = 0;
                temp_a2[i] = 0;
                temp_b0[i] = 1;
                temp_b1[i] = 0;
                temp_b2[i] = 0;
            }else{
                temp_a0[i] = alphal2+temp_ai*alphal1+temp_bi;
                temp_a1[i] = 2*alphal2 - 2*temp_bi;
                temp_a2[i] = alphal2-temp_ai*alphal1+temp_bi;
                temp_b0[i] = alphal2;
                temp_b1[i] = 2*alphal2;
                temp_b2[i] = alphal2;
            }
        }
    }else{
        switch(LPF_oct){
            case Oct_6dB:
            case Oct_12dB:
                if(LPF_type    == L_R){
                    LPF_Q[0] = 1.0;
                    LPF_Q[1] = 0.0;
                    LPF_Q[2] = 0.0;
                    LPF_Q[3] = 0.0;
                }
                if(LPF_type    == ButtWorth){
                    LPF_Q[0] = 0.70422535;
                    LPF_Q[1] = 0.0;
                    LPF_Q[2] = 0.0;
                    LPF_Q[3] = 0.0;
                }
                break;
            case Oct_18dB:
                if(LPF_type    == L_R){
                    LPF_Q[0] = 1.0;
                    LPF_Q[1] = 0.70422535211;
                    LPF_Q[2] = 0.0;
                    LPF_Q[3] = 0.0;
                }
                if(LPF_type    == ButtWorth){
                    LPF_Q[0] = 1.0;
                    LPF_Q[1] = 0.5;
                    LPF_Q[2] = 0.0;
                    LPF_Q[3] = 0.0;
                }
                break;
                
            case Oct_24dB:
                if(LPF_type    == L_R){
                    LPF_Q[0] = 0.70422535211;
                    LPF_Q[1] = 0.70422535211;
                    LPF_Q[2] = 0.0;
                    LPF_Q[3] = 0.0;
                }
                if(LPF_type    == ButtWorth){
                    LPF_Q[0] = 0.92592593;
                    LPF_Q[1] = 0.38167939;
                    LPF_Q[2] = 0.0;
                    LPF_Q[3] = 0.0;
                }
                break;
                
            case Oct_30dB:
                if(    LPF_type==L_R){
                    LPF_Q[0]=1.0;
                    LPF_Q[1]=0.62;
                    LPF_Q[2]=0.62;
                    LPF_Q[3]=0.0;
                }
                if(    LPF_type==ButtWorth){
                    LPF_Q[0]=1.0;
                    LPF_Q[1]=0.8064616129;
                    LPF_Q[2]=0.3086417953;
                    LPF_Q[3]=0.0;
                }
                break;
            case Oct_36dB:
                if(    LPF_type==L_R){
                    LPF_Q[0]=1.0;
                    LPF_Q[1]=0.5;
                    LPF_Q[2]=0.5;
                    LPF_Q[3]=0.0;
                }
                if(    LPF_type==ButtWorth){
                    LPF_Q[0]=0.96153846;
                    LPF_Q[1]=0.70422535211;
                    LPF_Q[2]=0.2590673575;
                    LPF_Q[3]=0.0;
                }
                break;
            case Oct_42dB:
                if(    LPF_type==L_R){
                    LPF_Q[0]=1.0;
                    LPF_Q[1]=0.4531343150;
                    LPF_Q[2]=0.92592592593;
                    LPF_Q[3]=0.4531343150;
                }
                if(    LPF_type==ButtWorth){
                    LPF_Q[0]=1.0;
                    LPF_Q[1]=0.90909090909;
                    LPF_Q[2]=0.625;
                    LPF_Q[3]=0.2222222222;
                }
                break;
            case Oct_48dB:
                if(LPF_type    ==    L_R){
                    LPF_Q[0] = 0.92592592593;
                    LPF_Q[1] = 0.3731343150;
                    LPF_Q[2] = 0.92592592593;
                    LPF_Q[3] = 0.3731343150;
                }
                if(LPF_type    == ButtWorth){
                    LPF_Q[0] = 0.98039216;
                    LPF_Q[1] = 0.83333333;
                    LPF_Q[2] = 0.55555556;
                    LPF_Q[3] = 0.1953125;
                }
                break;
        }
        w0    =    LPF_fre    *LPF_FsPi;
        w0_cValue    =    cos(w0);
        w0_sValue    =    sin(w0);
        w_l    =    w0*0.5;
        alph_l = tan(w_l);
        for(i=0;i<4;i++){
            alphal = w0_sValue * LPF_Q[i];
            if(LPF_Q[i]    == 0){
                temp_a0[i] = 1;
                temp_a1[i] = 0;
                temp_a2[i] = 0;
                temp_b0[i] = 1;
                temp_b1[i] = 0;
                temp_b2[i] = 0;
            }else{
                temp_a0[i] = 1+alphal;
                if(temp_a0[i]    == 0){
                    temp_a0[i] = 0.0000000001;
                }
                temp_a1[i] =-2.0*w0_cValue;
                temp_a2[i] = 1-alphal;
                temp_b0[i] = (1-w0_cValue)*0.5;
                temp_b1[i] = 2.0*temp_b0[i];
                temp_b2[i] = temp_b0[i];
            }
        }
        //            if(LPF_oct ==    Oct_18dB|| LPF_oct ==    Oct_30dB ||    LPF_oct    == Oct_42dB){
        //                temp_a0[0] = alph_l+LPF_Q[0];
        //                if(temp_a0[0]    == 0){
        //                    temp_a0[0] = 0.0000000001;
        //                }
        //                temp_a1[0] = alph_l-LPF_Q[0];
        //                temp_a2[0] = 0.0;
        //                temp_b0[0] = alph_l;
        //                temp_b1[0] = alph_l;
        //                temp_b2[0] = 0.0;
        //            }
        if(LPF_oct == Oct_18dB|| LPF_oct == Oct_30dB || LPF_oct == Oct_42dB|| LPF_oct == Oct_6dB )
        {
            temp_a0[0] = alph_l+LPF_Q[0];
            if(temp_a0[0] == 0)
            {
                temp_a0[0] = 0.0000000001;
                
            }
            temp_a1[0] = alph_l-LPF_Q[0];
            temp_a2[0] = 0.0;
            temp_b0[0] = alph_l;
            temp_b1[0] = alph_l;
            temp_b2[0] = 0.0;
        }
    }
    for(int    j=0;j<241;j++){
        f    =    FREQ241[j];
        LPF_Wf = 2*pi*f/FS;
        for(i=0;i<4;i++)
        {
            a1 = temp_a1[i]    /    temp_a0[i];
            a2 = temp_a2[i]    /    temp_a0[i];
            
            b1 = temp_b0[i]    /    temp_a0[i];
            b2 = temp_b1[i]    /    temp_a0[i];
            b3 = temp_b2[i]    /    temp_a0[i];
            A    =     cos(LPF_Wf) +a1+a2*cos(LPF_Wf);
            B    =     sin(LPF_Wf) -a2*sin(LPF_Wf);
            C    =     b1*cos(LPF_Wf)+b2+b3*cos(LPF_Wf);
            D    =     b1*sin(LPF_Wf)-b3*sin(LPF_Wf);
            EE  =    sqrt((C*C+D*D)/(A*A+B*B));
            tmp    =     tmp+20*log10(EE);
        }
        if(EQ_Filter.l_freq!=20000){
            m_nPointLP[j]    =    tmp;
        }
        tmp    =    0;
        
    }
    
    if((EQ_Filter.l_freq==20000)||(EQ_Filter.l_level==HL_OFF)){
        for(int    j=0;j< 241;j++){
            m_nPointLP[j]    =    0;
        }
    }
}

- (double) GetBW:(int) BW {
    return (BW*0.01+0.05);
}

/**
 * 更新EQ的图形
 */
- (void) UpDataPEQ:(int) eqIndex{
    //mtest
    //EQ_Filter.EQ[eqIndex].bw=0;//295
    //EQ_Filter.EQ[4].level=450;
    
    double f;
    double PEQ_FsPi,PEQ_Fc,PEQ_dB,PEQ_bw;
    double w0,temp,temp_A,temp_sin,alpha,temp_a0,temp_a1,temp_a2,temp_b0,temp_b1,temp_b2;
    double a1,a2,b1,b2,b3;
    double A,B,C,D,EE,tmp;
    double PEQ_Wf;
    int    nFreq;
    
    if(EQ_Filter.EQ[eqIndex].bw>EQ_BW_MAX){
        EQ_Filter.EQ[eqIndex].bw=EQ_BW_MAX;
    }
    
    nFreq    =    GetFreqIndex(EQ_Filter.EQ[eqIndex].freq);    //查找索引值
    
    //PEQ_Fc  = EQ_Filter.EQ[eqIndex].freq;
    //        PEQ_Fc = DataStruct.FREQ241[nFreq];
    //        PEQ_dB = (EQ_Filter.EQ[eqIndex].level-DataStruct.EQ_LEVEL_ZERO)/10;
    //PEQ_bw = DataStruct.EQ_BW[DataStruct.EQ_BW_MAX-EQ_Filter.EQ[eqIndex].bw];
    
    //        PEQ_bw = 0.200 + (EQ_Filter.EQ[eqIndex].bw)/100.0;
    //PEQ_bw = (double) (DataStruct.EQ_BW[DataStruct.EQ_BW_MAX-EQ_Filter.EQ[eqIndex].bw])*0.2;
    //System.out.println("EQ EQ_Filter.EQ[eqIndex].bw:"+EQ_Filter.EQ[eqIndex].bw);
    
    PEQ_Fc = FREQ241[nFreq];
    PEQ_dB = (EQ_Filter.EQ[eqIndex].level-EQ_LEVEL_ZERO)/10.0;
    PEQ_bw = [self GetBW:EQ_Filter.EQ[eqIndex].bw];
    
    
    //System.out.println("EQ nFreq@"+eqIndex+":"+nFreq);
    //System.out.println("EQ PEQ_dB:"+PEQ_dB);
    //System.out.println("EQ PEQ_bw:"+PEQ_bw);
    
    for(int    i=0;i<241;i++){
        f    =    FREQ241[i];
        PEQ_Wf = 2*pi*f/FS;
        //PEQ_FsPi = 0.00013089969;
        PEQ_FsPi = 0.00006544985;
        w0 = PEQ_Fc*PEQ_FsPi;
        temp = PEQ_dB/40.0;
        temp_A = pow(10.0,temp);
        temp_sin = sin(w0);
        alpha    =    temp_sin*sinh(0.69314718*0.5*PEQ_bw*w0/temp_sin);
        temp_a0    =    1+alpha/temp_A;
        temp_a1    =    (-2)*cos(w0);
        temp_a2    =    1-alpha/temp_A;
        temp_b0    =    1+alpha*temp_A;
        temp_b1    =    (-2)*cos(w0);
        temp_b2    =    1-alpha*temp_A;
        temp_a0    =    1.0/temp_a0;
        a1 = temp_a1*temp_a0;      //a1
        a2 = temp_a2*temp_a0;     //a2
        b1 = temp_b0 * temp_a0;  //b0
        b2 = temp_b1 * temp_a0;    //b1
        b3 = temp_b2 * temp_a0;//b2
        A    =    cos(PEQ_Wf)    +a1    +a2*cos(PEQ_Wf);
        B    =    sin(PEQ_Wf)-a2*sin(PEQ_Wf);
        C    =    b1 *cos(PEQ_Wf)+b2 +b3*cos(PEQ_Wf);
        D    =    b1*sin(PEQ_Wf)-b3*sin(PEQ_Wf);
        EE  =   sqrt((C*C+D*D)/(A*A+B*B));
        tmp    =    20*log10(EE);
        m_nPointPEQ[eqIndex][i]    =    tmp;//把文档之值转换为坐标值
    }
}

int GetFreqIndex(double Freq){
    double LNum,RNum,Num;
    for(int i=0;i<241;i++){
        Num = FREQ241[i];
        if(Num >=Freq){
            if(i>0){
                LNum = Freq - FREQ241[i-1];
                RNum = Num - Freq;
                if(LNum < RNum){
                    return (i-1);
                }else{
                    return i;
                }
            }
            return i;
        }else{
            if(i == 240){
                return i;
            }
        }
    }
    return -1;
}

@end
