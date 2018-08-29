//
//  MixerViewController.m
//  MT-IOS
//
//  Created by chsdsp on 2017/2/21.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "DelayViewController_FRS.h"

@interface DelayViewController_FRS ()

@end

@implementation DelayViewController_FRS
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CurPage = UI_Page_Delay;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知观察者
    //接收noticeScanBLE通知
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //更新UI
    [center addObserver:self selector:@selector(UpdateMasterViewUI:) name:MyNotification_UpdateUI object:nil];
    //通信连接成功
    //[center addObserver:self selector:@selector(ConnectStateFormNotification:) name:MyNotification_ConnectSuccess object:nil];
    
    
    self.mDataTransmitOpt = [DataCommunication shareDataCommunication];
    self.view.backgroundColor = [UIColor clearColor];
    [self initData];
    [self initView];
    [self FlashPageUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma initData
- (void)initData{
    delayUnit = 2;
}

- (void)initView{
    [self initDelay];
    //[self initDelayUintSave];
    //[self initDelayUint];
    [self initDelayUint_I];
}

#pragma
- (void) initDelay{
    self.IVDelayCar = [[UIImageView alloc]init];
    [self.view addSubview:self.IVDelayCar];
    [self.IVDelayCar setImage:[UIImage imageNamed:@"delaysettings"]];
    [self.IVDelayCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-[Dimens GDimens:80]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:80], [Dimens GDimens:160]));
    }];

    
    //初始化
    float height  = [Dimens GDimens:130];
    float width   = [Dimens GDimens:150];
    float mid     = [Dimens GDimens:10];
    
    for (int i = 0; i<Output_CH_MAX; i++) {
        NSInteger x = i % (2);
        NSInteger y = i / (2);
        
        float Start_X = mid+(mid + width)*x;
        float Start_Y = (mid + height)*y + [Dimens GDimens:130];
        
        DelayItem *mDelayItem = [[DelayItem alloc]initWithFrame:CGRectMake(Start_X, Start_Y, width, height)];
        if(x == 0){
            mDelayItem.frame = CGRectMake(Start_X, Start_Y, width, height);
        }else{
            mDelayItem.frame = CGRectMake(KScreenWidth - width -mid, Start_Y, width, height);
        }
        
        if(i>=4){
            if(i == 4){
                mDelayItem.frame = CGRectMake(mid*4, Start_Y, width, height);
            }else{
                mDelayItem.frame = CGRectMake(KScreenWidth - width - mid*4, Start_Y, width, height);
            }
        }
        
        [self.view addSubview:mDelayItem];
        [mDelayItem setTag:i];
        [mDelayItem setDelayItemTag:i];
        [mDelayItem setDelayItemMax:DELAY_SETTINGS_MAX];
        [mDelayItem setDelayItemVal:RecStructData.OUT_CH[i].delay];
        [mDelayItem setDelayItemDelayUnit:DelayUnit_MS];
        //CH
        if(BOOL_SET_SpkType){
            [mDelayItem.Btn_Channel setTitle:[NSString stringWithFormat:@"CH%d",i+1] forState:UIControlStateNormal];
        }else{
            switch (i) {
                case 0:
                    [mDelayItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_FrontLeft"] forState:UIControlStateNormal] ;
                    break;
                case 1:[mDelayItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_FrontRight"] forState:UIControlStateNormal] ;
                    break;
                case 2:[mDelayItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RearLeft"] forState:UIControlStateNormal] ;
                    break;
                case 3:[mDelayItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RearRight"] forState:UIControlStateNormal] ;
                    break;
                case 4:[mDelayItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_LeftSub"] forState:UIControlStateNormal] ;
                    break;
                case 5:[mDelayItem.Btn_Channel setTitle:[LANG DPLocalizedString:@"L_XOver_RightSub"] forState:UIControlStateNormal] ;
                    break;
                default:
                    break;
            }
        }

        [mDelayItem addTarget:self action:@selector(mDelayItemChange:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)mDelayItemChange:(DelayItem *)sender{
    if(self.mDelayItem != nil){
        
    }
    
    output_channel_sel = (int) ((int)sender.tag - TagStart_DelayItem_Self);
    _CurDelayItem = (DelayItem *)[self.view viewWithTag:output_channel_sel+TagStart_DelayItem_Self];
    _mDelayItem = _CurDelayItem;
    
    RecStructData.OUT_CH[output_channel_sel].delay = [_CurDelayItem getDelayItemVal];

}

#pragma 
- (void)initDelayUintSave{
    self.BtnDelayUnit = [[NormalButton alloc]init];
    [self.view addSubview:self.BtnDelayUnit];
    [self.BtnDelayUnit initView:3 withBorderWidth:1 withNormalColor:UI_DelayBtn_Normal withPressColor:UI_DelayBtn_Press withType:0];
    [self.BtnDelayUnit setTextColorWithNormalColor:UI_DelayBtnText_Normal withPressColor:UI_DelayBtnText_Press];
    [self.BtnDelayUnit addTarget:self action:@selector(BtnDelayUnit_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnDelayUnit setTitle:[LANG DPLocalizedString:@"L_Delay_MS"] forState:UIControlStateNormal] ;
    self.BtnDelayUnit.titleLabel.font = [UIFont systemFontOfSize:13];
    self.BtnDelayUnit.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.BtnDelayUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset([Dimens GDimens:100]);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:30]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:120], [Dimens GDimens:30]));
    }];

    
    self.BtnSave = [[NormalButton alloc]init];
    [self.view addSubview:self.BtnSave];
    [self.BtnSave initView:3 withBorderWidth:1 withNormalColor:UI_DelayBtn_Normal withPressColor:UI_DelayBtn_Press withType:0];
    [self.BtnSave setTextColorWithNormalColor:UI_DelayBtnText_Normal withPressColor:UI_DelayBtnText_Press];
    [self.BtnSave addTarget:self action:@selector(BtnSave_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnSave setTitle:[LANG DPLocalizedString:@"L_System_Save"] forState:UIControlStateNormal] ;
    self.BtnSave.titleLabel.font = [UIFont systemFontOfSize:13];
    self.BtnSave.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.BtnSave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.BtnDelayUnit.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-[Dimens GDimens:30]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:120], [Dimens GDimens:30]));
    }];
}



