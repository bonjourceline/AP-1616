//
//  DelayViewController_Ch.m
//  HH-RDDSP
//
//  Created by chs on 2018/3/20.
//  Copyright © 2018年 dsp. All rights reserved.
//
#define itemMargin  20
#import "DelayViewController_Ch.h"
#import "DelayTableViewCell.h"
#import "DelayCollectionViewCell.h"
#import "Masonry.h"
#import "Dimens.h"
#import "MacDefine.h"
#import "Define_Color.h"
#import "LANG.h"
#import "Define_Dimens.h"

@interface DelayViewController_Ch ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    int delayUnit;
    
}
@property (nonatomic,strong)UITableView *channelTableView;
@property (nonatomic,strong)UICollectionView *channelCollection;
@end

@implementation DelayViewController_Ch
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CurPage = UI_Page_Delay;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mToolbar.lab_Title.text=[LANG DPLocalizedString:@"L_TabBar_Delay"];
        [self creatTableView];
    
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //更新UI
    [center addObserver:self selector:@selector(FlashPageUI) name:MyNotification_UpdateUI object:nil];
//    [self creatCollectionView];
    // Do any additional setup after loading the view.
    [self creatDelayUnitView];
}
-(void)creatCollectionView{
    
    UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc]init];
    flow.itemSize=CGSizeMake((KScreenWidth-(3*[Dimens GDimens:itemMargin]))/2, [Dimens GDimens:90]);
    //水平方向
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    //    flow.minimumLineSpacing=[Dimens GDimens:itemMargin];
    //    flow.minimumInteritemSpacing=[Dimens GDimens:itemMargin];
    self.channelCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0,20+[Dimens GDimens:44], KScreenWidth, KScreenHeight-(20+[Dimens GDimens:44])-self.tabBarController.tabBar.frame.size.height-[Dimens GDimens:100]) collectionViewLayout:flow];
    [self.view addSubview:self.channelCollection];
    self.channelCollection.backgroundColor=[UIColor clearColor];
    self.channelCollection.delegate=self;
    self.channelCollection.dataSource=self;
    [self.channelCollection registerClass:[DelayCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    //是否允许滑动
    self.channelCollection.scrollEnabled=YES;
    self.channelCollection.showsHorizontalScrollIndicator=NO;
    self.channelCollection.showsVerticalScrollIndicator=NO;
    [self.channelCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mToolbar.mas_bottom).offset([Dimens GDimens:20]);
        make.centerX.equalTo(self.view.mas_centerX);
        if(KScreenHeight==812){
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, KScreenHeight-CGRectGetMaxY(self.mToolbar.frame)-self.tabBarController.tabBar.frame.size.height-[Dimens GDimens:80]-40-[Dimens GDimens:20]));
        }else{
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, KScreenHeight-CGRectGetMaxY(self.mToolbar.frame)-self.tabBarController.tabBar.frame.size.height-[Dimens GDimens:80]-[Dimens GDimens:20]));
        }
        
    }];
}
-(void)creatTableView{
        self.channelTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-CGRectGetMaxY(self.mToolbar.frame)-self.tabBarController.tabBar.frame.size.height-[Dimens GDimens:100])];
        [self.view addSubview:self.channelTableView];
        self.channelTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.channelTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mToolbar.mas_bottom);
            make.centerX.equalTo(self.view.mas_centerX);
            if(KScreenHeight==812){
                make.size.mas_equalTo(CGSizeMake(KScreenWidth, KScreenHeight-CGRectGetMaxY(self.mToolbar.frame)-self.tabBarController.tabBar.frame.size.height-[Dimens GDimens:80]-40));
            }else{
                make.size.mas_equalTo(CGSizeMake(KScreenWidth, KScreenHeight-CGRectGetMaxY(self.mToolbar.frame)-self.tabBarController.tabBar.frame.size.height-[Dimens GDimens:80]));
            }
    
        }];
    self.channelTableView.backgroundColor=[UIColor clearColor];
    self.channelTableView.delegate=self;
    self.channelTableView.dataSource=self;
    
    [self.channelTableView registerNib:[UINib nibWithNibName:@"DelayTableViewCell" bundle:nil] forCellReuseIdentifier:@"DelayTableViewCell"];
}
//按钮
-(void)creatDelayUnitView{
    delayUnit=2;
    self.BtnMS = [[NormalButton alloc]init];
    [self.view addSubview:self.BtnMS];
    self.BtnCM = [[NormalButton alloc]init];
    [self.view addSubview:self.BtnCM];
    self.BtnINCH = [[NormalButton alloc]init];
    [self.view addSubview:self.BtnINCH];
    
    [self.BtnCM setTag:1];
    [self.BtnMS setTag:2];
    [self.BtnINCH setTag:3];
    
    [self.BtnCM addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnMS addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnINCH addTarget:self action:@selector(delayUnitSel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BtnCM setTitle:[LANG DPLocalizedString:@"L_Delay_CM"] forState:UIControlStateNormal];
    [self.BtnMS setTitle:[LANG DPLocalizedString:@"L_Delay_MS"] forState:UIControlStateNormal];
    [self.BtnINCH setTitle:[LANG DPLocalizedString:@"L_Delay_Inch"] forState:UIControlStateNormal];
    
    
    [self.BtnMS initViewBroder:0
               withBorderWidth:0
               withNormalColor:UI_DelayBtn_NormalIN
                withPressColor:UI_DelayBtn_PressIN
         withBorderNormalColor:UI_DelayBtn_Normal
          withBorderPressColor:UI_DelayBtn_Press
           withTextNormalColor:UI_DelayBtnText_Normal
            withTextPressColor:UI_DelayBtnText_Press
                      withType:4];
    self.BtnMS.titleLabel.font = [UIFont systemFontOfSize:13];
    self.BtnMS.titleLabel.adjustsFontSizeToFitWidth = true;
    
    [self.BtnMS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.channelTableView.mas_bottom).offset([Dimens GDimens:20]);
        make.centerX.equalTo(self.view.mas_centerX).offset([Dimens GDimens:0]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:DelayBtnWidth], [Dimens GDimens:DelayBtnHeight]));
    }];
    
    [self.BtnCM initViewBroder:0
               withBorderWidth:0
               withNormalColor:UI_DelayBtn_NormalIN
                withPressColor:UI_DelayBtn_PressIN
         withBorderNormalColor:UI_DelayBtn_Normal
          withBorderPressColor:UI_DelayBtn_Press
           withTextNormalColor:UI_DelayBtnText_Normal
            withTextPressColor:UI_DelayBtnText_Press
                      withType:4];
    self.BtnCM.titleLabel.font = [UIFont systemFontOfSize:13];
    self.BtnCM.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.BtnCM mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.BtnMS);
        make.left.equalTo(self.view.mas_left).offset([Dimens GDimens:25]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:DelayBtnWidth], [Dimens GDimens:DelayBtnHeight]));
    }];
    
    [self.BtnINCH initViewBroder:0
                 withBorderWidth:0
                 withNormalColor:UI_DelayBtn_NormalIN
                  withPressColor:UI_DelayBtn_PressIN
           withBorderNormalColor:UI_DelayBtn_Normal
            withBorderPressColor:UI_DelayBtn_Press
             withTextNormalColor:UI_DelayBtnText_Normal
              withTextPressColor:UI_DelayBtnText_Press
                        withType:4];
    
    self.BtnINCH.titleLabel.font = [UIFont systemFontOfSize:13];
    self.BtnINCH.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.BtnINCH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.BtnCM.mas_centerY).offset([Dimens GDimens:0]);
        make.right.equalTo(self.view.mas_right).offset([Dimens GDimens:-25]);
        make.size.mas_equalTo(CGSizeMake([Dimens GDimens:DelayBtnWidth], [Dimens GDimens:DelayBtnHeight]));
    }];
    [self flashDelayUnitSel_T];
}
#pragma mark------------点击
- (void)delayUnitSel:(UIButton*)sender{
    delayUnit = (int)sender.tag;
    //[self flashDelayUnitSel];
    [self flashDelayUnitSel_T];
    
}

