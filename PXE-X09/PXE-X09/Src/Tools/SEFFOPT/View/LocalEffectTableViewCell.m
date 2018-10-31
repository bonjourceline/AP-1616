//
//  LocalEffectTableViewCell.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/6.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "LocalEffectTableViewCell.h"
#import "Masonry.h"
#import "MacDefine.h"
#define kMarginTop 10
#define kMarginLeft 10
#define kMarginRight 10

#define kTitleLabelW (0.5*KScreenWidth)
#define kTitleLabelH 25

#define kUserNameLabelW 60
#define kUserNameLabelH 25

#define kDetailLabelW (0.5*KScreenWidth)
#define kDetailLabelH 25

#define kIconW 30
#define kIconH 30

#define kEffectOpBtnW 50
#define kEffectOpBtnH 50

#define kEffectOpViewW kWindowW
//#define kEffectOpViewH 2*(kMarginTop+kEffectOpInBtnH)+kMarginTop
#define kEffectOpViewH (kMarginTop+kEffectOpInBtnH)+kMarginTop
#define kEffectOpInBtnW 60
#define kEffectOpInBtnH 45

#define kEffectOpInBtnMargin (KScreenWidth-5*kEffectOpInBtnW)/6


@implementation LocalEffectTableViewCell

//去掉awakeFromNib会出现问题
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.isOpen = FALSE;
        self.isCheck = FALSE;
        self.backgroundColor = SetColor(UI_SystemBgColor);
    }
    
    return self;
}

#pragma mark - 懒加载并布局

- (UIButton *)multiCheckBtn {
    if (!_multiCheckBtn) {
        _multiCheckBtn = [UIButton new];
        [self.contentView addSubview:_multiCheckBtn];
        [_multiCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((kMarginTop+kTitleLabelH+kUserNameLabelH-kIconH)*0.5);
            make.left.mas_equalTo(kMarginLeft);
            make.size.mas_equalTo(CGSizeMake(kIconW, kIconH));
        }];
        
        // [_multiCheckBtn setBackgroundImage:[UIImage imageNamed:@"seff_sel_normal"] forState:UIControlStateNormal];
        //        [_multiCheckBtn setImage:[UIImage imageNamed:@"seff_sel_press"] forState:UIControlStateNormal];
    }
    return _multiCheckBtn;
}



- (UILabel *)effectTitleLabel {
    if (!_effectTitleLabel) {
        _effectTitleLabel = [UILabel new];
        [self.contentView addSubview:_effectTitleLabel];
        [_effectTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kMarginTop);
            make.left.mas_equalTo(self.multiCheckBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(kTitleLabelW*0.8, kTitleLabelH));
        }];
        _effectTitleLabel.textColor = SetColor(UI_SEFFItemTitle_Color);
        
    }
    return _effectTitleLabel;
}


- (UILabel *)singleLabel {
    if (!_singleLabel) {
        _singleLabel = [UILabel new];
        [self.contentView addSubview:_singleLabel];
        [_singleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.effectTitleLabel.mas_centerY);
            make.left.mas_equalTo(self.effectTitleLabel.mas_right);
            //            make.size.mas_equalTo(CGSizeMake(3*kTitleLabelH, kTitleLabelH));
        }];
        _singleLabel.font = [UIFont systemFontOfSize:14.0];
        _singleLabel.textColor = SetColor(UI_SEFFFItem_Color);
        
        
    }
    return _singleLabel;
}


- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [UILabel new];
        [self.contentView addSubview:_userNameLabel];
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.effectTitleLabel.mas_bottom);
            make.left.mas_equalTo(self.multiCheckBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(kUserNameLabelW, kUserNameLabelH));
        }];
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.font = [UIFont systemFontOfSize:12.0];
        _userNameLabel.textColor = SetColor(UI_SEFFFItem_Color);
    }
    return _userNameLabel;
}