#pragma 单位切换

#pragma
- (void)initDelayUint{
    //單位切換
    int unitw = 110;
    int unith = 35;
    self.IV_UnitDelaySwitch = [[UIImageView alloc]init];
    [self.view addSubview:self.IV_UnitDelaySwitch];
    [self.IV_UnitDelaySwitch setImage:[UIImage imageNamed:@"delay_unit_ms"]];
    [self.IV_UnitDelaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.bottom.equalTo(self.view.mas_bottom).offset(-[Dimens GDimens:30]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:unitw*3], [Dimens GDimens:unith]));
    }];
    self.Btn_MS = [[UIButton alloc]init];
    [self.view addSubview:self.Btn_MS];
    [self.Btn_MS setBackgroundColor:[UIColor clearColor]];
    [self.Btn_MS setTitle:[LANG DPLocalizedString:@"L_Delay_MS"] forState:UIControlStateNormal];
    self.Btn_MS.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_MS.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.Btn_MS.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.Btn_MS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.IV_UnitDelaySwitch.mas_centerY).offset([Dimens GDimens:0]);
        make.centerX.equalTo(self.IV_UnitDelaySwitch.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:unitw], [Dimens GDimens:unith]));
    }];
    self.Btn_CM = [[UIButton alloc]init];
    [self.view addSubview:self.Btn_CM];
    [self.Btn_CM setBackgroundColor:[UIColor clearColor]];
    [self.Btn_CM setTitle:[LANG DPLocalizedString:@"L_Delay_CM"] forState:UIControlStateNormal];
    self.Btn_CM.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_CM.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.Btn_CM.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.Btn_CM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.IV_UnitDelaySwitch.mas_centerY).offset([Dimens GDimens:0]);
        make.left.equalTo(self.IV_UnitDelaySwitch.mas_left).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:unitw], [Dimens GDimens:unith]));
    }];
    self.Btn_INCH = [[UIButton alloc]init];
    [self.view addSubview:self.Btn_INCH];
    [self.Btn_INCH setBackgroundColor:[UIColor clearColor]];
    [self.Btn_INCH setTitle:[LANG DPLocalizedString:@"L_Delay_Inch"] forState:UIControlStateNormal];
    self.Btn_INCH.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_INCH.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.Btn_INCH.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.Btn_INCH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.IV_UnitDelaySwitch.mas_centerY).offset([Dimens GDimens:0]);
        make.right.equalTo(self.IV_UnitDelaySwitch.mas_right).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:unitw], [Dimens GDimens:unith]));
    }];
    
    
    delayUnit = 2;
    
    [self.Btn_CM setTag:1];
    [self.Btn_MS setTag:2];
    [self.Btn_INCH setTag:3];
    
    [self.Btn_CM addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_MS addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_INCH addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.Btn_CM setTitle:[LANG DPLocalizedString:@"L_Delay_CM"] forState:UIControlStateNormal];
    [self.Btn_MS setTitle:[LANG DPLocalizedString:@"L_Delay_MS"] forState:UIControlStateNormal];
    [self.Btn_INCH setTitle:[LANG DPLocalizedString:@"L_Delay_Inch"] forState:UIControlStateNormal];
    
    [self flashDelayUnitSel];
}
- (void)delayUnitSel:(UIButton*)sender{
    delayUnit = (int)sender.tag;
    //[self flashDelayUnitSel];
    [self flashDelayUnitSel_I];
    [self setDelayUnit:delayUnit];
}
- (void)flashDelayUnitSel{
    
    [self.Btn_CM setTitleColor:SetColor(UI_DelayUnit_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_MS setTitleColor:SetColor(UI_DelayUnit_BtnText_Normal) forState:UIControlStateNormal];
    [self.Btn_INCH setTitleColor:SetColor(UI_DelayUnit_BtnText_Normal) forState:UIControlStateNormal];
    
    switch (delayUnit) {
        case 1:
            [self.IV_UnitDelaySwitch setImage:[UIImage imageNamed: @"delay_unit_cm"]];
            [self.Btn_CM setTitleColor:SetColor(UI_DelayUnit_BtnText_Press) forState:UIControlStateNormal];
            break;
        case 2:
            [self.IV_UnitDelaySwitch setImage:[UIImage imageNamed: @"delay_unit_ms"]];
            [self.Btn_MS setTitleColor:SetColor(UI_DelayUnit_BtnText_Press) forState:UIControlStateNormal];
            break;
        case 3:
            [self.IV_UnitDelaySwitch setImage:[UIImage imageNamed: @"delay_unit_inch"]];
            [self.Btn_INCH setTitleColor:SetColor(UI_DelayUnit_BtnText_Press) forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}


- (void)BtnDelayUnit_CLick:(NormalButton*)sender{
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Delay_SetDelay"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Delay_CM"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self setDelayUnit:DelayUnit_CM];
        [self.BtnDelayUnit setTitle:[LANG DPLocalizedString:@"L_Delay_CM"] forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Delay_MS"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self setDelayUnit:DelayUnit_MS];
        [self.BtnDelayUnit setTitle:[LANG DPLocalizedString:@"L_Delay_MS"] forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_Delay_Inch"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self setDelayUnit:DelayUnit_INCH];
        [self.BtnDelayUnit setTitle:[LANG DPLocalizedString:@"L_Delay_Inch"] forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma
- (void)initDelayUint_I{
    //單位切換
    int unitw = 110;
    int unith = 35;
    
    self.Btn_MS = [[UIButton alloc]init];
    [self.view addSubview:self.Btn_MS];
    [self.Btn_MS setTag:2];
    [self.Btn_MS addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_MS setBackgroundColor:[UIColor clearColor]];
    [self.Btn_MS setTitle:[LANG DPLocalizedString:@"L_Delay_MS"] forState:UIControlStateNormal];
    self.Btn_MS.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_MS.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.Btn_MS.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.Btn_MS.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_MS.titleLabel.font = [UIFont systemFontOfSize:18];
    self.Btn_MS.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_MS.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.Btn_MS.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.Btn_MS setImage:[[UIImage imageNamed:@"delay_unit_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.Btn_MS.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = [Dimens GDimens:10],
        .bottom = 0,
        .right  = 0,
    };
    
    self.Btn_MS.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = 0,
        .bottom = 0,
        .right  = [Dimens GDimens:unitw-unith],
    };
    [self.Btn_MS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-[Dimens GDimens:50]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:unitw], [Dimens GDimens:unith]));
    }];
    
    self.Btn_CM = [[UIButton alloc]init];
    [self.view addSubview:self.Btn_CM];
    [self.Btn_CM setTag:1];
    [self.Btn_CM addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_CM setBackgroundColor:[UIColor clearColor]];
    [self.Btn_CM setTitle:[LANG DPLocalizedString:@"L_Delay_CM"] forState:UIControlStateNormal];
    self.Btn_CM.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_CM.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.Btn_CM.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.Btn_CM.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_CM.titleLabel.font = [UIFont systemFontOfSize:18];
    self.Btn_CM.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_CM.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.Btn_CM.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.Btn_CM setImage:[[UIImage imageNamed:@"delay_unit_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.Btn_CM.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = [Dimens GDimens:10],
        .bottom = 0,
        .right  = 0,
    };
    
    self.Btn_CM.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = 0,
        .bottom = 0,
        .right  = [Dimens GDimens:unitw-unith],
    };
    [self.Btn_CM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Btn_MS.mas_centerY).offset(-[Dimens GDimens:0]);
        make.right.equalTo(self.Btn_MS.mas_left).offset(-[Dimens GDimens:20]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:unitw], [Dimens GDimens:unith]));
    }];
    
    self.Btn_INCH = [[UIButton alloc]init];
    [self.view addSubview:self.Btn_INCH];
    [self.Btn_INCH setTag:3];
    [self.Btn_INCH addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.Btn_INCH setBackgroundColor:[UIColor clearColor]];
    [self.Btn_INCH setTitle:[LANG DPLocalizedString:@"L_Delay_Inch"] forState:UIControlStateNormal];
    self.Btn_INCH.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_INCH.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.Btn_INCH.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.Btn_INCH.titleLabel.adjustsFontSizeToFitWidth = true;
    self.Btn_INCH.titleLabel.font = [UIFont systemFontOfSize:18];
    self.Btn_INCH.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Btn_INCH.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.Btn_INCH.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.Btn_INCH setImage:[[UIImage imageNamed:@"delay_unit_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.Btn_INCH.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = [Dimens GDimens:10],
        .bottom = 0,
        .right  = 0,
    };
    
    self.Btn_INCH.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = 0,
        .bottom = 0,
        .right  = [Dimens GDimens:unitw-unith],
    };
    [self.Btn_INCH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Btn_MS.mas_centerY).offset(-[Dimens GDimens:0]);
        make.left.equalTo(self.Btn_MS.mas_right).offset([Dimens GDimens:20]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:unitw], [Dimens GDimens:unith]));
    }];
    
    
    [self flashDelayUnitSel_I];
}