- (void)flashDelayUnitSel_T{
    
    [self.BtnCM setNormal];
    [self.BtnMS setNormal];
    [self.BtnINCH setNormal];
    
    switch (delayUnit) {
        case 1:
            [self.BtnCM setPress];
            break;
        case 2:
            [self.BtnMS setPress];
            break;
        case 3:
            [self.BtnINCH setPress];
            break;
        default:
            break;
    }
    //    [self FlashDelayVolume];
    [self.channelTableView reloadData];
//    [self.channelCollection reloadData];
}
#pragma mark ----collectionviewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return Output_CH_MAX_USE;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"cellid";
    DelayCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    cell.chLab.text=[NSString stringWithFormat:@"CH%ld",indexPath.row+1];
    cell.volValue.text=[self getDelayVal:(int)indexPath.row];
    cell.selectIndex=indexPath.row;
    cell.delaySlider.value=RecStructData.OUT_CH[indexPath.row].delay;
    __block typeof(self) weakself=self;
    cell.valueChangeBlock = ^(UISlider *slider, UILabel *valueLab, NSInteger selectIndex) {
        NSLog(@"当前移动的%d",(int)selectIndex);
        output_channel_sel=(int)selectIndex;
        int sliderValue=(int)slider.value;
        AutoLinkValue=sliderValue-RecStructData.OUT_CH[output_channel_sel].delay;
        NSLog(@"AutoLinkValue---%d",AutoLinkValue);
        RecStructData.OUT_CH[output_channel_sel].delay = sliderValue;
        valueLab.text=[weakself getDelayVal:output_channel_sel];
//        [weakself flashLinkSyncData_Delay:AutoLinkValue];
    };
    //    cell.titleLabel.text=[NSString stringWithFormat:@"CH%d",(int)indexPath.row+1];
    
    return cell;
}
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//
//
////    self.selectedIndex((int)indexPath.row);
//
//}
//每个小控件的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth-(3*[Dimens GDimens:itemMargin]))/2, [Dimens GDimens:90]);
}
//控件与控件之间的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, [Dimens GDimens:20], 0, [Dimens GDimens:20]);
}
#pragma mark ----tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Dimens GDimens:100];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Output_CH_MAX_USE;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"DelayTableViewCell";
    DelayTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    cell.CHName.text=[NSString stringWithFormat:@"CH%ld",(indexPath.row+1)];
    cell.volLab.text=[self getDelayVal:(int)indexPath.row];
    cell.volSlider.value=RecStructData.OUT_CH[indexPath.row].delay;
    cell.channelIndex=indexPath.row;
    __block typeof(self) weakself=self;
    cell.subBlock = ^(UISlider *slider, UILabel *valueLab) {
        output_channel_sel=(int)indexPath.row;
        if(--RecStructData.OUT_CH[output_channel_sel].delay < 0){
            RecStructData.OUT_CH[output_channel_sel].delay = 0;
        }else{
            AutoLinkValue=-1;
//            [self flashLinkSyncData_Delay:AutoLinkValue];
        }
        slider.value=RecStructData.OUT_CH[output_channel_sel].delay;
        valueLab.text=[weakself getDelayVal:(int)indexPath.row];
    };
    
    cell.addBlock = ^(UISlider *slider, UILabel *valueLab) {
        output_channel_sel=(int)indexPath.row;
        if(++RecStructData.OUT_CH[output_channel_sel].delay > DELAY_SETTINGS_MAX){
            RecStructData.OUT_CH[output_channel_sel].delay = DELAY_SETTINGS_MAX;
        }else{
            AutoLinkValue=1;
//            [self flashLinkSyncData_Delay:AutoLinkValue];
        }
        valueLab.text=[self getDelayVal:(int)indexPath.row];
        slider.value=RecStructData.OUT_CH[output_channel_sel].delay;
    };
    cell.valueChangeBlock = ^(UISlider *slider, UILabel *valueLab) {
        
        output_channel_sel=(int)indexPath.row;
        NSLog(@"output_channel_sel--------%d",output_channel_sel);
        int sliderValue=(int)slider.value;
        NSLog(@"sliderValue-------%d",sliderValue);
        AutoLinkValue=sliderValue-RecStructData.OUT_CH[indexPath.row].delay;
        RecStructData.OUT_CH[output_channel_sel].delay = sliderValue;
        valueLab.text=[weakself getDelayVal:(int)indexPath.row];
//        [weakself flashLinkSyncData_Delay:AutoLinkValue];
    };
    return cell;
}



