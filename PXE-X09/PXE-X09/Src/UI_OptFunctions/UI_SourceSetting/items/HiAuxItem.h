//
//  HiAuxItem.h
//  PXE-X09
//
//  Created by chs on 2018/9/28.
//  Copyright © 2018年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HiAuxItem : UIControl

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *typeImageView;
@property(nonatomic,strong)UILabel *typeName;

-(void)setPress;
-(void)setNormal;
@end

NS_ASSUME_NONNULL_END
