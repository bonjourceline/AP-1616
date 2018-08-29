//
//  LocalEffectTableViewCell.h
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/6.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconButton.h"
#import "MacDefine.h"
#import "Define_Dimens.h"
#import "Define_Color.h"
#import "Masonry.h"
#import "LANG.h"
#import "KxMenu.h"
#import "MacDefine.h"
#import "KGModal.h"
#import "NormalButton.h"
#import "Define_NSNotification.h"
#import "Dimens.h"
@protocol LocalEffectTableViewCellDelegate <NSObject>

- (void)selectedRowClick:(NSInteger)tag;

@end


@interface LocalEffectTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isCheck;

@property (weak, nonatomic) id<LocalEffectTableViewCellDelegate> delegate;

@property (nonatomic,strong) UILabel *effectTitleLabel;

@property (nonatomic,strong) UILabel *singleLabel;

@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *uploadTimeLabel;

@property (nonatomic,strong) UIButton *multiCheckBtn;

@property (nonatomic,strong) UIButton *collectionIconCellBtn;
@property (nonatomic,strong) UIButton *likeIconCellBtn;

@property (nonatomic,strong) UIButton  *popMenuBtn;

@property (nonatomic,strong) UIView *effectOpView;
@property (nonatomic,strong) IconButton  *applicationBtn;
@property (nonatomic,strong) IconButton  *shareBtn;
@property (nonatomic,strong) IconButton  *collectionBtn;
@property (nonatomic,strong) IconButton  *likeBtn;
@property (nonatomic,strong) IconButton  *deleteBtn;
@property (nonatomic,strong) IconButton  *detailBtn;

@property (nonatomic,assign) CGFloat cellHeight;



@end
