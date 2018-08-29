//
//  DelayCollectionViewCell.h
//  HH-RDDSP
//
//  Created by chs on 2018/3/27.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelayCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UILabel *chLab;
@property (nonatomic,strong)UILabel *volValue;
@property (nonatomic,strong)UISlider *delaySlider;
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)void (^valueChangeBlock)(UISlider *slider,UILabel *valueLab,NSInteger selectIndex);
@end

