//
//  SingleChItem.h
//  PXE-X09
//
//  Created by celine on 2018/10/5.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalButton.h"
#import "VolumeCircleIMLine.h"
NS_ASSUME_NONNULL_BEGIN

@interface SingleChItem : UIControl
@property (nonatomic,strong)UIImageView *sourceImage;
@property (nonatomic,strong)UILabel *chName;
@property (nonatomic,strong)NormalButton *spkBtn;
@property (nonatomic,strong)NormalButton *eqBtn;
@property (nonatomic,strong)VolumeCircleIMLine *sbVol;
@property (nonatomic,strong)UIButton *volBtn;
@property (nonatomic,strong)NormalButton *muteBtn;
@property (nonatomic,strong)UIView *flgView;
@property (nonatomic,strong)UIView *lineTop;
@property (nonatomic,strong)UIView *lineBottom;
@property (nonatomic,strong)NSArray *ImageArray;
@property (nonatomic,strong)void (^eqblock)(int index);
@property (nonatomic,strong)void (^reloadblock)(void);
-(void)setChannelIndex:(int)index;
-(void)flashView;
@end

NS_ASSUME_NONNULL_END