#pragma mark --------刷新
- (void)FlashPageUI{
    dispatch_async(dispatch_get_main_queue(), ^{
                [self.channelTableView reloadData];
//        [self.channelCollection reloadData];
        //        if (LinkMode==2) {
        //            [self CheckChannelCanLink];
        //        }
        //        [self FlashDelaySpk];
        //        [self FlashDelayVolume];
        //
        //        if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
        //            self.Encrypt.hidden = false;
        //        }else{
        //            self.Encrypt.hidden = true;
        //        }
    });
}
- (void)flashLinkSyncData_Delay:(int)val{
    if(BOOL_SET_SpkType){
        if((!(LinkMode==2))||(ChannelLinkCnt==0)){
            return;
        }
        int Dfrom=output_channel_sel;
        int Dto=0xff;
        Dfrom = output_channel_sel;
        for(int i=0;i<ChannelLinkCnt;i++){
            if(ChannelLinkBuf[i][0]==output_channel_sel){
                Dto=ChannelLinkBuf[i][1];
            }else if(ChannelLinkBuf[i][1]==output_channel_sel){
                Dto=ChannelLinkBuf[i][0];
            }
        }
        if(Dto < Output_CH_MAX){
            int newVal=RecStructData.OUT_CH[Dto].delay+val;
            if (newVal>DELAY_SETTINGS_MAX) {
                RecStructData.OUT_CH[Dto].delay=DELAY_SETTINGS_MAX;
            }else if (newVal<0){
                RecStructData.OUT_CH[Dto].delay=0;
            }else{
                RecStructData.OUT_CH[Dto].delay=newVal;
            }
            //            [self FlashDelayVolume];
                        [self.channelTableView reloadData];
//            [self.channelCollection reloadData];
        }
    }else{
        if ((BOOL_LINK)&&(LinkMODE==LINKMODE_AUTO)) {
            syncLinkData(UI_Delay);
            for (int i=0; i<Output_CH_MAX_USE; i++) {
//                DelayCollectionViewCell *cell=(DelayCollectionViewCell *)[self.channelCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                DelayTableViewCell *cell=(DelayTableViewCell *)[self.channelTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.volLab.text=[self getDelayVal:i];
                cell.volSlider.value=RecStructData.OUT_CH[i].delay;
            }
        }
    }
}
- (NSString*)getDelayVal:(int)ch{
    
    if(BOOL_ENCRYPTION && BOOL_EncryptionFlag){
        switch(delayUnit){
            case 1: return [self CountDelayCM:0]; break;
            case 2: return [self CountDelayMs:0]; break;
            case 3: return [self CountDelayInch:0]; break;
            default:return [self CountDelayMs:0];
        }
    }else{
        NSLog(@"RecStructData.OUT_CH[ch].delay-----%d",RecStructData.OUT_CH[ch].delay);
        switch(delayUnit){
            case 1: return [self CountDelayCM:RecStructData.OUT_CH[ch].delay]; break;
            case 2: return [self CountDelayMs:RecStructData.OUT_CH[ch].delay]; break;
            case 3: return [self CountDelayInch:RecStructData.OUT_CH[ch].delay]; break;
            default:return [self CountDelayMs:RecStructData.OUT_CH[ch].delay];
        }
    }
}
/******* 延时时间转换  *******/
- (NSString*) CountDelayCM:(int)num{
    int m_nTemp=75;
    float Time = (float) (num/48.0); //当Delay〈476时STEP是0.021MS；
    float LMT = (float) (((m_nTemp-50)*0.6+331.0)/1000.0*Time);
    LMT = LMT*100;
    
    int fr=(int) (LMT*10);
    int ir = fr%10;
    int ri = 0;
    if(ir>=5){
        ri=fr/10+1;
    }else{
        ri=fr/10;
    }
    
    return [NSString stringWithFormat:@"%d",(int)ri];
}
- (NSString*) CountDelayMs:(int)num{
    int fr = num*10000/48;
    int ir = fr%10;
    int ri = 0;
    if(ir>=5){
        ri=fr/10+1;
    }else{
        ri=fr/10;
    }
    return [NSString stringWithFormat:@"%.3f",(float)ri/1000];}

- (NSString*) CountDelayInch:(int)num{
    float base=(float) 331.0;
    if(num == DELAY_SETTINGS_MAX){
        base=(float) 331.4;
    }
    int m_nTemp=75;
    float Time = (float) (num/48.0); //当Delay〈476时STEP是0.021MS；
    float LMT = (float) (((m_nTemp-50)*0.6+base)/1000.0*Time);
    
    float LFT = (float) (LMT*3.2808*12.0);
    
    int fr=(int) (LFT*10);
    int ir = fr%10;
    int ri = 0;
    if(ir>=5){
        ri=fr/10+1;
    }else{
        ri=fr/10;
    }
    return [NSString stringWithFormat:@"%d",(int)ri];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

