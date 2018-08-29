//
//  AnyLink.m
//  YDW-DCS480-DSP-408
//
//  Created by chsdsp on 2018/1/31.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import "AnyLink.h"
#import <math.h>
#import "MacDefine.h"
#import "DataStruct.h"
#import "Masonry.h"
#import "NormalButton.h"
#define TagChannelBtnStart 1330
#define TagChannelBtnStartI 1350
#define btn_height 25
#define btn_Div 5
#define MarginSide (10)
#define BtnH (25)
#define BtnW (80)

#define Null (0xff)

@implementation AnyLink

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        WIND_Width   = KScreenWidth/2;//frame.size.width;
        WIND_Height  = frame.size.height;
        WIND_CenterX = WIND_Width/2;
        WIND_CenterY = WIND_Height/2;
        [self setup];
    }
    return self;
}
- (void)initData{
    channel = 0;
    group = 1;
    for(int i=0;i<=16;i++){
        for(int j=0;j<16;j++){
            LG.Data[i].group[j]=Null;
            LG.Data[i].g=i;
            LG.Data[i].cnt=0;
        }
        BOOLHaveGroup[0] = false;
    }
    for(int j=1;j<=16;j++){
       ChannelAnyLinkBuf[j]=0;
    }
    
    for(int i=0;i<Output_CH_MAX_USE;i++){
        if((RecStructData.OUT_CH[i].linkgroup_num <= Output_CH_MAX_USE)
           && (RecStructData.OUT_CH[i].linkgroup_num!=0)){
             ChannelAnyLinkBuf[i+1]=RecStructData.OUT_CH[i].linkgroup_num;
        }
    }
    for(int i=1;i<=Output_CH_MAX_USE;i++){
        /*
        switch (ChannelAnyLinkBuf[i]) {
            case 1:
                LG.Data[1].g=1;
                LG.Data[1].group[LG.Data[1].cnt]=i-1;
                LG.Data[1].cnt+=1;
                break;
                
            default:
                break;
        }
        */
        
        LG.Data[ChannelAnyLinkBuf[i]].group[LG.Data[ChannelAnyLinkBuf[i]].cnt]=i-1;
        LG.Data[ChannelAnyLinkBuf[i]].cnt+=1;
    }
    
    for(int i=1;i<=Output_CH_MAX_USE;i++){
        if(LG.Data[i].cnt>0){
            BOOLHaveGroup[i] = true;
        }
    }
    
}
- (void)setup{
    [self initData];
    WIND_Width   = KScreenWidth-[Dimens GDimens:30];//frame.size.width;
    WIND_Height  = KScreenHeight-[Dimens GDimens:120];
    self.backgroundColor = SetColor(UI_AutoLink_Bg);
    self.frame = CGRectMake(0, 0, WIND_Width, WIND_Height);
    
    UILabel *LabTitle = [[UILabel alloc]init];
    [self addSubview:LabTitle];
    [LabTitle setBackgroundColor:SetColor(UI_AutoLink_TitleTBg)];
    [LabTitle setTextColor:SetColor(UI_AutoLink_TextColor_Normal)];
    LabTitle.text=[LANG DPLocalizedString:@"L_Out_SetLink"];
    LabTitle.textAlignment = NSTextAlignmentCenter;
    LabTitle.adjustsFontSizeToFitWidth = true;
    LabTitle.font = [UIFont systemFontOfSize:20];
    [LabTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, [Dimens GDimens:40]));
    }];
    
    UILabel *LabTitleB = [[UILabel alloc]init];
    [self addSubview:LabTitleB];
    [LabTitleB setBackgroundColor:SetColor(UI_AutoLink_TitleBBg)];
    [LabTitleB setTextColor:SetColor(UI_AutoLink_TextColor_Normal)];
    LabTitleB.text=[LANG DPLocalizedString:@"L_Out_Link_About"];
    LabTitleB.textAlignment = NSTextAlignmentCenter;
    LabTitleB.adjustsFontSizeToFitWidth = true;
    LabTitleB.font = [UIFont systemFontOfSize:13];
    [LabTitleB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIND_Width, [Dimens GDimens:40]));
    }];
    
    self.Btn_Cancel = [[NormalButton alloc]init];
    [self addSubview:self.Btn_Cancel];
    [self.Btn_Cancel initViewBroder:3
                  withBorderWidth:1
                  withNormalColor:UI_AutoLink_Btn_NormalIN
                   withPressColor:UI_AutoLink_Btn_PressIN
            withBorderNormalColor:UI_AutoLink_BtnColor_Normal
             withBorderPressColor:UI_AutoLink_BtnColor_Press
              withTextNormalColor:UI_AutoLink_BtnTextColor_Normal
               withTextPressColor:UI_AutoLink_BtnTextColor_Press
                         withType:4];
    [self.Btn_Cancel setTitle:[LANG DPLocalizedString:@"L_System_Cancel"] forState:UIControlStateNormal] ;
    self.Btn_Cancel.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Cancel.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(LabTitleB.mas_top).offset(-[Dimens GDimens:10]);
        make.right.equalTo(self.mas_right).offset(-[Dimens GDimens:MarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:BtnW], [Dimens GDimens:BtnH]));
    }];
    
    UILabel *LabTitleG = [[UILabel alloc]init];
    [self addSubview:LabTitleG];
    [LabTitleG setBackgroundColor:SetColor(0x00ffffff)];
    [LabTitleG setTextColor:SetColor(UI_AutoLink_TextColor_Normal)];
    LabTitleG.text=[NSString stringWithFormat:@"%@:",[LANG DPLocalizedString:@"L_Out_OutGroupSel"]];
    LabTitleG.textAlignment = NSTextAlignmentCenter;
    LabTitleG.adjustsFontSizeToFitWidth = true;
    LabTitleG.font = [UIFont systemFontOfSize:15];
    [LabTitleG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset([Dimens GDimens:120]);
        make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:80], [Dimens GDimens:40]));
    }];
    
    self.Btn_Ok = [[NormalButton alloc]init];
    [self addSubview:self.Btn_Ok];
    [self.Btn_Ok initViewBroder:3
                  withBorderWidth:1
                withNormalColor:UI_AutoLink_Btn_NormalIN
                 withPressColor:UI_AutoLink_Btn_PressIN
          withBorderNormalColor:UI_AutoLink_BtnColor_Normal
           withBorderPressColor:UI_AutoLink_BtnColor_Press
            withTextNormalColor:UI_AutoLink_BtnTextColor_Normal
             withTextPressColor:UI_AutoLink_BtnTextColor_Press
                         withType:4];
    [self.Btn_Ok setTitle:[LANG DPLocalizedString:@"L_System_OK"] forState:UIControlStateNormal] ;
    [self.Btn_Ok addTarget:self action:@selector(Btn_Ok_Click:) forControlEvents:UIControlEventTouchUpInside];
    self.Btn_Ok.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Ok.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Ok mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(LabTitleB.mas_top).offset(-[Dimens GDimens:10]);
        make.left.equalTo(self.mas_left).offset([Dimens GDimens:MarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:BtnW], [Dimens GDimens:BtnH]));
    }];
    
    self.Btn_Join = [[NormalButton alloc]init];
    [self addSubview:self.Btn_Join];
    [self.Btn_Join initViewBroder:3
                withBorderWidth:1
                withNormalColor:UI_AutoLink_Btn_NormalIN
                 withPressColor:UI_AutoLink_Btn_PressIN
          withBorderNormalColor:UI_AutoLink_BtnColor_Normal
           withBorderPressColor:UI_AutoLink_BtnColor_Press
            withTextNormalColor:UI_AutoLink_BtnTextColor_Normal
             withTextPressColor:UI_AutoLink_BtnTextColor_Press
                       withType:4];
    [self.Btn_Join setTitle:[LANG DPLocalizedString:@"L_Out_GroupJoin"] forState:UIControlStateNormal] ;
    [self.Btn_Join addTarget:self action:@selector(btnJoin_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Join setTitleColor:SetColor(UI_AutoLink_Btn_PressIN) forState:UIControlStateHighlighted];
    self.Btn_Join.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Join.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Join mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.Btn_Ok.mas_top).offset(-[Dimens GDimens:20]);
        make.left.equalTo(self.mas_left).offset([Dimens GDimens:MarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:BtnW], [Dimens GDimens:BtnH]));
    }];
    
    self.Btn_Delete = [[NormalButton alloc]init];
    [self addSubview:self.Btn_Delete];
    [self.Btn_Delete initViewBroder:3
                    withBorderWidth:1
                    withNormalColor:UI_AutoLink_Btn_NormalIN
                     withPressColor:UI_AutoLink_Btn_PressIN
              withBorderNormalColor:UI_AutoLink_BtnColor_Normal
               withBorderPressColor:UI_AutoLink_BtnColor_Press
                withTextNormalColor:UI_AutoLink_BtnTextColor_Normal
                 withTextPressColor:UI_AutoLink_BtnTextColor_Press
                           withType:4];
    [self.Btn_Delete setTitle:[LANG DPLocalizedString:@"L_Out_GroupDel"] forState:UIControlStateNormal] ;
    [self.Btn_Delete addTarget:self action:@selector(btnDelete_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_Delete setTitleColor:SetColor(UI_AutoLink_Btn_PressIN) forState:UIControlStateHighlighted];
    self.Btn_Delete.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Delete.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.Btn_Ok.mas_top).offset(-[Dimens GDimens:20]);
        make.right.equalTo(self.mas_right).offset(-[Dimens GDimens:MarginSide]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:BtnW], [Dimens GDimens:BtnH]));
    }];
    
    self.Btn_Group = [[NormalButton alloc]init];
    [self addSubview:self.Btn_Group];
    [self.Btn_Group initViewBroder:3
                    withBorderWidth:1
                    withNormalColor:UI_AutoLink_Btn_NormalIN
                     withPressColor:UI_AutoLink_Btn_PressIN
              withBorderNormalColor:UI_AutoLink_BtnColor_Normal
               withBorderPressColor:UI_AutoLink_BtnColor_Press
                withTextNormalColor:UI_AutoLink_BtnTextColor_Normal
                 withTextPressColor:UI_AutoLink_BtnTextColor_Press
                           withType:4];
    [self.Btn_Group setTitle:[LANG DPLocalizedString:@"L_Out_Link"] forState:UIControlStateNormal] ;
    [self.Btn_Group addTarget:self action:@selector(btnGroup_click:) forControlEvents:UIControlEventTouchUpInside];
    self.Btn_Group.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_Group.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.Btn_Group setTitleColor:SetColor(UI_AutoLink_Btn_PressIN) forState:UIControlStateHighlighted];
    [self.Btn_Group mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.Btn_Ok.mas_top).offset(-[Dimens GDimens:20]);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:BtnW], [Dimens GDimens:BtnH]));
    }];
    
