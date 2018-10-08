//
//  SingleChItem.m
//  PXE-X09
//
//  Created by celine on 2018/10/5.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "SingleChItem.h"

@implementation SingleChItem
- (instancetype)init{
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
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
