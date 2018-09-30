//
//  SourceItem.h
//  PXE-X09
//
//  Created by chs on 2018/9/17.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^itemClickBlock)(BOOL isSelected,NSInteger itemTag);
@interface SourceItem : UIView
@property(nonatomic,strong)UIImageView *logoImage;
@property(nonatomic,strong)UILabel *SoucreTitle;
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)itemClickBlock selectBlock;

-(void)flashSelect:(BOOL)isChoose;
@end
