//
//  MyChannelCView.h
//  JH-DBP4106-PP42DSP
//
//  Created by chs on 2017/11/16.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyChannelCView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *channelColletionView;
//选中回调
@property (nonatomic,strong)void(^selectedIndex)(int row);
//刷新选中位置
-(void)MyChannelReload;
//选择刷新选中位置
-(void)reloadChannelColletion:(int)index;
@end
