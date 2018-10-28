//
//  LinkTool.m
//  PXE-X09
//
//  Created by celine on 2018/10/24.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "LinkTool.h"


@implementation LinkTool
+ (instancetype)shareManager
{
    static LinkTool *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[LinkTool alloc]init];
    });
    return share;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化对象
    }
    return self;
}
//-(NSMutableArray *)inLinks{
//    if (_inLinks.count<8) {
//        _inLinks=[[NSMutableArray alloc]init];
//        for (int i=0; i<8; i++) {
//            [_inLinks addObject:@(0)];
//        }
//    }
//    return _inLinks;
//}
-(NSMutableArray *)inAutoLinks{
    if (!_inAutoLinks) {
        _inAutoLinks=[[NSMutableArray alloc]init];
    }
    return _inAutoLinks;
}
//-(NSMutableArray *)outLinks{
//    if (_outLinks.count<8) {
//        _outLinks=[[NSMutableArray alloc]init];
//        for (int i=0; i<8; i++) {
//            [_outLinks addObject:@(0)];
//        }
//    }
//    return _outLinks;
//}
-(NSMutableArray *)outAutoLinks{
    if (!_outAutoLinks) {
        _outAutoLinks=[[NSMutableArray alloc]init];
    }
    return _outAutoLinks;
}
@end
