//
//  DoubleChTableViewCell.m
//  PXE-X09
//
//  Created by celine on 2018/10/12.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "DoubleChTableViewCell.h"

@implementation DoubleChTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    
    return self;
}
-(void)initView{
    self.backgroundColor=[UIColor clearColor];
    self.item=[[DoubleChItem alloc]init];
    [self.contentView addSubview:self.item];
    [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