- (UILabel *)uploadTimeLabel {
    if (!_uploadTimeLabel) {
        _uploadTimeLabel = [UILabel new];
        [self.contentView addSubview:_uploadTimeLabel];
        [_uploadTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.effectTitleLabel.mas_bottom);
            make.left.mas_equalTo(self.userNameLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(kDetailLabelW, kDetailLabelH));
        }];
        _uploadTimeLabel.textAlignment = NSTextAlignmentLeft;
        _uploadTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _uploadTimeLabel.textColor = SetColor(UI_SEFFFItemTime_Color);
    }
    return _uploadTimeLabel;
}

- (UIButton *)popMenuBtn {
    if (!_popMenuBtn) {
        _popMenuBtn = [UIButton new];
        [self.contentView addSubview:_popMenuBtn];
        [_popMenuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((kMarginTop+kTitleLabelH+kUserNameLabelH-40)*0.5);
            make.right.mas_equalTo(self.mas_right).mas_equalTo(-kMarginRight);
            make.size.mas_equalTo(CGSizeMake(kEffectOpBtnW, kEffectOpBtnH));
        }];
        [_popMenuBtn setImage:[UIImage imageNamed:@"seff_menu"] forState:UIControlStateNormal];
        [_popMenuBtn addTarget:self action:@selector(doOpenMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popMenuBtn;
}
- (UIButton *)likeIconCellBtn {
    if (!_likeIconCellBtn) {
        _likeIconCellBtn = [UIButton new];
        [self.contentView addSubview:_likeIconCellBtn];
        [_likeIconCellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.mas_equalTo(kMarginTop);
            make.centerY.mas_equalTo(self.popMenuBtn.mas_centerY);
            make.right.mas_equalTo(self.popMenuBtn.mas_left).mas_equalTo(-kMarginRight/2-[Dimens GDimens:10]);
            make.size.mas_equalTo(CGSizeMake(kIconW, kIconH));
        }];
        
        [_likeIconCellBtn setImage:[UIImage imageNamed:@"seff_love_press"] forState:UIControlStateNormal];
    }
    return _likeIconCellBtn;
}

- (UIButton *)collectionIconCellBtn {
    if (!_collectionIconCellBtn) {
        _collectionIconCellBtn = [UIButton new];
        [self.contentView addSubview:_collectionIconCellBtn];
        [_collectionIconCellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.mas_equalTo(kMarginTop);
            make.centerY.mas_equalTo(self.popMenuBtn.mas_centerY);
            make.right.mas_equalTo(self.likeIconCellBtn.mas_left).mas_equalTo(-kMarginRight/2);
            make.size.mas_equalTo(CGSizeMake(kIconW, kIconH));
        }];
        
        [_collectionIconCellBtn setImage:[UIImage imageNamed:@"seff_favorite_press"] forState:UIControlStateNormal];
    }
    return _collectionIconCellBtn;
}



//效果分享等操作
- (UIView *)effectOpView {
    if (!_effectOpView) {
        _effectOpView = [UIView new];
        [self.contentView addSubview:_effectOpView];
        [_effectOpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.uploadTimeLabel.mas_bottom);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, kEffectOpViewH));
        }];
        _effectOpView.backgroundColor = SetColor(UI_TSEFFFOpenBgColor);//QIZColor(100,100,100);
    }
    return _effectOpView;
}

- (IconButton *)applicationBtn {
    if (!_applicationBtn) {
        _applicationBtn = [IconButton new];
        [self.effectOpView addSubview:_applicationBtn];
        [_applicationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kMarginTop);
            make.left.mas_equalTo(kEffectOpInBtnMargin);
            make.size.mas_equalTo(CGSizeMake(kEffectOpInBtnW, kEffectOpInBtnH));
        }];
        _applicationBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_applicationBtn setImage:[UIImage imageNamed:@"seff_apply"] forState:UIControlStateNormal];
    }
    return _applicationBtn;
}

