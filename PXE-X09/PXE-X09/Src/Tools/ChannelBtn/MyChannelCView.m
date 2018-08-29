//
//  MyChannelCView.m
//  JH-DBP4106-PP42DSP
//
//  Created by chs on 2017/11/16.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "MyChannelCView.h"
#import "channelCollectionViewCell.h"
#import "MacDefine.h"
@implementation MyChannelCView
-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
-(void)setup{
 
    
    
    UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc]init];
    flow.itemSize=CGSizeMake(KScreenWidth/6, self.channelColletionView.frame.size.height);
    //水平方向
    flow.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    flow.minimumLineSpacing=0;
    flow.minimumInteritemSpacing=0;
    self.channelColletionView=[[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:flow];
    self.channelColletionView.backgroundColor=[UIColor clearColor];
    self.channelColletionView.delegate=self;
    self.channelColletionView.dataSource=self;
    [self addSubview:self.channelColletionView];
    //是否允许滑动
    //        self.channelColletionView.scrollEnabled=YES;
    
    [self.channelColletionView registerClass:[channelCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    self.channelColletionView.showsHorizontalScrollIndicator=NO;
    self.channelColletionView.showsVerticalScrollIndicator=NO;
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    line1.backgroundColor=SetColor(Color_Channellis_line);
//    [self addSubview:line1];
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    line2.backgroundColor=SetColor(Color_Channellis_line);
//    [self addSubview:line2];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==self.channelColletionView) {
        return Output_CH_MAX_USE;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"cellid";
    channelCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    cell.titleLabel.text=[NSString stringWithFormat:@"CH%d",(int)indexPath.row+1];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    output_channel_sel = (int)indexPath.row;
    
    self.selectedIndex((int)indexPath.row);
    
}
//每个小控件的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.frame.size.width/6, self.channelColletionView.frame.size.height);
}
//控件与控件之间的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(void)MyChannelReload{
    [self reloadChannelColletion:output_channel_sel];
}
-(void)reloadChannelColletion:(int)index{
        NSIndexPath  *selectedIndex=[NSIndexPath indexPathForRow:index inSection:0];
        [self.channelColletionView selectItemAtIndexPath:selectedIndex animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