- (void)flashDelayUnitSel_I{
    
    [self.Btn_CM setImage:[[UIImage imageNamed:@"delay_unit_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.Btn_MS setImage:[[UIImage imageNamed:@"delay_unit_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.Btn_INCH setImage:[[UIImage imageNamed:@"delay_unit_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    

    
    switch (delayUnit) {
        case 1:
            [self.Btn_CM setImage:[[UIImage imageNamed:@"delay_unit_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            break;
        case 2:
            [self.Btn_MS setImage:[[UIImage imageNamed:@"delay_unit_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            break;
        case 3:
            [self.Btn_INCH setImage:[[UIImage imageNamed:@"delay_unit_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}

#pragma 保存
- (void)BtnSave_CLick:(NormalButton*)sender{
    NSString *Str;
    UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Master_PresetSave"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    for(int i=1;i<=MAX_USE_GROUP;i++){
        Str = [NSString stringWithFormat:@"%d.%@",i,[self getSEFFNameN:(i)]];
        [alert addAction:[UIAlertAction actionWithTitle:Str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            mGroup=i;
            [self ShowSEFFSaveDialog];
        }]];
    }
    
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

//音效选择，保存
- (void)ShowSEFFSaveDialog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[LANG DPLocalizedString:@"L_Master_PresetSave"] message:[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"]preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        seffName = [self getSEFFName:(mGroup)];
        textField.keyboardType=UIKeyboardTypeAlphabet;//UIKeyboardTypeASCIICapable
        textField.textColor= [UIColor redColor];
        textField.text=[self getSEFFName:(mGroup)];//[LANG DPLocalizedString:@"L_Master_PresetSaveMsg"];
        //输入框文字改变时 方法
        [textField addTarget:self action:@selector(usernameDidChange:)forControlEvents:UIControlEventEditingChanged];
        
    }];
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_OK"]style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //NSLog(@"seffName.length=%lu",seffName.length);
        if(seffName.length > 0){
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSData* bytes = [seffName dataUsingEncoding:enc];
            Byte * sendName = (Byte *)[bytes bytes];
            //NSLog(@"bytes.length=%lu",bytes.length);
            for (int i=0; i<13; i++){
                if (i<bytes.length){
                    RecStructData.USER[mGroup].name[i] = *(sendName+i);
                }else{
                    RecStructData.USER[mGroup].name[i] = '\0';
                }
            }
        }else{
            for (int i=0; i<13; i++){
                RecStructData.USER[mGroup].name[i] = '\0';
            }
        }

        [_mDataTransmitOpt SEFF_Save:mGroup];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[LANG DPLocalizedString:@"L_System_Cancel"]style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//输入框文字改变时 方法
-(void)usernameDidChange:(UITextField *)fd{
    if(fd.text.length > 13){
        fd.text = seffName;
    }
    NSLog(@"%@",fd.text);
    seffName = fd.text;
}

-(NSString *) getSEFFName:(int)group{
    BOOL haveName=FALSE;
    for(int i=0;i<13;i++){
        if(RecStructData.USER[group].name[i] != 0){
            haveName=true;
        }
    }
    NSString *groupName = @"";
    if(haveName){
        int nullCount = 0;
        for (int i=0; i<14; i++) {
            if (RecStructData.USER[group].name[i] == '\0') {
                if (i==13) {
                    nullCount = 13;
                }
                break;
            }else {
                nullCount++;
            }
        }
        
        //声明一个gbk编码类型
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //使用如下方法 将获取到的数据按照gbkEncoding的方式进行编码，结果将是正常的汉字
        groupName = [[NSString alloc] initWithBytes:RecStructData.USER[group].name length:nullCount encoding:gbkEncoding];
    }else{
        groupName = @"";
    }
    
    return groupName;
}


-(NSString *) getSEFFNameN:(int)group{
    BOOL haveName=FALSE;
    for(int i=0;i<13;i++){
        if(RecStructData.USER[group].name[i] != 0){
            haveName=true;
        }
    }
    NSString *groupName = @"";
    if(haveName){
        int nullCount = 0;
        for (int i=0; i<14; i++) {
            if (RecStructData.USER[group].name[i] == '\0') {
                if (i==13) {
                    nullCount = 13;
                }
                break;
            }else {
                nullCount++;
            }
        }
        
        //声明一个gbk编码类型
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //使用如下方法 将获取到的数据按照gbkEncoding的方式进行编码，结果将是正常的汉字
        groupName = [[NSString alloc] initWithBytes:RecStructData.USER[group].name length:nullCount encoding:gbkEncoding];
    }else{
        groupName = [LANG DPLocalizedString:[NSString stringWithFormat:@"L_Master_Preset%d",(group)]];
    }
    
    return groupName;
}

#pragma 广播通知
- (void)setDelayUnit:(int)val{
    DelayItem *item;
    for(int i=0;i<Output_CH_MAX_USE;i++){
        item = (DelayItem *)[self.view viewWithTag:i+TagStart_DelayItem_Self];
        [item setDelayItemVal:RecStructData.OUT_CH[i].delay];
        [item setDelayItemDelayUnit:val];
    }
}


- (void)FlashPageUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self FlashPageUI_];
    });
}
- (void)FlashPageUI_{
    
    DelayItem *item;
    for(int i=0;i<Output_CH_MAX_USE;i++){
        item = (DelayItem *)[self.view viewWithTag:i+TagStart_DelayItem_Self];
        [item setDelayItemVal:RecStructData.OUT_CH[i].delay];
    }
}

//更新UI界面
- (void)UpdateMasterViewUI:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self FlashPageUI];
    });
}




@end