- (IconButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [IconButton new];
        [self.effectOpView addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kMarginTop);
            make.left.mas_equalTo(self.applicationBtn.mas_right).mas_equalTo(kEffectOpInBtnMargin);
            make.size.mas_equalTo(CGSizeMake(kEffectOpInBtnW, kEffectOpInBtnH));
        }];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_shareBtn setImage:[UIImage imageNamed:@"seff_share"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

//- (IconButton *)collectionBtn {
//    if (!_collectionBtn) {
//        _collectionBtn = [IconButton new];
//        [self.effectOpView addSubview:_collectionBtn];
//        [_collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(kMarginTop);
//            make.left.mas_equalTo(self.shareBtn.mas_right).mas_equalTo(kEffectOpInBtnMargin);
//            make.size.mas_equalTo(CGSizeMake(kEffectOpInBtnW, kEffectOpInBtnH));
//        }];
//        _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
//        [_collectionBtn setImage:[UIImage imageNamed:@"seff_favorite"] forState:UIControlStateNormal];
//    }
//    return _collectionBtn;
//}

- (IconButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [IconButton new];
        [self.effectOpView addSubview:_likeBtn];
        [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.mas_equalTo(kMarginTop);
            //            make.left.mas_equalTo(self.collectionBtn.mas_right).mas_equalTo(kEffectOpInBtnMargin);
            //            make.size.mas_equalTo(CGSizeMake(kEffectOpInBtnW, kEffectOpInBtnH));
            make.top.mas_equalTo(kMarginTop);
            make.left.mas_equalTo(self.shareBtn.mas_right).mas_equalTo(kEffectOpInBtnMargin);
            make.size.mas_equalTo(CGSizeMake(kEffectOpInBtnW, kEffectOpInBtnH));
        }];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_likeBtn setImage:[UIImage imageNamed:@"seff_love"] forState:UIControlStateNormal];
    }
    return _likeBtn;
}


- (IconButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [IconButton new];
        [self.effectOpView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kMarginTop);
            
            //            make.left.mas_equalTo(self.likeBtn.mas_right).mas_equalTo(kEffectOpInBtnMargin);
            make.left.mas_equalTo(self.detailBtn.mas_right).mas_equalTo(kEffectOpInBtnMargin);
            make.size.mas_equalTo(CGSizeMake(kEffectOpInBtnW, kEffectOpInBtnH));
        }];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_deleteBtn setImage:[UIImage imageNamed:@"seff_delete"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

- (IconButton *)detailBtn {
    if (!_detailBtn) {
        _detailBtn = [IconButton new];
        [self.effectOpView addSubview:_detailBtn];
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kMarginTop);
            make.left.mas_equalTo(self.likeBtn.mas_right).mas_equalTo(kEffectOpInBtnMargin);
            make.size.mas_equalTo(CGSizeMake(kEffectOpInBtnW, kEffectOpInBtnH));
            //            make.top.mas_equalTo(self.applicationBtn.mas_bottom).mas_equalTo(kMarginTop);
            //            make.left.mas_equalTo(kEffectOpInBtnMargin);
            //            make.size.mas_equalTo(CGSizeMake(kEffectOpInBtnW, kEffectOpInBtnH));
        }];
        _detailBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_detailBtn setImage:[UIImage imageNamed:@"seff_details"] forState:UIControlStateNormal];
    }
    return _detailBtn;
}





// 本Cell行高
- (CGFloat)cellHeight {
    
    if (self.isOpen) {
        return kMarginTop+kTitleLabelH+kUserNameLabelH+kEffectOpViewH;
    }
    else{
        return kMarginTop+kTitleLabelH+kUserNameLabelH;
    }
    
    return kMarginTop+kTitleLabelH+kUserNameLabelH;
    
}


//监听方法
-(void)doOpenMenu:(UIButton *)sender
{
    //    if ([_delegate respondsToSelector:@selector(setOpenMenu:)]) {
    //        UITableView *table = (UITableView *)self.superview;
    //        NSIndexPath * path = [table indexPathForCell:self];
    //        [_delegate setOpenMenu:path];
    //    }
    
    if ([_delegate respondsToSelector:@selector(selectedRowClick:)]) {
        [_delegate selectedRowClick:self.tag];
    }
    
    
}

@end