//    self.Btn_unLink=[[NormalButton alloc]init];
//    [self addSubview:self.Btn_unLink];
//    [self.Btn_unLink initViewBroder:3
//                    withBorderWidth:1
//                    withNormalColor:UI_AutoLink_Btn_NormalIN
//                     withPressColor:UI_AutoLink_Btn_PressIN
//              withBorderNormalColor:UI_AutoLink_BtnColor_Press
//               withBorderPressColor:UI_AutoLink_BtnColor_Press
//                withTextNormalColor:UI_AutoLink_Btn_PressIN
//                 withTextPressColor:UI_AutoLink_Btn_PressIN
//                           withType:4];
//    [self.Btn_unLink setTitle:[LANG DPLocalizedString:@"L_Out_UnLink"] forState:UIControlStateNormal] ;
//    [self.Btn_unLink addTarget:self action:@selector(setUnLink) forControlEvents:UIControlEventTouchUpInside];
//    self.Btn_unLink.titleLabel.adjustsFontSizeToFitWidth = true;
//    self.Btn_unLink.titleLabel.font = [UIFont systemFontOfSize:13];
//    [self.Btn_unLink setTitleColor:SetColor(UI_AutoLink_Btn_PressIN) forState:UIControlStateHighlighted];
//    [self.Btn_unLink mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.Btn_Ok.mas_top);
//        make.centerX.equalTo(self.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:BtnW], [Dimens GDimens:BtnH]));
//    }];
//    if (BOOL_LINK) {
//        self.Btn_unLink.hidden=NO;
//    }else{
//        self.Btn_unLink.hidden=YES;
//    }
    
    /// 2个按钮之间的横间距
    Width_Space = WIND_Width/(Output_CH_MAX_USE*0.5*btn_Div + (Output_CH_MAX_USE*0.5+1));
    Button_Width = Width_Space*btn_Div;// 宽
    Button_Height=[Dimens GDimens:btn_height];// 高
    Height_Space =[Dimens GDimens:btn_height*0.66];// 竖间距
    
    for (int i = 0; i<Output_CH_MAX_USE; i++) {
        NSInteger x = i % (Output_CH_MAX_USE/2);
        NSInteger y = i / (Output_CH_MAX_USE/2);
        
        Start_X = Width_Space+x*(Button_Width + Width_Space);
        Start_Y = Height_Space+y*(Button_Height + Height_Space)+[Dimens GDimens:30];
        
        NormalButton *btn = [[NormalButton alloc]init];
        btn.frame = CGRectMake(Start_X, Start_Y, Button_Width, Button_Height);
        
        [self addSubview:btn];
        
        [btn setTag:i+TagChannelBtnStart];
        [btn initViewBroder:3
                       withBorderWidth:1
                       withNormalColor:UI_AutoLink_Btn_NormalIN
                        withPressColor:UI_AutoLink_Btn_PressIN
                 withBorderNormalColor:UI_AutoLink_BtnColor_Normal
                  withBorderPressColor:UI_AutoLink_BtnColor_Press
                   withTextNormalColor:UI_AutoLink_BtnTextColor_Normal
                    withTextPressColor:UI_AutoLink_BtnTextColor_Press
                              withType:1];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[NSString stringWithFormat:@"CH%d",(i+1)] forState:UIControlStateNormal];

    }
    
    int basey = [Dimens GDimens:160];
    Start_X = [Dimens GDimens:20];
    int btnw = WIND_Width - [Dimens GDimens:40];
    for (int i = 0; i<=Output_CH_MAX_USE; i++) {
        Start_Y = basey+i*[Dimens GDimens:BtnH+8];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(Start_X, Start_Y, btnw, Button_Height);
        [self addSubview:btn];
        [btn setTag:i+TagChannelBtnStartI];
        [btn addTarget:self action:@selector(btnG_click:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[[UIImage imageNamed:@"out_coupling_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [btn setTitle:[LANG DPLocalizedString:@"L_TopBar_Back"] forState:UIControlStateNormal];
        btn.titleLabel.textColor = SetColor(UI_ToolbarBackTextColor);
        [btn setTitleColor:SetColor(UI_ToolbarBackTextColor) forState:UIControlStateNormal];
        btn.titleLabel.adjustsFontSizeToFitWidth = true;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        //[btn setBackgroundColor:[UIColor blueColor]];
        btn.titleEdgeInsets = (UIEdgeInsets){
            .top    = 0,
            .left   = 0,
            .bottom = 0,
            .right  = 0,
        };
        
        btn.imageEdgeInsets = (UIEdgeInsets){
            .top    = 0,
            .left   = 0,
            .bottom = 0,
            .right  = btnw-Button_Height,
        };
        [btn setTitle:[NSString stringWithFormat:@"CH%d",(i+1)] forState:UIControlStateNormal];
        
        if(i == 0){
            btn.hidden = true;
        }
    }
    
    for(int j=0;j<Output_CH_MAX_USE;j++){
        NormalButton *find_btn = (NormalButton *)[self viewWithTag:j+TagChannelBtnStart];
        find_btn.Group=ChannelAnyLinkBuf[j+1];
        if(ChannelAnyLinkBuf[j+1]>0){
            [find_btn setPress:[self getColor:find_btn.Group]];
            find_btn.GStatus = 2;//已经存在的组
        }
        
    }
    for(int j=1;j<=Output_CH_MAX_USE;j++){
        BtnGTemp = (UIButton *)[self viewWithTag:j+TagChannelBtnStartI];
        if(LG.Data[j].cnt>0){
            BtnGTemp.hidden = false;
            if(group == 0){
                group = j;
                [BtnGTemp setImage:[[UIImage imageNamed:@"out_coupling_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
            [BtnGTemp setTitle:[self getString:j] forState:UIControlStateNormal];
        }else{
            BtnGTemp.hidden = true;
        }
    }

}
-(void)setUnLink{
    self.unlinkBlock();
}
- (NSString *)getString:(int)sel{
    NSString *st=[NSString stringWithFormat:@"G%d:",sel];
    NSString *ss=@"";
    if(LG.Data[sel].cnt > 0){
        for (int i = 0;i<LG.Data[sel].cnt; i++) {
            ss = [NSString stringWithFormat:@"CH%d.", LG.Data[sel].group[i]+1];
            st = [st stringByAppendingString:ss];
        }
    }
    
    return st;
}
- (UInt32)getColor:(int)sel{
    switch (sel) {
        case 0: return UI_AutoLink_Color0;
        case 1: return UI_AutoLink_Color1;
        case 2: return UI_AutoLink_Color2;
        case 3: return UI_AutoLink_Color3;
        case 4: return UI_AutoLink_Color4;
        case 5: return UI_AutoLink_Color5;
        case 6: return UI_AutoLink_Color6;
        case 7: return UI_AutoLink_Color7;
        case 8: return UI_AutoLink_Color8;
        case 9: return UI_AutoLink_Color9;
        case 10: return UI_AutoLink_Color10;
        case 11: return UI_AutoLink_Color11;
        case 12: return UI_AutoLink_Color12;
            
        default:return UI_AutoLink_ColorNull;
            break;
    }
}
- (void)btn_click:(NormalButton*)sender{
    
    channel = (int)sender.tag-TagChannelBtnStart;
    
    if((sender.GStatus == 1)||(sender.GStatus == 2)){
        
        //把已经加入的组取消
        if(sender.GStatus == 2){
            group = sender.Group;
            for(int i=0;i<LG.Data[group].cnt;i++){
                if(LG.Data[group].group[i]==channel){
                    //把此位清零
                    int j=i;
                    for(j=i;j<LG.Data[group].cnt;j++){
                        LG.Data[group].group[j] = LG.Data[sender.Group].group[j+1];
                    }
                    LG.Data[group].group[j] = 0xff;
                    LG.Data[group].cnt -= 1;
                    
                    BtnGTemp = (UIButton *)[self viewWithTag:group+TagChannelBtnStartI];
                    if(LG.Data[group].cnt == 0){
                        [BtnGTemp setImage:[[UIImage imageNamed:@"out_coupling_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                        BtnGTemp.hidden = true;
                        
                        BOOLHaveGroup[group] = 0;
                    }else{
                        [self setGroupNoSelected];
                        BtnGTemp = (UIButton *)[self viewWithTag:group+TagChannelBtnStartI];
                        [BtnGTemp setTitle:[self getString:group] forState:UIControlStateNormal];
                        [BtnGTemp setImage:[[UIImage imageNamed:@"out_coupling_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                        BtnGTemp.hidden = false;
                    }
                    
                    break;
                }
            }
        }
        [sender setNormal];
        sender.GStatus = 0;
        sender.Group = 0;
    }else if(sender.GStatus == 0){
        [sender setPress];
        sender.GStatus = 1;
    }
    
}

- (void)btnG_click:(UIButton*)sender{
    group = (int)sender.tag-TagChannelBtnStartI;
    if(BtnGTemp != NULL){
        [BtnGTemp setImage:[[UIImage imageNamed:@"out_coupling_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    BtnGTemp = sender;
    [BtnGTemp setImage:[[UIImage imageNamed:@"out_coupling_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)btnJoin_click:(NormalButton*)sender{
    //check have Link Button
    BOOL haveB = false;
    for(int j=0;j<Output_CH_MAX_USE;j++){
        NormalButton *find_btn = (NormalButton *)[self viewWithTag:j+TagChannelBtnStart];
        if(find_btn.GStatus == 1){
            haveB = true;
            break;
        }
    }
    if(!haveB){
        return;
    }
    //
    for(int j=0;j<Output_CH_MAX_USE;j++){
        NormalButton *find_btn = (NormalButton *)[self viewWithTag:j+TagChannelBtnStart];
        if(find_btn.GStatus == 1){
            LG.Data[group].group[LG.Data[group].cnt] = j;
            LG.Data[group].cnt += 1;
            
            [find_btn setPress:[self getColor:group]];
            find_btn.GStatus = 2;//已经存在的组
            find_btn.Group = group;
        }
    }
    BOOLHaveGroup[group] = true;
    [self setGroupNoSelected];
    BtnGTemp = (UIButton *)[self viewWithTag:group+TagChannelBtnStartI];
    [BtnGTemp setTitle:[self getString:group] forState:UIControlStateNormal];
    [BtnGTemp setImage:[[UIImage imageNamed:@"out_coupling_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    BtnGTemp.hidden = false;
}
- (void)btnGroup_click:(NormalButton*)sender{
    //check have Link Button
    BOOL haveB = false;
    for(int j=0;j<Output_CH_MAX_USE;j++){
        NormalButton *find_btn = (NormalButton *)[self viewWithTag:j+TagChannelBtnStart];
        if(find_btn.GStatus == 1){
            haveB = true;
            break;
        }
    }
    if(!haveB){
        return;
    }
    for(int i=1;i<=Output_CH_MAX_USE;i++){
        if(!BOOLHaveGroup[i]){
            group = i;
            BOOLHaveGroup[i] = true;
            break;
        }
    }
    for(int i=0;i<16;i++){
        LG.Data[group].group[i] = 0xff;
    }
    LG.Data[group].cnt = 0;
    LG.Data[group].g = 0;
    
    for(int j=0;j<Output_CH_MAX_USE;j++){
        NormalButton *find_btn = (NormalButton *)[self viewWithTag:j+TagChannelBtnStart];
        if(find_btn.GStatus == 1){
            LG.Data[group].group[LG.Data[group].cnt] = j;
            LG.Data[group].cnt += 1;
            
            [find_btn setPress:[self getColor:group]];
            find_btn.GStatus = 2;//已经存在的组
            find_btn.Group = group;
        }
    }
    [self setGroupNoSelected];
    BtnGTemp = (UIButton *)[self viewWithTag:group+TagChannelBtnStartI];
    [BtnGTemp setTitle:[self getString:group] forState:UIControlStateNormal];
    [BtnGTemp setImage:[[UIImage imageNamed:@"out_coupling_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    BtnGTemp.hidden = false;
}
- (void)btnDelete_click:(NormalButton*)sender{
    for(int i=0;i<LG.Data[group].cnt;i++){
        for(int j=0;j<Output_CH_MAX_USE;j++){
            if(LG.Data[group].group[i]==j){
                NormalButton *find_btn = (NormalButton *)[self viewWithTag:j+TagChannelBtnStart];
                [find_btn setNormal];
                find_btn.Group = 0;
                find_btn.GStatus = 0;
            }
        }
    }
    BOOLHaveGroup[group] = false;
    for(int i=0;i<16;i++){
        LG.Data[group].group[i] = 0xff;
    }
    LG.Data[group].cnt = 0;
    LG.Data[group].g = 0;
    
    BtnGTemp = (UIButton *)[self viewWithTag:group+TagChannelBtnStartI];
    [BtnGTemp setTitle:[self getString:group] forState:UIControlStateNormal];
    BtnGTemp.hidden = true;

}

- (void)Btn_Ok_Click:(NormalButton*)sender{
    UI_Type=0;
    for(int i=1;i<=16;i++){
        ChannelAnyLinkBuf[i] = 0;
    }
    
    for(int i=1;i<=Output_CH_MAX_USE;i++){
        if(LG.Data[i].cnt > 0){
            for(int j=0;j<LG.Data[i].cnt;j++){
                ChannelAnyLinkBuf[LG.Data[i].group[j]+1] = i;
            }
        }
    }
    
    for(int i=0;i<Output_CH_MAX_USE;i++){
        RecStructData.OUT_CH[i].linkgroup_num = ChannelAnyLinkBuf[i+1];
    }
    for(int i=0;i<=16;i++){
        for(int j=0;j<16;j++){
            NSLog(@"LG.Data[%d].group[%d]=%d",i,j,LG.Data[i].group[j]);
        }
    }
    
    self.clickBlock();
}
- (void)setGroupNoSelected{
    for(int i=1;i<=Output_CH_MAX_USE;i++){
        BtnGTemp = (UIButton *)[self viewWithTag:i+TagChannelBtnStartI];
        [BtnGTemp setImage:[[UIImage imageNamed:@"out_coupling_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
}











@end
